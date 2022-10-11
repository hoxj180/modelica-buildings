within Buildings.Experimental.DHC.Loads.Heating.DHW.BaseClasses;
model HeatPumpWaterHeaterWithTank
  "A model for domestic water heating served by heat pump water heater and local storage tank"
  extends
    Buildings.Experimental.DHC.Loads.Heating.DHW.BaseClasses.PartialFourPortDHW;

  parameter Modelica.Units.SI.Volume VTan = 0.151416 "Tank volume";
  parameter Modelica.Units.SI.Length hTan = 1.746 "Height of tank (without insulation)";
  parameter Modelica.Units.SI.Length dIns = 0.0762 "Thickness of insulation";
  parameter Modelica.Units.SI.ThermalConductivity kIns=0.04 "Specific heat conductivity of insulation";
  parameter Modelica.Units.SI.PressureDifference dpHex_nominal=2500 "Pressure drop across the heat exchanger at nominal conditions";
  parameter Modelica.Units.SI.MassFlowRate mHex_flow_nominal=0.278 "Mass flow rate of heat exchanger";
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal(min=0) = 1230.9 "Nominal heating flow rate";

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemTankOut(redeclare package
              Medium =
               Medium, m_flow_nominal=mHw_flow_nominal)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=mHw_flow_nominal,
    m2_flow_nominal=mDH_flow_nominal,
    QCon_flow_nominal=QCon_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
              "Domestic hot water heater"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Storage.StratifiedEnhancedInternalHex tan(
    redeclare package Medium = Medium,
    m_flow_nominal=mHw_flow_nominal,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    kIns=kIns,
    nSeg=5,
    redeclare package MediumHex = Medium,
    CHex=40,
    Q_flow_nominal=0.278*4200*20,
    hHex_a=0.995,
    hHex_b=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    allowFlowReversalHex=false,
    mHex_flow_nominal=mHex_flow_nominal,
    TTan_nominal=293.15,
    THex_nominal=323.15,
    dpHex_nominal=dpHex_nominal)
                                "Hot water tank with heat exchanger configured as steady state"
    annotation (Placement(transformation(extent={{-40,50},{-60,70}})));
  Fluid.Sensors.TemperatureTwoPort senTemHPOut(redeclare package Medium =
        Medium, m_flow_nominal=mHw_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,6})));
equation
  connect(tan.port_a, senTemTankOut.port_a)
    annotation (Line(points={{-40,60},{-10,60}},
                                             color={0,127,255}));
  connect(tan.portHex_b, heaPum.port_a1) annotation (Line(points={{-40,52},
          {-40,6},{-10,6}},                           color={0,127,255}));
  connect(tan.portHex_a, senTemHPOut.port_b) annotation (Line(points={{-40,
          56.2},{20,56.2},{20,56},{80,56},{80,6},{60,6}},
                                color={0,127,255}));
  connect(heaPum.port_b1, senTemHPOut.port_a)
    annotation (Line(points={{10,6},{40,6}},              color={0,127,255}));
  connect(TSetHw, heaPum.TSet) annotation (Line(points={{-110,0},{-60,0},
          {-60,14},{-12,14},{-12,9}}, color={0,0,127}));
  connect(tan.port_b, port_a1)
    annotation (Line(points={{-60,60},{-100,60}}, color={0,127,255}));
  connect(senTemTankOut.port_b, port_b1)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(port_a2, heaPum.port_a2) annotation (Line(points={{100,-60},{20,
          -60},{20,-6},{10,-6}}, color={0,127,255}));
  connect(port_b2, heaPum.port_b2) annotation (Line(points={{-100,-60},{
          -20,-60},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(heaPum.P, PEle) annotation (Line(points={{11,0},{30,0},{30,-20},
          {80,-20},{80,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpWaterHeaterWithTank;
