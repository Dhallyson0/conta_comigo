import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Image.asset(
              'assets/images/topo.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),

        SafeArea(
          child: child,
        ),
      ],
    );
  }
}