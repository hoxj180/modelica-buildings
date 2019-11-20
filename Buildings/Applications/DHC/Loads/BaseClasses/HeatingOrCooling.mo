within Buildings.Applications.DHC.Loads.BaseClasses;
model HeatingOrCooling "Model for steady-state, sensible heat transfer between a circulating liquid and thermal loads"
  // Suffix _i is to distinguish vector variable from (total) scalar variable on the source side (1) only.
  // Each variable related to load side (2) quantities is a vector by default.
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=m_flow1_nominal);
  replaceable package Medium2 =
    Buildings.Media.Air
    "Load side medium"
    annotation(choices(
      choice(redeclare package MediumLoa = Buildings.Media.Air "Moist air"),
      choice(redeclare package MediumLoa = Buildings.Media.Water "Water"),
      choice(redeclare package MediumLoa =
        Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  parameter Integer nLoa = 1
    "Number of connected loads";
  parameter Modelica.SIunits.PressureDifference dp_nominal(
    min=0, displayUnit="Pa") = 0
    "Pressure drop at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime flowRegime[nLoa]=
    fill(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange, nLoa)
    "Heat exchanger flow regime";
  parameter Modelica.SIunits.Temperature T1_a_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T1_b_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side return temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal[nLoa](
    each min=0)
    "Sensible thermal power exchanged with the load i at nominal conditions (always positive)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T2_nominal[nLoa](
    each min=Modelica.SIunits.Conversions.from_degC(0), each displayUnit="degC")
    "Load side temperature at nominal conditions (at inlet if it applies)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow2_nominal[nLoa] = fill(0, nLoa)
    "Load side mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Boolean reverseAction = false
    "Set to true for tracking a cooling heat flow rate";
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  // Advanced
  parameter Boolean homotopyInitialization = true
    "If true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Real ratUAIntToUAExt[nLoa](each min=1) = fill(2, nLoa)
    "Ratio of UA internal to UA external values at nominal conditions"
    annotation(Dialog(tab="Advanced", group="Nominal condition"));
  parameter Real expUA[nLoa] = fill(4/5, nLoa)
    "Exponent of Reynolds number in the flow correlation used for computing UA internal value"
    annotation(Dialog(tab="Advanced"));
  // Computed parameters
  final parameter Modelica.SIunits.MassFlowRate m_flow1_nominal = sum(m_flow1_i_nominal)
    "Source side total mass flow rate at nominal conditions";
  final parameter Modelica.SIunits.MassFlowRate m_flow1_i_nominal[nLoa] = abs(
    Q_flow_nominal / cp1_nominal / (T1_a_nominal - T1_b_nominal))
    "Source side mass flow rate at nominal conditions, as distributed to each load i";
  final parameter Modelica.SIunits.ThermalConductance UA_nominal[nLoa]=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps=Q_flow_nominal ./ abs(CMin_nominal .* (T1_a_nominal .- T2_nominal)),
      Z=0,
      flowRegime=Integer(flowRegime)) * cp1_nominal .* m_flow1_i_nominal
    "Thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UAExt_nominal[nLoa]=
    (1 .+ ratUAIntToUAExt) ./ ratUAIntToUAExt .* UA_nominal
    "External thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UAInt_nominal[nLoa]=
    ratUAIntToUAExt .* UAExt_nominal
    "Internal thermal conductance at nominal conditions";
  // IO connectors
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yHeaCoo[nLoa](each final unit="1")
    "Heating or cooling control loop output"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,220}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow1Req(quantity="MassFlowRate")
    "Total mass flow rate to provide the required heat flow rates" annotation (Placement(transformation(extent={{200,50},
            {240,90}}), iconTransformation(extent={{100,-70},{140,-30}})));
  // Building blocks
  Buildings.Applications.DHC.Loads.BaseClasses.HeatFlowEffectiveness heaFloEff[nLoa](
    final m_flow1_nominal=m_flow1_i_nominal,
    final m_flow2_nominal=m_flow2_nominal,
    each final cp1_nominal=cp1_nominal,
    final cp2_nominal=cp2_nominal,
    final flowRegime=flowRegime)
    annotation (Placement(transformation(extent={{94,202},{114,222}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort T1InlMes(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sensors.MassFlowRate m_flow1Mes(redeclare final package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.RealExpression UAAct[nLoa](y=1 ./ (1 ./ (UAInt_nominal .*
        Buildings.Utilities.Math.Functions.regNonZeroPower(m_flow1Act.y ./ m_flow1_i_nominal, expUA)) + 1 ./
        UAExt_nominal))
    annotation (Placement(transformation(extent={{20,234},{40,254}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator T1InlVec(nout=nLoa)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,30})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorLoa[nLoa]
    "Heat port transfering heat to the load"
    annotation (Placement(transformation(extent={{190,150},{210,170}}),
    conTransformation(extent={{-10,90},{10, 110}}),
      iconTransformation(extent={{90,40},{110,60}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum Q_flowSum(
    k=fill(-1, nLoa), nin=nLoa)
    "Sum of the heat flow rates for all loads"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,50})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloSenToLoa[nLoa] "Sensible heat flow rate from source to load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,200})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T2Mes[nLoa]
    "Load side temperature sensor"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={150,140})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow2[nLoa](
    each final quantity="MassFlowRate")
    "Load side mass flow rate"
    annotation(Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80})));

  // FOR DEVELOPMENT ONLY
  Real frac_Q_flow "Positive fractional heat flow rate";
  // FOR DEVELOPMENT ONLY

  Buildings.Controls.OBC.CDL.Interfaces.RealInput fraLat[nLoa](each final unit="1") if cooMod
    "Fraction of latent to total heat flow rate"
    annotation(Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,70}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar[nLoa](each final p=1, each final k=-1) if cooMod
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div[nLoa] if cooMod
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,88})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare final package Medium=Medium,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m_flow1_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final Q_flow_nominal=1)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(k=fill(1, nLoa), nin=nLoa)
    "Total required water mass flow rate" annotation (Placement(transformation(extent={{-40,210},{-20,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain m_flow1Req_i[nLoa](k=m_flow1_i_nominal)
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator m_flow1Vec(nout=nLoa) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-30,30})));
  Modelica.Blocks.Sources.RealExpression m_flow1Act[nLoa](y=m_flow1Req_i.y*m_flow1Mes.m_flow/
        Buildings.Utilities.Math.Functions.smoothMax(
        m_flow1Req,
        m_flow_small,
        m_flow_small)) annotation (Placement(transformation(extent={{20,206},{40,226}})));
protected
  parameter Boolean cooMod = (T1_b_nominal > T1_a_nominal)
    "Cooling mode flag"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.ThermalConductance CMin_nominal[nLoa](each fixed=false)
    "Minimum capacity flow rate at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal = Medium.specificHeatCapacityCp(
    Medium.setState_pTX(Medium.p_default, T1_a_nominal))
    "Source side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal[nLoa] = Medium2.specificHeatCapacityCp(
    Medium2.setState_pTX(Medium2.p_default, T2_nominal))
    "Load side specific heat capacity at nominal conditions";
initial equation
  for i in 1:nLoa loop
    CMin_nominal[i] = if abs(m_flow2_nominal[i]) < Modelica.Constants.eps then
      m_flow1_i_nominal[i] * cp1_nominal else
      min(m_flow1_i_nominal[i] * cp1_nominal, m_flow2_nominal[i] * cp2_nominal[i]);
  end for;
equation
  // FOR DEVELOPMENT ONLY
  frac_Q_flow = abs(heaCoo.Q_flow / sum(Q_flow_nominal));
  // FOR DEVELOPMENT ONLY
  connect(port_a,T1InlMes. port_a) annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(T1InlMes.port_b, m_flow1Mes.port_a) annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(T1InlMes.T, T1InlVec.u) annotation (Line(points={{-70,11},{-70,18}}, color={0,0,127}));
  connect(UAAct.y, heaFloEff.UA) annotation (Line(points={{41,244},{86,244},{86,220},{92,220}},    color={0,0,127}));
  connect(heaPorLoa,T2Mes. port) annotation (Line(points={{200,160},{200,140},{160,140}},color={191,0,0}));
  connect(heaPorLoa, heaFloSenToLoa.port) annotation (Line(points={{200,160},{200,200},{160,200}},
                                                                                        color={191,0,0}));
  connect(T1InlVec.y, heaFloEff.T1Inl)
    annotation (Line(points={{-70,42},{-70,159},{78,159},{78,212},{92,212}}, color={0,0,127}));
  connect(T2Mes.T, heaFloEff.T2Inl) annotation (Line(points={{140,140},{86,140},{86,204},{92,204}},color={0,0,127}));
  connect(m_flow2, heaFloEff.m_flow2)
    annotation (Line(points={{-120,120},{82,120},{82,208},{92,208}},   color={0,0,127}));
  connect(heaFloEff.Q_flow, heaFloSenToLoa.Q_flow)
    annotation (Line(points={{115,212},{116,212},{116,200},{140,200}},
                                                                   color={0,0,127}));
  if cooMod then
    connect(fraLat, addPar.u) annotation (Line(points={{-120,70},{-42,70}}, color={0,0,127}));
    connect(addPar.y, div.u2) annotation (Line(points={{-18,70},{-14,70},{-14,110},{104,110},{104,100}},
                                                                                            color={0,0,127}));
    connect(heaFloEff.Q_flow, div.u1) annotation (Line(points={{115,212},{116,212},{116,100}},     color={0,0,127}));
    connect(div.y, Q_flowSum.u) annotation (Line(points={{110,76},{110,62}},
                                                                           color={0,0,127}));
  else
    connect(heaFloEff.Q_flow, Q_flowSum.u);
  end if;
  connect(m_flow1Mes.port_b, heaCoo.port_a) annotation (Line(points={{-20,0},{40,0}}, color={0,127,255}));
  connect(heaCoo.port_b, port_b) annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(m_flow1Req_i.y, mulSum.u) annotation (Line(points={{-58,220},{-42,220}}, color={0,0,127}));
  connect(yHeaCoo, m_flow1Req_i.u) annotation (Line(points={{-120,220},{-82,220}}, color={0,0,127}));
  connect(mulSum.y, m_flow1Req) annotation (Line(points={{-18,220},{0,220},{0,70},{220,70}}, color={0,0,127}));
  connect(Q_flowSum.y, heaCoo.u) annotation (Line(points={{110,38},{110,20},{20,20},{20,6},{38,6}}, color={0,0,127}));
  connect(m_flow1Mes.m_flow, m_flow1Vec.u) annotation (Line(points={{-30,11},{-30,18}}, color={0,0,127}));
  connect(m_flow1Act.y, heaFloEff.m_flow1) annotation (Line(points={{41,216},{92,216}}, color={0,0,127}));
annotation (
   Documentation(
info="<html>
<p>
This model computes the steady-state, sensible heat transfer between a circulating liquid and idealized
thermal loads at uniform temperature.
</p>
<p>
The heat flow rate transferred to each load is computed using the effectiveness method, see
<a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessDirect\">
Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessDirect</a>.
As the effectiveness depends on the mass flow rate, this requires to assess a representative distribution of
the main liquid stream between the connected loads.
This is achieved by:
<ul>
<li> computing the mass flow rate needed to transfer the required heat flow rate to each load,
see
<a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessControl\">
Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessControl</a>,
</li>
<li> normalizing this mass flow rate to the actual flow rate of the main liquid stream.</li>
</ul>
</p>
<p>
The nominal UA-value (W/K) is calculated for each load <i>i</i> from the cooling or
heating power and the temperature difference between the liquid and the load, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ\">
Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ</a>.
It is split between an internal (liquid side) and an external (load side) UA-value based on the ratio
<i>UA<sub>int, nom, i</sub> / UA<sub>ext, nom, i</sub> </i> provided as a parameter. The influence of
the liquid flow rate on the internal UA-value is derived from a forced convection
correlation, expressing the Nusselt number as a power of the Reynolds number, under the assumption that the
physical characteristics of the liquid do not vary significantly from their value at nominal conditions.
</p>
<p align=\"center\" style=\"font-style:italic;\">
UA<sub>int, i</sub> = UA<sub>int, nom, i</sub> * (m&#775;<sub>i</sub> /
m&#775;<sub>nom, i</sub>)<sup>expUAi</sup>
</p>
<p>
where thedefault value of <i>expUA<sub>i</sub></i> stems from the Dittus and Boelter correlation for turbulent
flow.
</p>

<h4>References</h4>
<p>
Dittus and Boelter. 1930. Heat transfer in automobile radiators of the tubular type. University of California
Engineering Publication 13.443.
</p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-70,70},{70,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95}),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{200,260}})));
end HeatingOrCooling;
