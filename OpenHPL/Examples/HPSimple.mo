within OpenHPL.Examples;
model HPSimple "Model of waterway of the HP system with simplified models for conduits, turbine, etc."
  extends Modelica.Icons.Example;
  OpenHPL.Waterway.Reservoir reservoir(H_r=48) annotation (Placement(visible=true, transformation(
        origin={-90,30},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Sources.Ramp control(duration = 1, height = 0.04615, offset = 0.7493, startTime = 600) annotation (
    Placement(visible = true, transformation(origin={-10,70},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenHPL.Waterway.Pipe intake(H=23) annotation (Placement(visible=true, transformation(extent={{-70,20},{-50,40}}, rotation=0)));
  OpenHPL.Waterway.Pipe discharge(H=0.5, L=600, V_dot(fixed = true)) annotation (Placement(visible=true, transformation(extent={{50,-10},{70,10}}, rotation=0)));
  OpenHPL.Waterway.Reservoir tail(H_r=5, Input_level=false) annotation (Placement(visible=true, transformation(
        origin={90,0},
        extent={{-10,10},{10,-10}},
        rotation=180)));
  OpenHPL.ElectroMech.Turbines.Turbine turbine(C_v=3.7, ConstEfficiency=false) annotation (Placement(visible=true, transformation(
        origin={0, 32},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  inner OpenHPL.Constants Const annotation (
    Placement(visible = true, transformation(origin={-90,90},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenHPL.Waterway.SurgeTank surgeTank annotation(
    Placement(visible = true, transformation(origin = {-36, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Waterway.BifurcatedPipe bifurcatedPipe1 annotation(
    Placement(visible = true, transformation(origin = {-16, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(bifurcatedPipe1.p_2, turbine.p) annotation(
    Line(points = {{-6, 0}, {-10, 0}, {-10, 32}, {-10, 32}}, color = {28, 108, 200}));
  connect(surgeTank.n, bifurcatedPipe1.p_1) annotation(
    Line(points = {{-26, 32}, {-26, 32}, {-26, -6}, {-26, -6}}, color = {28, 108, 200}));
  connect(turbine.n, discharge.p) annotation(
    Line(points = {{10, 32}, {57, 32}, {57, 0}, {50, 0}}, color = {28, 108, 200}));
  connect(control.y, turbine.u_t) annotation(
    Line(points = {{1, 70}, {0, 70}, {0, 44}}, color = {0, 0, 127}));
  connect(surgeTank.n, bifurcatedPipe1.p) annotation(
    Line(points = {{-26, 32}, {-26, 12}, {-22, 12}, {-22, -14}}, color = {28, 108, 200}));
  connect(surgeTank.p, intake.n) annotation(
    Line(points = {{-46, 32}, {-46, 30}, {-50, 30}}, color = {28, 108, 200}));
  connect(bifurcatedPipe1.n1, turbine.p) annotation(
    Line(points = {{-2, -8}, {0, -8}, {0, 32}}, color = {28, 108, 200}));
  connect(reservoir.n, intake.p) annotation(
    Line(points = {{-80, 30}, {-70, 30}}, color = {28, 108, 200}));
  connect(discharge.n, tail.n) annotation(
    Line(points = {{70, 0}, {80, 0}}, color = {28, 108, 200}));
  annotation (
    experiment(StopTime = 2000, StartTime = 0, Tolerance = 0.0001, Interval = 0.4));
end HPSimple;
