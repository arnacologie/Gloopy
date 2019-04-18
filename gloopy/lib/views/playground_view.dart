import 'package:flutter/material.dart';

class PlaygroundView extends StatefulWidget {
  @override
  _PlaygroundViewState createState() => _PlaygroundViewState();
}

class _PlaygroundViewState extends State<PlaygroundView> {
  ExactAssetImage backgroundImage;
  Size size;

  @override
  void initState() {
    super.initState();

    //size = MediaQuery.of(context).size;
    // backgroundImage = Image.asset(
    //           'images/backgrounds/FOND-PLANET.jpg',
    //           width: size.width,
    //           height: size.height,
    //           fit: BoxFit.cover,
    //         );
    backgroundImage =
        ExactAssetImage('images/backgrounds/circle_background.png');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: OverflowBox(
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
    );
  }
}
