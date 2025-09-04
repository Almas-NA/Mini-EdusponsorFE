import 'package:edusponsor/Common/color_generator.dart';
import 'package:flutter/material.dart';

//  ###########  Colors ########## //

Color? primaryColor = Colors.blue[400];
Color? secondaryColor = Colors.cyan;

MaterialColor primaryShade = generateMaterialColor(primaryColor!);
MaterialColor primaryShadeLight = generateMaterialColor(primaryShade.shade50);
MaterialColor primaryShadeDark = generateMaterialColor(primaryShade.shade900);

MaterialColor secondaryShade = generateMaterialColor(secondaryColor!);
MaterialColor secondaryShadeLight = generateMaterialColor(
  secondaryShade.shade50,
);
MaterialColor secondaryShadeDark = generateMaterialColor(
  secondaryShade.shade900,
);

// ########
final double shortSide = MediaQueryData.fromView(
  WidgetsBinding.instance.window,
).size.shortestSide;
final double longestSide = MediaQueryData.fromView(
  WidgetsBinding.instance.window,
).size.longestSide;

final double scalefactor = shortSide < 600
    ? 1
    : shortSide < 800
    ? 1.4
    : 1.6;
