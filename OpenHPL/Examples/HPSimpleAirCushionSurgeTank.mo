within OpenHPL.Examples;
model HPSimpleAirCushionSurgeTank "Model of waterway of the HP system with simplified models for conduits, turbine, etc."
  extends Modelica.Icons.Example;
  OpenHPL.Waterway.Reservoir reservoir(H_r = 6, Input_level = false, UseInFlow = false) annotation (
    Placement(visible = true, transformation(origin = {-174, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenHPL.ElectroMech.Turbines.Turbine turbine(C_v = 3.7, ConstEfficiency = true, H_n = 445, V_dot_n = 17.5, ValveCapacity = false) annotation (
    Placement(visible = true, transformation(origin={2,12},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner OpenHPL.Constants Const annotation (
    Placement(visible = true, transformation(origin = {-174, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenHPL.Waterway.AirCushionSurgeTank airCushionSurgeTank(D = 50.47, H = 10.5, L = 12.12, h_0 = 2, p_air(displayUnit = "Pa") = 4.1e+06) annotation (
    Placement(visible = true, transformation(origin = {-102, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenHPL.Waterway.Pipe pipe(D_i = 6.56, D_o = 6.56, H = 345, L = 8862.21, V_dot(fixed = true)) annotation (
    Placement(visible = true, transformation(origin = {-140, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp control(duration = 50, height = 0.346, offset = 0.48, startTime = 50) annotation (
    Placement(visible = true, transformation(origin = {-52, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(pipe.n, airCushionSurgeTank.p) annotation (
    Line(points = {{-130, 2}, {-112, 2}}, color = {28, 108, 200}));
  connect(control.y, turbine.u_t) annotation (
    Line(points={{-41,58},{2,58},{2,24}},        color = {0, 0, 127}));
  connect(reservoir.n, pipe.p) annotation (
    Line(points = {{-164, 16}, {-156, 16}, {-156, 2}, {-150, 2}}, color = {28, 108, 200}));
  connect(airCushionSurgeTank.n, turbine.p) annotation (Line(points={{-92,2},{
          -50,2},{-50,12},{-8,12}}, color={28,108,200}));
  annotation (
    experiment(StopTime = 2000, StartTime = 0, Tolerance = 0.0001, Interval = 0.4),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    Icon(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    __OpenModelica_commandLineOptions = "");
end HPSimpleAirCushionSurgeTank;
