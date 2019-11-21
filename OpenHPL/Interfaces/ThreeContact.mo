within OpenHPL.Interfaces;
partial model ThreeContact "Model of three connectors"
 Contact p_1 "Inlet contact" annotation (
    Placement(transformation(extent={{-110,-10},{-90,10}})));
 Contact p_2 "Outlet contact 1" annotation (
    Placement(transformation(extent={{90,50},{110,70}})));
 Contact p_3 "Outlet contact 2" annotation (
    Placement(transformation(extent={{90,-70},{110,-50}})));
end ThreeContact;
