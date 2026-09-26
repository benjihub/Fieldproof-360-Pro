import 'package:fieldproof_360/app/branding/brand.dart';
import 'package:flutter/material.dart';

class AppLogoIcon extends StatelessWidget {
  const AppLogoIcon({this.size = 96, this.semanticLabel, super.key});

  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => Image.asset(
    Brand.iconAsset,
    width: size,
    height: size,
    fit: BoxFit.contain,
    semanticLabel: semanticLabel ?? Brand.appName,
  );
}
