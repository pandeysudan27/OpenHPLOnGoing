within OpenHPL.Functions.Fitting.DifferentFitting;
function TaperedExpansion
  input Modelica.SIunits.ReynoldsNumber N_Re "Reynold number";
  input Modelica.SIunits.Height eps "Pipe roughness height";
  input Modelica.SIunits.Diameter D_1, D_2;
  //Pipe diameters
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg theta;
  output Real phi;
protected
  Real f_D "friction factor";
algorithm
  if theta < 22.5 then
    phi := 2.6 * Modelica.Math.sin(Modelica.SIunits.Conversions.from_deg(theta) / 4) * SquareExpansion(N_Re, eps, D_1, D_2);
  else
    phi := SquareExpansion(N_Re, eps, D_1, D_2);
  end if;
  annotation (
    Documentation(info = "<html>
<p>Define dimension factor &phi; for Tapered Expansion. The taper angle &theta; should be specified.</p>
<p><img src=\"modelica://OpenHPL/Resources/Images/taperedredexp.png\"/></p>
</html>"));
end TaperedExpansion;
