import 'dart:math';

import 'package:flutter/material.dart';

class ContactTestView extends StatefulWidget {
  @override
  ContactTestViewState createState() => ContactTestViewState();
}

class ContactTestViewState extends State<ContactTestView> {
  Color caughtColor = Colors.grey;
  List<Widget> products;

  static double _radiansPerDegree = pi / 180;
  final double _startAngle = -90.0 * _radiansPerDegree;
  Random random;

  @override
  void initState() {
    products = List<Widget>();
    for (int i = 0; i < 1; i++) {
      products.add(LayoutId(
        id: 'BUTTON$i',
        child: Icon(Icons.cloud_circle),
      ));
    }
    random = Random();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomMultiChildLayout(
          delegate: _CircularLayoutDelegate(
            itemCount: 7,
            radius: 45.0,
            sAngle: -(random.nextDouble()*20.0+70.0) * _radiansPerDegree
          ),
          children: products,
        ),
        CustomMultiChildLayout(
          delegate: _CircularLayoutDelegate(
            itemCount: 7,
            radius: 95.0,
            sAngle: -(random.nextDouble()*20.0+70.0) * _radiansPerDegree
          ),
          children: products,
        ),
        CustomMultiChildLayout(
          delegate: _CircularLayoutDelegate(
            itemCount: 7,
            radius: 145.0,
            sAngle: -(random.nextDouble()*20.0+70.0) * _radiansPerDegree
          ),
          children: products,
        ),
        CustomMultiChildLayout(
          delegate: _CircularLayoutDelegate(
            itemCount: 7,
            radius: 195.0,
            sAngle: -(random.nextDouble()*20.0+70.0) * _radiansPerDegree
          ),
          children: products,
        ),
        CustomMultiChildLayout(
          delegate: _CircularLayoutDelegate(
            itemCount: 7,
            radius: 245.0,
            sAngle: -(random.nextDouble()*20.0+70.0) * _radiansPerDegree
          ),
          children: products,
        )
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
  final double _startAngle = -90.0 * _radiansPerDegree;
  double _itemSpacing = 360.0 / 7.0;
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
    center = Offset(size.width / 2, size.height / 2);
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
