import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/views/pre_login_view.dart';

class LaunchView extends StatefulWidget {
  @override
  _LaunchViewState createState() => _LaunchViewState();
}

class _LaunchViewState extends State<LaunchView>
    with SingleTickerProviderStateMixin {
  static const _aDuration = const Duration(milliseconds: 950);
  AnimationController _animationController;
  Animation _animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: _aDuration);
    _animationController.addListener(loopAnimation);
    _animation = Tween(begin: 3.0, end: 4.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.ease));
    _animationController.forward();
    Timer(Duration(seconds: 4), () =>Navigator.pushReplacement(context,FadeNavRoute(builder: (context) => PreLoginView()),),);
    super.initState();
  }
  


  loopAnimation() {
    if (_animation.value == 4.0)
      _animationController.reverse();
    else if (_animation.value == 3.0) _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              'images/backgrounds/background_small_p.jpg',
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            ),
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'images/logos/gloopy_character.png',
                width: 50,
                height: 50,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
