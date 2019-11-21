within OpenHPL.Examples;

model check
  OpenHPL.Waterway.BifurcatedPipe bifurcatedPipe1 annotation(
    Placement(visible = true, transformation(origin = {-24, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Waterway.Reservoir reservoir1 annotation(
    Placement(visible = true, transformation(origin = {-58, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenHPL.Waterway.Reservoir reservoir2 annotation(
    Placement(visible = true, transformation(origin = {58, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(bifurcatedPipe1.p_3, reservoir2.n) annotation(
    Line(points = {{-14, 32}, {48, 32}, {48, 48}, {48, 48}}, color = {28, 108, 200}));
  connect(bifurcatedPipe1.p_2, reservoir2.n) annotation(
    Line(points = {{-14, 44}, {48, 44}, {48, 48}, {48, 48}}, color = {28, 108, 200}));
  connect(reservoir1.n, bifurcatedPipe1.p_1) annotation(
    Line(points = {{-48, 52}, {-34, 52}, {-34, 38}}, color = {28, 108, 200}));
end check;
