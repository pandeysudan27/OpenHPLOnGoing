within OpenHPL.Waterway;
model Reservoir "Model of the reservoir"
  outer Constants Const "using standart class with constants";
  extends OpenHPL.Icons.Reservoir;
  //// constant water level in the reservoir
  parameter Modelica.SIunits.Height H_r = 50 "Initial water level above intake" annotation (
    Dialog(group = "Initialization"));
  //// geometrical parameters in case when the inflow to reservoir is used
  parameter Modelica.SIunits.Length L = 500 "Length of the reservoir" annotation (
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Length w = 100 "Bed width of the reservoir" annotation (
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg alpha = 30 "The angle of the reservoir walls (zero angle corresponds to vertical walls)" annotation (
    Dialog(group = "Geometry"));
  parameter Real f = 0.0008 "Friction factor of the reservoir" annotation (
    Dialog(group = "Geometry"));
  //// conditions of use
  parameter Boolean UseInFlow = false "If checked - the inlet/outlet flow is used" annotation (
    Dialog(group = "Structure"),
    choices(checkBox = true));
  parameter Boolean Input_level = false "If checked - the input Level_in should be connected. Otherwise the constant level H_r is used" annotation (
    Dialog(group = "Structure"),
    choices(checkBox = true));
  //// possible parameters for temperature variation. Not finished...
  //parameter Boolean TempUse = Const.TempUse "If checked - the water temperature is not constant" annotation (Dialog(group = "Initialization"));
  //parameter Modelica.SIunits.Temperature T_i = Const.T_i "Initial temperature of the water" annotation (Dialog(group = "Initialization", enable = TempUse));
  //// variables
  Modelica.SIunits.Area A "vertiacal cros section";
  Modelica.SIunits.Mass m "water mass";
  Modelica.SIunits.MassFlowRate m_dot "water mass flow rate";
  Modelica.SIunits.VolumeFlowRate V_o_dot "outlet flow rate", V_i_dot "inlet flow rate", V_dot "vertical flow rate";
  Modelica.SIunits.Velocity v "water velosity";
  Modelica.SIunits.Momentum M "water momentum";
  Modelica.SIunits.Force F_f "friction force";
  Modelica.SIunits.Height H "water height";
  Modelica.SIunits.Pressure p_2 "outside pressure";
  //// conectors
  OpenHPL.Interfaces.Contact n(p=p_2) "Outflow from reservoir" annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput V_in = V_i_dot if UseInFlow "Conditional input inflow of the reservoir"
    annotation (Placement(transformation(origin={-120,0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Level_in = H if Input_level "Conditional input water level of the reservoir"
    annotation (Placement(transformation(origin={-120,50}, extent = {{-20, -20}, {20, 20}}, rotation=0)));
initial equation
  if Input_level == false then
    H = H_r;
  end if;
equation
  //// Define vertiacal cross section of the reservoir
  A = H * (w + 2 * H * Modelica.Math.tan(Modelica.SIunits.Conversions.from_deg(alpha)));
  //// Define water mass
  m = Const.rho * A * L;
  //// Define volumetric water flow rate
  V_dot = V_i_dot - V_o_dot;
  //// Define mass water flow rate
  m_dot = Const.rho * V_dot;
  //// Define water velocity
  v = m_dot / Const.rho / A;
  //// Define momentrumn
  M = L * m_dot;
  //// Define friction term
  F_f = 1 / 8 * Const.rho * f * L * (w + 2 * H / Modelica.Math.cos(alpha)) * v * abs(v);
  //// condition for inflow use
  if UseInFlow == false then
    //// condition for constant water level, inflow = outflow
    V_i_dot - V_o_dot = 0;
  end if;
  //// condition for input water level use
  if Input_level == false then
    //// define derivatives of momentum and mass
    der(M) = A * (Const.p_a - p_2) + Const.g * Const.rho * A * H - F_f + Const.rho / A * (V_i_dot ^ 2 - V_o_dot ^ 2);
    der(m) = m_dot;
  else
    //// define output pressure
    p_2 = Const.p_a + Const.g * Const.rho * H;
  end if;
  //// output flow conector
  n.m_dot = -Const.rho * V_o_dot;
  //// output temperature conector
  //n.T = T_i;
  annotation (
    Icon(coordinateSystem(initialScale = 0.1)),
    Documentation(info = "<html><head></head><body><p>Simple model of the reservoir, which depending on depth of the outlet from reservoir, calculate the outlet pressure.</p>
<p><img src=\"modelica://OpenHPL/Resources/Images/reservoir.png\"></p>
<p><br>Can also make a more complicated model and add the inflow to the reservoir and specify the reservoir geometry.</p>
<p>Also, it is possible to connect an input signal with varying water level in the reservoir.</p>
</body></html>"),
    experiment(StartTime = 0, StopTime = 3600, Tolerance = 0.0001, Interval = 1));
end Reservoir;
