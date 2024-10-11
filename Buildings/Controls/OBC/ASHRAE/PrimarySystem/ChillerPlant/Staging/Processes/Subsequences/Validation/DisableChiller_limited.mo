within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model DisableChiller_limited
  "Validate sequence of disabling chiller during stage-down process"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller
    chiOff(
    final nChi=3,
    final proOnTim=300) "Disable chiller"
    annotation (Placement(transformation(extent={{42,70},{62,90}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not staCha "Stage change command"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiOne(
    final k=true) "Operating chiller one"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant disChi(
    final k=2) "Disabling chiller index"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaChi1(final k=0)
    "No Chiller needs to be enabled"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noOnOff(final k=false)
    "Does not requires one chiller on and another chiller off"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiTwo1 "Chiller two status"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noUpDev(final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre chiStaRet1[2]
    "Chiller status return value"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

equation
  connect(booPul.y, staCha.u)
    annotation (Line(points={{-138,60},{-122,60}}, color={255,0,255}));
  connect(enaChi1.y, chiOff.nexEnaChi)
    annotation (Line(points={{-58,100},{32,100},{32,89},{40,89}},
      color={255,127,0}));
  connect(staCha.y, chiOff.uStaDow)
    annotation (Line(points={{-98,60},{36,60},{36,86},{40,86}},
      color={255,0,255}));
  connect(chiOne.y, chiOff.uChi[1])
    annotation (Line(points={{-98,-20},{8,-20},{8,77.3333},{40,77.3333}},
      color={255,0,255}));
  connect(disChi.y, chiOff.nexDisChi)
    annotation (Line(points={{-98,-60},{16,-60},{16,75},{40,75}},
      color={255,127,0}));
  connect(noOnOff.y, chiOff.uOnOff)
    annotation (Line(points={{-98,-100},{34,-100},{34,71},{40,71}},
      color={255,0,255}));
  connect(chiOff.yChi[2], chiStaRet1[1].u)
    annotation (Line(points={{64,80},{78,80}},   color={255,0,255}));
  connect(chiOff.yChi[3], chiStaRet1[2].u) annotation (Line(points={{64,80.6667},
          {72,80.6667},{72,80},{78,80}},             color={255,0,255}));
  connect(staCha.y, chiTwo1.u2)
    annotation (Line(points={{-98,60},{36,60},{36,-40},{78,-40}},
      color={255,0,255}));
  connect(chiOne.y, chiTwo1.u3)
    annotation (Line(points={{-98,-20},{34,-20},{34,-48},{78,-48}},
      color={255,0,255}));
  connect(chiStaRet1[1].y, chiTwo1.u1) annotation (Line(points={{102,80},{110,
          80},{110,-22},{70,-22},{70,-32},{78,-32}},    color={255,0,255}));
  connect(chiTwo1.y, chiOff.uChi[2])
    annotation (Line(points={{102,-40},{110,-40},{110,-70},{8,-70},{8,78},{40,
          78}},          color={255,0,255}));
  connect(chiStaRet1[2].y, chiOff.uChi[3]) annotation (Line(points={{102,80},{
          110,80},{110,40},{12,40},{12,78.6667},{40,78.6667}},  color={255,0,
          255}));
  connect(noUpDev.y, chiOff.uEnaChiWatIsoVal)
    annotation (Line(points={{-98,20},{6,20},{6,82},{40,82}},
      color={255,0,255}));

annotation (
 experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/DisableChiller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-180,-120},{140,120}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{140,
            120}}), graphics={
        Text(
          extent={{-36,108},{12,102}},
          textColor={28,108,200},
          textString="Index of next enabled chiller"),
        Text(
          extent={{-70,66},{-22,62}},
          textColor={28,108,200},
          textString="Staging Command"),
        Text(
          extent={{-72,28},{-24,22}},
          textColor={28,108,200},
          textString="CHW IsoVal Enable Signal"),
        Text(
          extent={{-70,-14},{-22,-18}},
          textColor={28,108,200},
          textString="Chiller 1 Operation"),
        Text(
          extent={{-74,-52},{-20,-58}},
          textColor={28,108,200},
          textString="Index of Next Disabled Chiller"),
        Text(
          extent={{-92,-92},{24,-98}},
          textColor={28,108,200},
          textString=
              "False: does not require turning one chiller on and another off."),

        Text(
          extent={{42,-66},{76,-68}},
          textColor={28,108,200},
          textString="Chiller 2 Status"),
        Text(
          extent={{58,-18},{108,-20}},
          textColor={28,108,200},
          textString="Chi Status Return Value"),
        Text(
          extent={{44,44},{94,42}},
          textColor={28,108,200},
          textString="Chi Status Return Value")}));
end DisableChiller_limited;
