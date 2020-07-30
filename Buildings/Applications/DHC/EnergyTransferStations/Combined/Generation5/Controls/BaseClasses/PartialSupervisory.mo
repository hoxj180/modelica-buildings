within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses;
partial block PartialSupervisory "Partial model for supervisory controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nSouAmb
    "Number of ambient sources to control"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal" annotation (Placement(transformation(extent={{-160,80},
            {-120,120}}), iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal" annotation (Placement(transformation(extent={{-160,60},
            {-120,100}}), iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupPreSet(final unit="K",
      displayUnit="degC") "Chilled water supply temperature set-point"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatTop(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank top"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatBot(
    final unit="K",displayUnit="degC")
    "Chilled water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
       iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatTop(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank top"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatBot(
    final unit="K",displayUnit="degC")
    "Heating water temperature at tank bottom"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupPreSet(
    final unit="K", displayUnit="degC") "Heating water supply temperature set-point"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "Heating water supply temperature set-point after reset" annotation (
      Placement(transformation(extent={{120,-60},{160,-20}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set-point after reset" annotation (
      Placement(transformation(extent={{120,-80},{160,-40}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoEva(
    final unit="1")
    "Evaporator to ambient loop isolation valve control signal" annotation (
      Placement(transformation(extent={{120,0},{160,40}}),  iconTransformation(
          extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoCon(
    final unit="1") "Condenser to ambient loop isolation valve control signal"
    annotation (
      Placement(transformation(extent={{120,20},{160,60}}),  iconTransformation(
          extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAmb[nSouAmb](
    each final unit="1") "Control output for ambient sources" annotation (
      Placement(transformation(extent={{120,-20},{160,20}}),iconTransformation(
          extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHea
    "Tank in heating demand"            annotation (Placement(transformation(
          extent={{120,80},{160,120}}), iconTransformation(extent={{100,70},{140,
            110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yCoo
    "Tank in cooling demand" annotation (Placement(transformation(extent={{120,60},
            {160,100}}), iconTransformation(extent={{100,50},{140,90}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})),
        defaultComponentName="conSup",
Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This block implements the supervisory control functions of the ETS.
</p>
<ul>
<li>
It provides the tank demand signals to enable the chiller system, 
based on the logic described in
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold</a>.
</li>
<li>
It resets the heating water and chilled water supply temperature
based on the logic described in
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Reset</a>.
Note that this resetting logic is meant to operate the chiller at low lift.
The chilled water supply temperature may be reset down by
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Chiller\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Chiller</a>
to maintain the heating water supply temperature set point. 
This second resetting logic is required for the heating function of the unit, 
but it has a negative impact on the lift.
</li>
<li>
It controls the systems serving as ambient sources based on the logic described in
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold</a>.
The systems are controlled based on the
maximum of the control signals yielded by the hot side and cold side controllers.
</li>
</ul>
</html>"));
end PartialSupervisory;
