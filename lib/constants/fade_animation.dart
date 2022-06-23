import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AnimationProps {
  opacity,
  translateY,
}

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({
    Key? key,
    required this.delay,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tweenAni = MultiTween<AnimationProps>()
      ..add(AnimationProps.opacity, 0.0.tweenTo(1.0), 500.milliseconds)
      ..add(AnimationProps.translateY, (-30.0).tweenTo(0.0), 500.milliseconds,
          Curves.easeOut);

    return PlayAnimation<MultiTweenValues<AnimationProps>>(
      duration: tweenAni.duration,
      delay: Duration(milliseconds: (500 * delay).round()),
      tween: tweenAni,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AnimationProps.opacity),
        child: Transform.translate(
          offset: Offset(0, value.get(AnimationProps.translateY)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
