within OpenHPL.Waterway;
model OpenChannel "Open channel model (use KP scheme)"
  outer Constants Const "using standart class with constants";
  extends OpenHPL.Icons.OpenChannel;
  //// geometrical parameters of the open channel
  parameter Integer N = 100 "Number of discretization units" annotation (Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Length w = 180 "Channel width" annotation (Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Length L = 5000 "Channel length" annotation (Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Height H[2] = {17.5, 0} "Channel bed geometry, height from the left and right sides" annotation (Dialog(group = "Geometry"));
  parameter Real f_n = 0.04 "Manning's roughness coefficient [s/m^1/3]" annotation (Dialog(group = "Geometry"));
  parameter Boolean SteadyState = Const.Steady "if true - starts from Steady State" annotation (Dialog(group = "Initialization"));
  parameter Modelica.SIunits.Height h0[N] = ones(N)*5 "Initial depth" annotation (Dialog(group = "Initialization"));
  parameter Modelica.SIunits.VolumeFlowRate V_dot0 = Const.V_0 "Initial flow rate" annotation (Dialog(group = "Initialization"));
  parameter Boolean BoundaryCondition[2,2] = [false, true; false, true] "Boundary conditions. Choose options for the boundaries in a matrix table, i.e., if the matrix element = true, this element is used as boundary. The element represent the following quantities: [inlet depth, inlet flow; outlet depth, outlet flow]" annotation (Dialog(group = "Boundary condition"));
  //// variables
  Modelica.SIunits.VolumeFlowRate V_out "outlet flow", V_in "inlet flow";
  Modelica.SIunits.Height h[N] "Water depth in each unit of the chanel";
  //// conector
  extends OpenHPL.Interfaces.TwoContact;
  //// using open channel example from KP method class
  Internal.KPOpenChannel openChannel(
    N=N,
    w=w,
    L=L,
    V_dot0=V_dot0,
    f_n=f_n,
    h0=h0,
    boundaryValues=[h0[1] + H[1],V_in/w; h0[N] + H[2],V_out/w],
    boundaryCondition=BoundaryCondition,
    SteadyState=SteadyState) annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
equation
//// define a vector of the water depth in the channel
  h = openChannel.h;
//// flow rate boundaries
  p.m_dot = V_in * Const.rho;
  n.m_dot = -V_out*Const.rho;
//// presurre boundaries
  p.p = h[1] * Const.g * Const.rho + Const.p_a;
  n.p = h[N]*Const.g*Const.rho + Const.p_a;
  annotation (
    Documentation(info="<html>
<p>
This is a model for the open channel (river).
Could be used for modelling of run-of-river hydropower plants.
</p>
<p>
In this model it is assumed that the channel has the inlet and
outlet from the bottom of the left and right sides, respectevely.
</p>
<p>
That is why this open channel should be connected from both sides to the
<a href=\"modelica://OpenHPL.Waterway.Pipe\">Pipe</a> elements.
Connectors hold information about the inlet/outlet flow rate and the pressures
 that is defined as sum of atmospheric pressure and pressure of the water (depends on depth).
</p>
<p>
As boundary conditions, at least two of the four quentities
(inlet flow or depth and outlet flow or depth) should be used.
</p>
<p>Perhaps, this structure is not really useful and some modification should be done.
This is still under discussion and has not been tested properly.
</p>
<h5>References</h5>
<p>More info about the original model can be found in:&nbsp;<a href=\"http://www.mic-journal.no/ABS/MIC-2015-4-4.asp\">http://www.mic-journal.no/ABS/MIC-2015-4-4.asp</a></p></html>"));
end OpenChannel;
