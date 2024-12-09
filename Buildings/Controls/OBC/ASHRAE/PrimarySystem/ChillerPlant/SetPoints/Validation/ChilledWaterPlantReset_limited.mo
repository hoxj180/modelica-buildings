within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.Validation;
model ChilledWaterPlantReset_limited
  "Validate model of generating chilled water plant reset for 2 chiller dcs application"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset
    plaRes "Chilled water plant reset"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uChiWatPum[2](
    final k={true,false}) "Plant status"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTabLin1(
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments, final
      table=[0,0; 150,1; 300,2; 450,3; 600,4; 750,5; 900,6; 1050,5; 1200,4;
        1350,3; 1500,2; 1650,1; 1800,0; 1950,0; 2100,2; 2250,4; 2400,6; 2550,8;
        2700,10; 2850,12; 3000,10; 3150,8; 3300,6; 3450,4; 3600,2; 3750,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    width=0.1,
    final period=7200,
    shift=3600)
    "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

equation
  connect(uChiWatPum.y, plaRes.uChiWatPum)
    annotation (Line(points={{-58,30},{40,30},{40,26},{58,26}}, color={255,0,255}));
  connect(reaToInt1.y, plaRes.TChiWatSupResReq)
    annotation (Line(points={{-28,0},{38,0},{38,20},{58,20}},  color={255,127,0}));
  connect(timTabLin1.y[1], reaToInt1.u)
    annotation (Line(points={{-58,0},{-52,0}},  color={0,0,127}));
  connect(booPul1.y, plaRes.chaPro)
    annotation (Line(points={{-18,-30},{40,-30},{40,14},{58,14}},
                                                               color={255,0,255}));

annotation (
  experiment(StopTime=9000.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/SetPoints/Validation/ChilledWaterPlantReset.mos"
    "Simulate and plot", file=
          "Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/SetPoints/Validation/ChilledWaterPlantReset_limited.mos"
        "Simulate and plot - test"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-36,36},{18,32}},
          textColor={28,108,200},
          textString="Chilled Water Pump Status"),
        Text(
          extent={{-22,6},{32,2}},
          textColor={28,108,200},
          textString="CHWST Reset Request"),
        Text(
          extent={{-18,-24},{36,-28}},
          textColor={28,108,200},
          textString="Plant Staging Status")}));
end ChilledWaterPlantReset_limited;
