within OpenHPL.Examples;
model HPSimple_Francis "Model of the HP system with Francis turbine and simplified models for conduits (connected to the grid generator is also uesd)"
  extends Modelica.Icons.Example;
  Waterway.Reservoir reservoir(H_r=48) annotation (Placement(visible=true, transformation(
        origin={-92,62},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Sources.Ramp control(duration = 1980, height = 0.87, offset = 0.09, startTime = 10) annotation (
    Placement(visible = true, transformation(origin = {10, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenHPL.Waterway.Pipe intake(H=23) annotation (Placement(visible=true, transformation(extent={{-76,52},{-56,72}}, rotation=0)));
  Waterway.Pipe discharge(L=600, H=0.5) annotation (Placement(visible=true, transformation(extent={{54,30},{74,50}}, rotation=0)));
  OpenHPL.Waterway.Reservoir tail(H_r=5) annotation (Placement(visible=true, transformation(
        origin={94,44},
        extent={{-10,10},{10,-10}},
        rotation=180)));
  ElectroMech.Generators.SynchGen generator(P_op=100e6, UseFrequencyOutput=false) annotation (Placement(visible=true, transformation(extent={{42,-16},{18,8}}, rotation=0)));
  Waterway.Pipe penstock(
    L=600,
    H=428.5,
    D_i=3,
    D_o=3) annotation (Placement(visible=true, transformation(
        origin={-10,48},
        extent={{-10,-10},{10,10}},
        rotation=-90)));
  OpenHPL.Waterway.SurgeTank surgeTank(h_0=71) annotation (Placement(visible=true, transformation(
        origin={-36,66},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  OpenHPL.ElectroMech.Turbines.Francis turbine(
    D_i=1.632,
    GivenData=true,
    GivenServoData=true,
    H_n=460,
    P_n=103e6,
    R_1_=2.63/2,
    R_2_=1.55/2,
    R_Y_=3,
    R_v_=2.89/2,
    Reduction=0.1,
    V_dot_n=24.3,
    beta1_=110,
    beta2_=162.5,
    dp_v_condition=false,
    k_ft1_=7e5,
    k_ft2_=0e3,
    k_ft3_=1.63e4,
    k_fv=0e3,
    n_n=500,
    r_Y_=1.2,
    r_v_=1.1,
    u_end_=2.4,
    u_start_=2.28,
    w_1_=0.2,
    w_v_=0.2) annotation (Placement(visible=true, transformation(
        origin={30,32},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  inner OpenHPL.Constants Const(V_0 = 4.54) annotation (
    Placement(visible = true, transformation(origin = {-90, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Waterway.Fitting fitting(D_1=3, D_2=1.63) annotation (Placement(transformation(extent={{-4,20},{16,40}})));
equation
  connect(generator.w_out, turbine.w_in) annotation (
    Line(points={{16.8,3.2},{12,3.2},{12,24},{18,24}},      color = {0, 0, 127}));
  connect(turbine.P_out, generator.P_in) annotation (
    Line(points={{30,21},{30,10.4}},                        color = {0, 0, 127}));
  connect(reservoir.n, intake.p) annotation (
    Line(points={{-82,62},{-78,62},{-78,62},{-76,62}},                      color = {28, 108, 200}));
  connect(surgeTank.p, intake.n) annotation (
    Line(points={{-46,66},{-48,66},{-48,62},{-56,62}},                      color = {28, 108, 200}));
  connect(surgeTank.n, penstock.p) annotation (
    Line(points={{-26,66},{-16.95,66},{-16.95,58},{-10,58}},                      color = {28, 108, 200}));
  connect(turbine.n, discharge.p) annotation (
    Line(points={{40,32},{48,32},{48,40},{54,40}},                      color = {28, 108, 200}));
  connect(control.y, turbine.u_t) annotation (
    Line(points={{21,84},{30,84},{30,44}},          color = {0, 0, 127}));
  connect(turbine.p, fitting.n) annotation (
    Line(points={{20,32},{20,30},{16,30}},                    color = {28, 108, 200}));
  connect(tail.n, discharge.n) annotation (
    Line(points={{84,44},{84,41.95},{80,41.95},{80,40},{74,40}},                        color = {28, 108, 200}));
  connect(penstock.n, fitting.p) annotation (
    Line(points={{-10,38},{-6,38},{-6,30},{-4,30}},                      color = {28, 108, 200}));
  annotation (
    experiment(StopTime = 2000, StartTime = 0, Tolerance = 0.0001, Interval = 0.4));
end HPSimple_Francis;
