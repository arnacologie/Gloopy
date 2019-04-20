import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gloopy/widgets/animator.dart';

class ContactTestView extends StatefulWidget {
  @override
  ContactTestViewState createState() => ContactTestViewState();
}

class ContactTestViewState extends State<ContactTestView> {
  Color caughtColor = Colors.grey;
  List<Widget> products;
  TAnimator _tAnimator;

  static double _radiansPerDegree = pi / 180;
  final double _startAngle = -90.0 * _radiansPerDegree;
  Random random;
  Size size;
  final List<String> planetImages = ['images/planets/PLANET-PRINCESSE-2.png', 'images/planets/PLANET-PRINCESSE-1.png', 'images/planets/PLANET-GLOOPY-1.png', 'images/planets/PLANET-GLOOPY-1.png'];
  
  @override
  void initState() {

    super.initState();
    products = List<Widget>();

    random = Random();
    for (int i = 0; i < 2; i++) {
      products.add(LayoutId(
        id: 'BUTTON$i',
        //child: Icon(Icons.cloud_circle, size: 75.0,),
        child: Image.asset(
                        planetImages[random.nextInt(4)],
                        width: 100,
                        fit: BoxFit.fitWidth,
                      ),
      ));
    }
    _tAnimator = TAnimator(animated: false,);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _tAnimator,
        CustomMultiChildLayout(
          delegate: _CircularLayoutDelegate(
            itemCount: 8,
            radius: 135.0,
            sAngle: -(random.nextDouble()*20.0+110.0) * _radiansPerDegree
          ),
          children: products,
        ),
        CustomMultiChildLayout(
          delegate: _CircularLayoutDelegate(
            itemCount: 8,
            radius: 275.0,
            sAngle: -(random.nextDouble()*20.0+110.0) * _radiansPerDegree
          ),
          children: products,
        ),
        CustomMultiChildLayout(
          delegate: _CircularLayoutDelegate(
            itemCount: 8,
            radius: 415.0,
            sAngle: -(random.nextDouble()*20.0+110.0) * _radiansPerDegree
          ),
          children: products,
        ),
        CustomMultiChildLayout(
          delegate: _CircularLayoutDelegate(
            itemCount: 8,
            radius: 555.0,
            sAngle: -(random.nextDouble()*20.0+110.0) * _radiansPerDegree
          ),
          children: products,
        ),
      ],
    );
  }
}

class _CircularLayoutDelegate extends MultiChildLayoutDelegate {
  static const String actionButton = 'BUTTON';
  Offset center;
  final int itemCount;
  final double radius;
  final double sAngle;
  static double _radiansPerDegree = pi / 180;
  double _itemSpacing = 360.0 / 8.0;
  double _calculateItemAngle(int index) {
    return sAngle + index * _itemSpacing * _radiansPerDegree;
  }

  _CircularLayoutDelegate({
    @required this.itemCount,
    @required this.radius,
    @required this.sAngle,
  });

  @override
  void performLayout(Size size) {
    center = Offset(size.width / 2, size.height);
    for (int i = 0; i < itemCount; i++) {
      final String actionButtonId = '$actionButton$i';

      if (hasChild(actionButtonId)) {
        final Size buttonSize =
            layoutChild(actionButtonId, BoxConstraints.loose(size));
        final double itemAngle = _calculateItemAngle(i);

        positionChild(
          actionButtonId,
          Offset(
            (center.dx - buttonSize.width / 2) + (radius) * cos(itemAngle),
            (center.dy - buttonSize.height / 2) + (radius) * sin(itemAngle),
          ),
        );
      }
    }
  }

  @override
  bool shouldRelayout(_CircularLayoutDelegate oldDelegate) =>
      itemCount != oldDelegate.itemCount || radius != oldDelegate.radius;
}
