within OpenHPL.Waterway;
model BifurcatedPipe "Model of the Bifurcated pipe for two units of turbine"
  inner Constants Const "Using standard class with constants";
  extends OpenHPL.Icons.Pipe;
  // Constants
  parameter Real g = 9.8 "Acceleration due to gravity, m/s^2";
  parameter Real pi = 3.14 "Value of pi, -";
  //parameter Real eps = 5e-2 "pipe roughness height, mm";
  parameter Real mu = 0.89e-3 "dynamic viscosity of water";
  parameter Real rho = 997 "Density of water in the draft tube, Kg/m^3";

// geometrical parameters of surge tank
  parameter Real L1 = 10 "Length of inlet part, m" annotation (
    Dialog(group = "Geometry"));
  parameter Real L2 = 5 "Length of Bifurcated part I, m" annotation (
    Dialog(group = "Geometry"));
  parameter Real L3 = 5 "Length of Bifurcated part II" annotation (
    Dialog(group = "Geometry"));
  parameter Real D1 = 5 "Diameter of inlet part" annotation (
    Dialog(group = "Geometry"));
  parameter Real D2 = 3 "Diameter of Bifurcated part I" annotation (
    Dialog(group = "Geometry"));
  parameter Real D3 = 4 "Diameter of Bifurcated part II" annotation (
    Dialog(group = "Geometry"));
  parameter Modelica.SIunits.Height eps = Const.eps "Pipe roughness height" annotation (
    Dialog(group = "Geometry"));
  parameter Real A1 = pi*D1^2/4 "Area of inlet part";
  parameter Real A2 = pi*D2^2/4 "Area of Bifurcated part I";
  parameter Real A3 = pi*D3^2/4 "Area of Bifurcated part II";
  //
  parameter Real V_dot0 = 0 "Inital volumetric water flow in the draft tube, m^3/s";
    // variables
  //Real m "Total mass of water inside Bifurcated pipe, Kg";
  Real m1 "Mass of water in inlet pipe, Kg";
  Real m2 "Mass of water in Bifurcated part I, Kg";
  Real m3 "Mass of water in Bifurcated part II, Kg";

  Real m1_dot "Mass of water in inlet pipe, Kg";
  Real m2_dot "Mass of water in Bifurcated part I, Kg";
  Real m3_dot "Mass of water in Bifurcated part II, Kg";

  Real v1 "Velocity of water in inlet pipe, Kg";
  Real v2 "Velocity of water in Bifurcated part I, Kg";
  Real v3 "Velocity of water in Bifurcated part II, Kg";

  Real M "Momentum of Bifurcated pipe, Kg.m/s";
  Real M_dot "Momentum rate of change of Bifurcated pipe, Kg.m/s^2";

  Real p1 "Pressure in inlet part, Pa";
  Real p2 "Pressure in Bifurcated part I, pa";
  Real p3 "Pressure in Bifurcated part II, pa";

  Real F "Force in the surge tank, N";
  Real F_p "Force due to pressure in the pipe, N";
  //Real F_g "Force due to gravity, N";
  Real F_f "Force due to fluid friction in the pipe, N";
  Real F_f1 "Force due to fluid friction in inlet part, N";
  Real F_f2 "Force due to fluid friction in Bifurcated part I, N";
  Real F_f3 "Force due to fluid friction in Bifurcated part II, N";
  //Real m(start = m, fixed = true) "Height of water level in the surge shaft, m";
  Real V_dot1(start = V_dot0)
                             "Volumetric flow rate of water inside surge tank, m^3/s";
  Real V_dot2(start = V_dot0)
                             "Volumetric flow rate of water inside surge tank, m^3/s";
  Real V_dot3(start = V_dot0)
                             "Volumetric flow rate of water inside surge tank, m^3/s";
  extends OpenHPL.Interfaces.ThreeContactPort;
equation
  //der(m) = 0; // m_dot_i=m_dot_e
  m1=rho*A1*L1;m2=rho*A2*L2;m3=rho*A3*L3;
  der(M) = M_dot + F;
  M = m1*v1+m2*v2+m3*v3;
  v1=V_dot1/A1;v2=V_dot2/A2;v3=V_dot3/A3;
  M_dot = m1_dot*v1-m2_dot*v2-m3_dot*v3;

  V_dot1=V_dot2+V_dot3;
  m1_dot=m2_dot+m3_dot;
  m1_dot=rho*V_dot1;m2_dot=rho*V_dot2;m3_dot=rho*V_dot3;

  F = F_p - F_f;
  F_p = p1*A1-p2*A2-p3*A3;
  //p1 = p_1.p;
  //p2 = p_2.p;
  //p3 = p_3.p;
  p_n = p1;

  m_dot=m1_dot;
  m_dot_1=m2_dot;
  m_dot_2=m3_dot;

  F_f = F_f1+F_f2+F_f3;

  F_f1 = 0.5*pi*1/(-2*log10(eps/3.7/D1 + 5.74/(rho*abs(v1)*D1/mu+1e-3)^0.9))^2*rho*L1*v1*abs(v1)*D1/4;
  F_f2 = 0.5*pi*1/(-2*log10(eps/3.7/D2 + 5.74/(rho*abs(v2)*D2/mu+1e-3)^0.9))^2*rho*L2*v2*abs(v2)*D2/4;
  F_f3 = 0.5*pi*1/(-2*log10(eps/3.7/D3 + 5.74/(rho*abs(v3)*D3/mu+1e-3)^0.9))^2*rho*L3*v3*abs(v3)*D3/4;

end BifurcatedPipe;
