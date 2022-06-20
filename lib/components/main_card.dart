import 'package:air_pollution/constants/custom_theme.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final Widget child;

  const MainCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      color: lightColor,
      child: child,
    );
  }
}
