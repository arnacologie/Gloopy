import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

class TAnimator extends StatefulWidget {
  @override
  _TAnimatorState createState() => _TAnimatorState();
  const TAnimator({@required this.animated});
  final bool animated;
}

class _TAnimatorState extends State<TAnimator> {
  ExactAssetImage backgroundImageCircular;
  ExactAssetImage backgroundImagePaysage;

  @override
  void initState() {
    backgroundImageCircular = ExactAssetImage('images/backgrounds/circle_background.png');
    backgroundImagePaysage = ExactAssetImage('images/backgrounds/background_small_p.png');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.animated
        ? Animator(
            tween: Tween(begin: 0.0, end: 2.0 * pi),
            duration: Duration(seconds: 140),
            repeats: 0,
            builder: (anim) => Transform.rotate(
                  angle: anim.value,
                  child: OverflowBox(
                    maxHeight: size.height * 1.25,
                    maxWidth: size.height * 1.25,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        image: backgroundImageCircular != null
                            ? new DecorationImage(
                                image: backgroundImageCircular, fit: BoxFit.fitHeight)
                            : null,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
          )
        : Image.asset(
              'images/backgrounds/background_small_p.jpg',
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            );
  }
}
