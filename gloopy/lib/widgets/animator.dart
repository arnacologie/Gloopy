import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animator/animator.dart';


class TAnimator extends StatefulWidget {
  @override
  _TAnimatorState createState() => _TAnimatorState();
}


class _TAnimatorState extends State<TAnimator> {
    ExactAssetImage backgroundImage;


  @override
  void initState() {
    backgroundImage = ExactAssetImage('images/backgrounds/circle_background.png');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Animator(
      tween: Tween(begin: 0.0, end: 2.0*pi),
      duration: Duration(seconds: 140),
      repeats: 0,
      builder: (anim) => Transform.rotate(
        angle: anim.value,
        child: OverflowBox(
        maxHeight: size.height*1.25,
        maxWidth: size.height*1.25,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue,
            image: backgroundImage != null
                ? new DecorationImage(
                    image: backgroundImage, fit: BoxFit.fitHeight)
                : null,
            shape: BoxShape.circle,
          ),
        ),
      ),
      ),
    );
  }
}

