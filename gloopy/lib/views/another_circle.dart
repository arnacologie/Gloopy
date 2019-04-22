import 'package:flutter/material.dart';
import 'package:circle_wheel_scroll/circle_wheel_scroll_view.dart';

class AnotherCircle extends StatefulWidget {
  @override
  _AnotherCircleState createState() => _AnotherCircleState();
}

class _AnotherCircleState extends State<AnotherCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Stack(
              children: <Widget>[
                CircleListScrollView(
                  physics: ScrollPhysics(),
                  axis: Axis.horizontal,
                  itemExtent: 80,
                  children: List.generate(20, _buildItem),
                  radius: MediaQuery.of(context).size.width * 0.2,
                ),
              ],
      ),
    );
  }

  Widget _buildItem(int i) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 80,
          padding: EdgeInsets.all(20),
          color: Colors.blue[100 * ((i % 8) + 1)],
          child: Center(
            child: Text(
              i.toString(),
            ),
          ),
        ),
      ),
    );
  }
}

