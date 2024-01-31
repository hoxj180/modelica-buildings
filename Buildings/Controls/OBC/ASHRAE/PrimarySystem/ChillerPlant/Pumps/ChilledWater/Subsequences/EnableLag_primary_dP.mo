within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block EnableLag_primary_dP
  "Sequences for enabling and disabling lag pumps for primary-only plants using differential pressure pump speed control"
  parameter Integer nPum = 2 "Total number of pumps";
  parameter Real timPer(
    final unit="s",
    final quantity="Time")=600
      "Delay time period for enabling and disabling lag pumps";
  parameter Real staCon = -0.03 "Constant used in the staging equation"
    annotation (Dialog(tab="Advanced"));
  parameter Real relFloHys = 0.01
    "Constant value used in hysteresis for checking relative flow rate"
    annotation (Dialog(tab="Advanced"));
  parameter Integer nPum_nominal(
    final max = nPum,
    final min = 1) = nPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real VChiWat_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1e-6)=0.5
    "Total plant design chilled water flow rate"
    annotation (Dialog(group="Nominal conditions"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Chilled water flow"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
      iconTransformation(extent={{-140,-58},{-100,-18}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUp
    "Next lag pump status, a rising edge indicates that next lag pump should be enabled"
    annotation (Placement(transformation(extent={{220,40},{260,80}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDown
    "Last lag pump status, a falling edge indicates that last lag pump should be disabled"
    annotation (Placement(transformation(extent={{220,-100},{260,-60}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=(-1)*relFloHys,
    final uHigh=relFloHys)
    "Check if condition for enabling next lag pump is satisfied"
    annotation (Placement(transformation(extent={{-100,58},{-80,78}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    final uLow=(-1)*relFloHys,
    final uHigh=relFloHys)
    "Check if condition for disabling last lag pump is satisfied"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter chiWatFloRat(
    final k=1/VChiWat_flow_nominal) "Chiller water flow ratio"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=staCon) "Add parameter"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar2(
    final p=staCon) "Add parameter"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=timPer)
    "Check if the time is greater than delay time period"
    annotation (Placement(transformation(extent={{-40,58},{-20,78}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(
    final t=timPer)
    "Check if the time is greater than delay time period"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nPum]
    "Convert boolean input to integer number"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numOpePum(final nin=nPum)
    "Total number of operating pumps"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer to real"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=-1) "Add real inputs"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Find inputs difference"
    annotation (Placement(transformation(extent={{-140,58},{-120,78}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Find inputs difference"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Switch enaNexLag
    "Enabling next lag pump"
    annotation (Placement(transformation(extent={{180,50},{200,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch shuLasLag
    "Shut off last lag pump"
    annotation (Placement(transformation(extent={{180,-90},{200,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "Logical true"
    annotation (Placement(transformation(extent={{120,150},{140,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg "Rising edge"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{120,-180},{140,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1 "Rising edge"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter nomPum(
    final k=1/nPum_nominal)
    "Pump number ratio"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter nomPum1(
    final k=1/nPum_nominal)
    "Pump number ratio"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

equation
  connect(VChiWat_flow,chiWatFloRat. u)
    annotation (Line(points={{-240,80},{-202,80}}, color={0,0,127}));
  connect(uChiWatPum,booToInt. u)
    annotation (Line(points={{-240,0},{-202,0}}, color={255,0,255}));
  connect(booToInt.y,numOpePum. u)
    annotation (Line(points={{-178,0},{-142,0}},
      color={255,127,0}));
  connect(numOpePum.y,intToRea. u)
    annotation (Line(points={{-118,0},{-102,0}}, color={255,127,0}));
  connect(sub2.y,hys. u)
    annotation (Line(points={{-118,68},{-102,68}}, color={0,0,127}));
  connect(sub1.y,hys1. u)
    annotation (Line(points={{-118,-170},{-102,-170}}, color={0,0,127}));
  connect(addPar.y, sub2.u2)
    annotation (Line(points={{42,0},{70,0},{70,38},{-160,38},{-160,62},{-142,62}},
      color={0,0,127}));
  connect(intToRea.y, addPar1.u)
    annotation (Line(points={{-78,0},{-70,0},{-70,-40},{-62,-40}},
      color={0,0,127}));
  connect(addPar2.y, sub1.u1)
    annotation (Line(points={{42,-40},{60,-40},{60,-60},{-150,-60},{-150,-164},{
          -142,-164}}, color={0,0,127}));
  connect(chiWatFloRat.y, sub2.u1)
    annotation (Line(points={{-178,80},{-170,80},{-170,74},{-142,74}}, color={0,0,127}));
  connect(chiWatFloRat.y, sub1.u2)
    annotation (Line(points={{-178,80},{-170,80},{-170,-176},{-142,-176}},
                  color={0,0,127}));
  connect(con.y, enaNexLag.u1)
    annotation (Line(points={{142,160},{160,160},{160,68},{178,68}}, color={255,0,255}));
  connect(con.y, shuLasLag.u3)
    annotation (Line(points={{142,160},{160,160},{160,-88},{178,-88}}, color={255,0,255}));
  connect(shuLasLag.y, yDown)
    annotation (Line(points={{202,-80},{240,-80}}, color={255,0,255}));
  connect(enaNexLag.y, yUp)
    annotation (Line(points={{202,60},{240,60}}, color={255,0,255}));
  connect(con1.y, enaNexLag.u3)
    annotation (Line(points={{142,0},{170,0},{170,52},{178,52}},
      color={255,0,255}));
  connect(con1.y, shuLasLag.u1)
    annotation (Line(points={{142,0},{170,0},{170,-72},{178,-72}},
      color={255,0,255}));
  connect(edg.y, not1.u)
    annotation (Line(points={{62,-140},{78,-140}},  color={255,0,255}));
  connect(edg.u, pre.y)
    annotation (Line(points={{38,-140},{22,-140}},   color={255,0,255}));
  connect(hys1.y, and2.u1)
    annotation (Line(points={{-78,-170},{118,-170}},
      color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{102,-140},{110,-140},{110,-178},{118,-178}},
      color={255,0,255}));
  connect(and2.y, tim1.u)
    annotation (Line(points={{142,-170},{160,-170},{160,-110},{-50,-110},{-50,-80},
          {-42,-80}}, color={255,0,255}));
  connect(edg1.y, not2.u)
    annotation (Line(points={{62,130},{78,130}}, color={255,0,255}));
  connect(edg1.u, pre1.y)
    annotation (Line(points={{38,130},{22,130}}, color={255,0,255}));
  connect(not2.y, and1.u1)
    annotation (Line(points={{102,130},{110,130},{110,110},{118,110}}, color={255,0,255}));
  connect(hys.y, and1.u2)
    annotation (Line(points={{-78,68},{-60,68},{-60,102},{118,102}}, color={255,0,255}));
  connect(and1.y, tim.u)
    annotation (Line(points={{142,110},{150,110},{150,90},{-50,90},{-50,68},{-42,
          68}}, color={255,0,255}));
  connect(tim.passed, enaNexLag.u2) annotation (Line(points={{-18,60},{178,60}},
          color={255,0,255}));
  connect(tim.passed, pre1.u) annotation (Line(points={{-18,60},{-10,60},{-10,130},
          {-2,130}}, color={255,0,255}));
  connect(tim1.passed, shuLasLag.u2) annotation (Line(points={{-18,-88},{150,-88},
          {150,-80},{178,-80}}, color={255,0,255}));
  connect(tim1.passed, pre.u) annotation (Line(points={{-18,-88},{-10,-88},{-10,
          -140},{-2,-140}},                    color={255,0,255}));
  connect(intToRea.y, nomPum.u)
    annotation (Line(points={{-78,0},{-42,0}},color={0,0,127}));
  connect(nomPum.y, addPar.u)
    annotation (Line(points={{-18,0},{18,0}},color={0,0,127}));
  connect(addPar1.y, nomPum1.u)
    annotation (Line(points={{-38,-40},{-22,-40}}, color={0,0,127}));
  connect(nomPum1.y, addPar2.u)
    annotation (Line(points={{2,-40},{18,-40}},   color={0,0,127}));

annotation (
  defaultComponentName="enaLagChiPum",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,52},{-38,30}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-98,-24},{-34,-48}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{64,48},{98,34}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yUp"),
        Text(
          extent={{62,-26},{96,-50}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yDown")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-200},{220,200}})),
  Documentation(info="<html>
<p>
Block that enable and disable lag primary chilled water pump, for plants
with headered primary chilled water pumps,
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 23, 2020),
section 5.2.6 Primary chilled water pumps, part 5.2.6.6.
</p>
<p>
Chilled water pump shall be staged as a function of chilled water flow ratio (CHWFR),
i.e. the ratio of current chilled water flow <code>VChiWat_flow</code> to design
flow <code>VChiWat_flow_nominal</code>, and the number of pumps <code>num_nominal</code>
that operate at design conditions. Pumps are assumed to be equally sized.
</p>
<pre>
                  VChiWat_flow
     CHWFR = ----------------------
              VChiWat_flow_nominal
</pre>
<p>
1. Start the next lag pump <code>yNexLagPum</code> whenever the following is
true for 10 minutes:
</p>
<pre>
              Number_of_operating_pumps
     CHWFR &gt; ---------------------------  - 0.03
                       num_nominal
</pre>
<p>
2. Shut off the last lag pump whenever the following is true for 10 minutes:
</p>
<pre>
              Number_of_operating_pumps - 1
     CHWFR &le; -------------------------------  - 0.03
                       num_nominal
</pre>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLag_primary_dP;
