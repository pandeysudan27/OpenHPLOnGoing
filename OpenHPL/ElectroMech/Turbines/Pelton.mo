within OpenHPL.ElectroMech.Turbines;
model Pelton "Model of the Pelton turbine"
    outer Constants Const "using standart class with constants";
    extends Icons.Turbine;
    import Modelica.Constants.pi;
    //// geometrical parameters of the turbine
    parameter Modelica.SIunits.Radius R = 3.3 "Radius of the turbine";
    parameter Modelica.SIunits.Diameter D_0 = 3.3 "input diameter of the nuzzle";
    parameter Real k = 0.8 "friction factor", k_f = 1 "coefficient of friction loss in the nuzzle", K = 0.25 "friction loss coefficient due to power loss", d_u = 1 "deflector machanism coefficient";
    parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg beta = 165;
    //// condition for inlet water compressibility
    parameter Boolean CompElas = false "If checked the water is compressible and the walls is elastic" annotation (
        choices(checkBox = true));
    //// variables
    Modelica.SIunits.Pressure p_tr1 "inlet pressure", dp_tr "turbine pressure drop", p_tr2 "outlet pressure", dp_n "nuzzel pressure drop";
    Modelica.SIunits.Area A_1, A_0 = pi * D_0 ^ 2 / 4;
    Modelica.SIunits.EnergyFlowRate W_s_dot "shaft power";
    Modelica.SIunits.VolumeFlowRate V_dot "flow rate";
    Modelica.SIunits.Velocity v_R, v_1;
    Modelica.SIunits.AngularVelocity w "angular velocity";
    Real cos_b = Modelica.Math.cos(Modelica.SIunits.Conversions.from_deg(beta));
    //// conectors
    extends OpenHPL.Interfaces.TurbineContacts;
    Modelica.Blocks.Interfaces.RealInput w_in = w "Input angular velocity from the generator" annotation (
                                Placement(visible = true, transformation(origin={-120,-80},    extent={{-20,-20},
            {20,20}},                                                                                                           rotation = 0)));
equation
  //// Condition for inlet water compressibility
    if CompElas == false then
        V_dot = m_dot / Const.rho;
    else
        V_dot = m_dot / (Const.rho * (1 + Const.beta * (p.p - Const.p_a)));
    end if;
  //// nuzzel pressure drop
    dp_n = 0.5 * m_dot * (V_dot * (1 / A_1 ^ 2 - 1 / A_0 ^ 2) + k_f);
  //// Euler equation for shaft power
    W_s_dot = m_dot * v_R * (d_u * v_1 - (1 + K) * v_R) * (1 - k * cos_b);
    v_R = w * R;
    v_1 = V_dot / A_1;
    A_1 = u_t;
  //// turbine pressure drop
    dp_tr * V_dot = W_s_dot;
    dp_tr = p_tr1 - p_tr2;
  //// connectors pressures
    p_tr1 = p.p;
  // + dp_n;
    p_tr2 = n.p;
  //// output mechanical power
    P_out = W_s_dot;
    annotation (
        Documentation(info="<html>
<p>This is a model of the Pelton turbine.
This model is based on the Euler turbine equation.
</p>
<p>
The model has not been tested.</p>
<h5>References</h5>
<p>More info about the model can be found in: <a href=\"modelica://OpenHPL/Resources/Report/Turbines_model.pdf\">Resources/Report/Turbines_model.pdf</a>
</p>
</html>"),
        Icon(                                                                                                                                   coordinateSystem(initialScale = 0.1)));
end Pelton;
