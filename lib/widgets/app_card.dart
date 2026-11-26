import 'package:flutter/material.dart';

import '../core/theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final double? height;
  final double? width;
  final BoxConstraints? constraints;

  const AppCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.backgroundColor = AppColors.branco,
    this.borderColor,
    this.borderWidth = 1,
    this.boxShadow,
    this.height,
    this.width,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: borderColor == null
            ? null
            : Border.all(
                color: borderColor!,
                width: borderWidth,
              ),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}
