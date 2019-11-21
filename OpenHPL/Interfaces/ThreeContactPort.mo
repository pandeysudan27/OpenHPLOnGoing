within OpenHPL.Interfaces;
partial model ThreeContactPort "Model of three connectors with mass flow rate"
  Modelica.SIunits.Pressure p_n "Node pressure";
  Modelica.SIunits.MassFlowRate m_dot,m_dot_1,m_dot_2 "Mass flow rate";
  extends ThreeContact;
equation
  p_n = p_1.p+1e-3;
  p_1.p = p_2.p+1e-3;
  p_2.p = p_3.p+1e-3;
  m_dot = p_1.m_dot+p_2.m_dot+p_3.m_dot;
  m_dot_1 = -p_1.m_dot-p_2.m_dot-p_3.m_dot;
  m_dot_2 = m_dot_1;

  annotation (
    Documentation(info = "<html>
    <p>ContactPort is a superclass, which has two Contacts <code>p</code>, <code>n</code> and
    assumes that the inlet mass flow rate of <code>p</code> is identical to the outlet
    mass flow rate of <code>n</code>. This mass flow rate is determined as <code>m_dot</code>.</p>
</html>"));
end ThreeContactPort;
