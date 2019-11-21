within OpenHPL.Waterway;
model PenstockKP "Detailed model of the pipe. Could have elastic walls and compressible water. KP scheme"
  outer OpenHPL.Constants Const "using standart class with constants";
  extends OpenHPL.Icons.Pipe(    vertical=true);
  import Modelica.Constants.pi;
  //// geometrical parameters of the pipe
  parameter Modelica.SIunits.Height H = 420 "Height difference from the inlet to the outlet of the pipe" annotation (
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Length L = 600 "length of the pipe" annotation (
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Diameter D_i = 3.3 "Diametr from the inlet side of the pipe" annotation (
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Diameter D_o = D_i "Diametr from the outlet side of the pipe" annotation (
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Height eps = Const.eps "Pipe roughness height" annotation (
    Dialog(group = "Geometry"));
  //// condition of steady state
  parameter Boolean SteadyState = Const.Steady "if true - starts from Steady State" annotation (
    Dialog(group = "Initialization"));
  //// staedy state values for flow rate in all segments of the pipe
  parameter Modelica.SIunits.VolumeFlowRate V_dot0[N] = Const.V_0 * ones(N) "Initial flow rate in the pipe vector, m3/s" annotation (
    Dialog(group = "Initialization"));
  //// staedy state values for pressure in all segments of the pipe
  parameter Modelica.SIunits.Height h_s0 = 69 "Initial water head before the pipe, m" annotation (
    Dialog(group = "Initialization"));
  parameter Modelica.SIunits.Pressure p_p0[N]=  1.013e5 + 997 * 9.81 * (h_s0 + H / N / 2):997 * 9.81 * H / N:1.013e5 + 997 * 9.81 * (h_s0 + H / N * (N - 1 / 2)) "Initial presure vector, bar" annotation (
    Dialog(group = "Initialization"));
  //// segmentation of the pipe
  parameter Integer N = 10 "Number of segments" annotation (
    Dialog(group = "Discretization"));
  //// condition for elasticity
  parameter Boolean PipeElasticity = true "if checked - include pipe elasticity to the model" annotation (
    choices(checkBox = true),
    Dialog(group = "Properties"));
  //// variables
  Modelica.SIunits.Diameter dD = (D_i - D_o) / N "step in diameter change", D[N] = linspace(D_i + dD / 2, D_o - dD / 2, N) "centered diameter vector in atm. p.", D_[N + 1] = linspace(D_i, D_o, N + 1) "boundary diameter vector in atm. p.";
  Modelica.SIunits.Area A_atm[N] = D .* D * pi / 4 "centered cross are vector in atm. p.", A_atm_[N + 1] = D_ .* D_ * pi / 4 "boundary cross are vector in atm. p.", A[N] "centered cross are vector", A_[N, 4] "boundary cross are vector", _A_atm[N, 4] "boundary cross are matrix in atm. p.";
  Modelica.SIunits.Pressure p_p[N] "centered pressure", dp = Const.rho * Const.g * H / N "initial p. step", p_1 "left bound p.", p_2 "right bound p.", p_[N, 4] "boundary p. matrix";
  Modelica.SIunits.Length dx = L / N "length step", dh = H / N "height step";
  Modelica.SIunits.MassFlowRate m_dot[N](start = Const.rho * V_dot0) "centered mass flow", m_dot_R "left bound m_dot", m_dot_V "right bound m_dot", m_dot_[N, 4] "boundary m_dot matrix";
  Real U[2 * N] "centered states", U_[8, N] "boundary states", F_ap[N] "centered A*rho", F_ap_[N, 4] "bounddary A*rho", S_[2 * N] "source term", F_[2 * N, 4] "F matrix", lam1[N, 4] "eigenvalue '+'", lam2[N, 4] "eigenvalue '-'";
  Modelica.SIunits.Density rho[N] "centered density", rho_[N, 4] "boundary density";
  Modelica.SIunits.Velocity v_[N, 4] "bounds velocity", v[N] "centered velocity";
  Modelica.SIunits.VolumeFlowRate V_dot[N] "centered volumetric flow";
  Modelica.SIunits.Force F_f[N] "centered friction force vector";
  Real theta = 1.3 "parameter for slope limiter";
  extends OpenHPL.Interfaces.TwoContact;
public
  Functions.KP07.KPmethod KP(N = N, U = U, dx = dx, theta = theta, B = zeros(N + 4), S_ = S_, F_ = F_, lam1 = lam1, lam2 = lam2, boundary = [p_1, 0; p_2, 0], boundaryCon = [true, false; true, false]);
  // specify all variables which is needed for using KP method for solve PDE
initial equation
  if SteadyState == true then
    der(U[1:N]) = zeros(N);
    der(U[N + 2:2 * N - 1]) = zeros(N - 2);
  else
    m_dot[2:N - 1] = Const.rho * V_dot0[2:N - 1];
    p_p = p_p0;
  end if;
equation
  //// Pipe flow rate
  m_dot_R = p.m_dot;
  m_dot_V = -n.m_dot;
  //// pipe presurre
  p_1 = p.p;
  p_2 = n.p;
  //// state vector
  U[1:N] = p_p[:];
  U[N + 1:2 * N] = m_dot[:];
  //// Define variables, which are going to be used for souce term S_
  if PipeElasticity == true then
    F_ap = Const.rho * A_atm .* (ones(N) + Const.beta_total * (p_p - Const.p_a * ones(N)));
  else
    F_ap = Const.rho * A_atm .* (ones(N) + Const.beta * (p_p - Const.p_a * ones(N)));
  end if;
  v = m_dot ./ F_ap;
  rho = Const.rho * (ones(N) + Const.beta * (p_p - Const.p_a * ones(N)));
  A = F_ap ./ rho;
  V_dot = m_dot ./ rho;
  //// piece wise linear reconstruction of vector U
  U_ = KP.U_;
  U_[6, 1] = m_dot_R;
  U_[4, N] = m_dot_V;
  //// presure states
  p_ = transpose(matrix(U_[1:2:8, :]));
  //// mass flow rate states
  m_dot_ = transpose(matrix(U_[2:2:8, :]));
  //// define variables, which are going to be used for F matrix and eigenvalues
  _A_atm = [A_atm_[2:N + 1], A_atm_[2:N + 1], A_atm_[1:N], A_atm_[1:N]];
  rho_ = Const.rho * (ones(N, 4) + Const.beta * (p_ - Const.p_a * ones(N, 4)));
  if PipeElasticity == true then
    F_ap_ = Const.rho * _A_atm .* (ones(N, 4) + Const.beta_total * (p_ - Const.p_a * ones(N, 4)));
  else
    F_ap_ = Const.rho * _A_atm .* (ones(N, 4) + Const.beta * (p_ - Const.p_a * ones(N, 4)));
  end if;
  A_ = F_ap_ ./ rho_;
  v_ = m_dot_ ./ F_ap_;
  //// eigenvalues
  if PipeElasticity == true then
    lam1 = (v_ + sqrt(v_ .* v_ + 4 * A_ / Const.rho ./ _A_atm / Const.beta_total)) / 2;
    lam2 = (v_ - sqrt(v_ .* v_ + 4 * A_ / Const.rho ./ _A_atm / Const.beta_total)) / 2;
  else
    lam1 = (v_ + sqrt(v_ .* v_ + 4 * A_ / Const.rho ./ _A_atm / Const.beta)) / 2;
    lam2 = (v_ - sqrt(v_ .* v_ + 4 * A_ / Const.rho ./ _A_atm / Const.beta)) / 2;
  end if;
  //// F vector
  if PipeElasticity == true then
    F_ = [m_dot_ ./ Const.rho ./ _A_atm ./ Const.beta_total; m_dot_ .* v_ + A_ .* p_];
  else
    F_ = [m_dot_ ./ Const.rho ./ _A_atm ./ Const.beta; m_dot_ .* v_ + A_ .* p_];
  end if;
  //// define friction force in each segment using Darcy friction factor
  for i in 1:N loop
    F_f[i] = Functions.DarcyFriction.Friction(v[i], 2 * sqrt(A[i] / pi), dx, rho[i], Const.mu, eps);
  end for;
  //// source term of friction and gravity forces
  S_[1:N] = zeros(N);
  S_[N + 1:2 * N] = F_ap * Const.g * H / L - F_f / dx;
  //// diff. equation
  der(U) = KP.diff_eq;
  annotation (
    Documentation(info = "<html><head></head><body><p>This is a more detailed model fof the pipe that mostly can be used for proper modelling of the penstock or other conduits.</p><p>The model could include the elastic walls and compressible water and use discretization method based on Kurganov-Petrova central upwind scheme (KP). The geometry of the penstock is described due to figure:</p>
<p><img src=\"modelica://OpenHPL/Resources/Images/penstock.png\"></p>
<p>Conservation laws are usually solved by Finite-volume methods. With the Finite volume method, we divide the grid into small control volumes or control cells and then apply the conservation laws. Here the pipe is divided in <i>N</i> segments, with input and output pressure as a boundary conditions. The given cell is denoted by <i>j</i> i.e. it is the <i>j</i> th cell. Cell average is calculated at the center of the cell and <i>U</i> denotes the average values of the conserved variables. The left and the right interfaces of the cell are denoted by <i>j-1/2</i> and <i>j+1/2</i> respectively. At each cell interface, the right(+)/left(-) point values are reconstructed. <i>a </i>denotes the right and the left sided local speeds of propagation at the left/right interface of the cell.</p>
<p><img src=\"modelica://OpenHPL/Resources/Images/kp.png\"></p>
<p>In order to determine the fluxes at the cell interface <i>H </i>and the source term <i>S</i> the KP scheme is used, which is a second order scheme which is well balanced.</p>
<p><img src=\"modelica://OpenHPL/Resources/Images/eq.png\"></p><p><span style=\"font-size: 12px;\">More info about the KP pipe model:&nbsp;</span><a href=\"http://www.ep.liu.se/ecp/article.asp?issue=138&amp;article=002&amp;volume=\" style=\"font-size: 12px;\">http://www.ep.liu.se/ecp/article.asp?issue=138&amp;article=002&amp;volume=</a><span style=\"font-size: 12px;\">&nbsp;</span></p>
</body></html>"));
end PenstockKP;
