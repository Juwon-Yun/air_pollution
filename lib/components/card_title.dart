import 'package:air_pollution/constants/custom_theme.dart';
import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String title;

  const CardTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        color: darkColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          title,
          style: defaultTextStyle.copyWith(
              fontSize: 14, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
