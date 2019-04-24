import 'package:flutter/material.dart';
import 'package:gloopy/widgets/planet_widget.dart';
import 'package:gloopy/widgets/radial_position.dart';
import 'dart:math';

class RadialList extends StatefulWidget {

  final List<Planet> radialList;
  final double radius;

  RadialList({
    this.radialList,
    this.radius,
  });

  List<Widget> _radialListItems(){
    final double firstItemAngle = pi;
    final double lastItemAngle = pi;
    final double angleDiff = (firstItemAngle + lastItemAngle) / (radialList.length);
    double currentAngle = firstItemAngle;
    return radialList.map((Planet viewModel){
      final listItem = _radialListItem(viewModel,currentAngle);
      currentAngle += angleDiff;
      return listItem;
    }).toList();
  }

  Widget _radialListItem(Planet viewModel, double angle){
      return RadialPosition(
        radius: radius,
        angle: angle,
        child: viewModel
      );
  }

  @override
  RadialListState createState() {
    return new RadialListState();
  }
}

class RadialListState extends State<RadialList> {
  @override
  Widget build(BuildContext context) {
    return widget._radialListItems()[0];
  }
}

class RadialListItem extends StatefulWidget {

  final Planet listItem;

  RadialListItem({
    this.listItem
  });

  @override
  RadialListItemState createState() {
    return new RadialListItemState();
  }

}

class RadialListItemState extends State<RadialListItem> {
  @override
  Widget build(BuildContext context) {
    return widget.listItem;
  }
}

class RadialListViewModel{
  final List<RadialListItemViewModel> items;
  RadialListViewModel({
    this.items = const [],
  });
}


class RadialListItemViewModel{
  int number;
  bool isSelected;

  RadialListItemViewModel({
    this.isSelected=false,
    this.number,
  });

}