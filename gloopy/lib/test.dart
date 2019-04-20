import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/managers/user_manager.dart';
import 'package:gloopy/service_locator.dart';
import 'package:gloopy/services/dialog_helper.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/views/chat_view.dart';
import 'package:gloopy/widgets/animator.dart';
import 'package:gloopy/widgets/planet_widget.dart';

class ContactTestView extends StatefulWidget {
  @override
  ContactTestViewState createState() => ContactTestViewState();
}

class ContactTestViewState extends State<ContactTestView> {
  Color caughtColor = Colors.grey;
  List<Widget> products;
  List<Widget> products2;
  TAnimator _tAnimator;

  static double _radiansPerDegree = pi / 180;
  final double _startAngle = -90.0 * _radiansPerDegree;
  Random random;
  Size size;
  final List<String> planetImages = [
    'images/planets/PLANET-PRINCESSE-2.png',
    'images/planets/PLANET-PRINCESSE-1.png',
    'images/planets/PLANET-GLOOPY-1.png',
    'images/planets/PLANET-GLOOPY-1.png'
  ];
  final List<int> idRings = [0, 1, 2, 3];
  int noRing = -1;
  List<Widget> planets;
  List<Widget> ring0;
  List<Widget> ring1;
  List<Widget> ring2;
  List<Widget> ring3;
  bool isLoading = false;

  List<Widget> buildRings(
      BuildContext context, List<DocumentSnapshot> documents) {
    planets = documents.map((doc) {
      noRing++;
      print(noRing);
      Planet p = Planet(
        document: doc,
        backgroundImg: planetImages[random.nextInt(4)],
      );
      switch (noRing % 4) {
        case 0:
          ring0.add(LayoutId(
            id: doc['id'],
            child: p,
          ));
          print(doc['id']);
          break;
        case 1:
          ring1.add(LayoutId(
            id: doc['id'],
            child: p,
          ));
          print(doc['id']);

          break;
        case 2:
          ring2.add(LayoutId(
            id: doc['id'],
            child: p,
          ));
          break;
        case 3:
          ring3.add(LayoutId(
            id: doc['id'],
            child: p,
          ));
          break;
        default:
      }
      return p;
    }).toList();

    return planets;
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == sl.get<UserManager>().currentUser.uid) {
      return Container();
    } else {
      noRing += (noRing + 1) % 4;
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(15.0),
                      ),
                  imageUrl: document['photo_url'],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${document['nickname']}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'About me: ${document['about_me'] ?? 'Not available'}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                FadeNavRoute(
                    builder: (context) => ChatView(
                          peerId: document.documentID,
                          peerAvatar: document['photo_url'],
                        )));
          },
          color: greyColor2,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: StreamBuilder(
                stream: Firestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    );
                  } else {
                    print(buildRings(
                      context,
                      snapshot.data.documents,
                    ));
                    // return Container(
                    //     child: ListView(
                    //   children: planets,
                    // ));
                    print(
                        "0 : ${ring0.length}, 1 : ${ring1.length}, 2 : ${ring2.length}, 3 : ${ring3.length},");
                    return Stack(
                      children: <Widget>[
                        CustomMultiChildLayout(
                          delegate: _CircularLayoutDelegate(
                              itemCount: products.length,
                              radius: 135.0,
                              sAngle: -(random.nextDouble() * 20.0 + 110.0) *
                                  _radiansPerDegree),
                          children: products,
                        ),
                        CustomMultiChildLayout(
                          delegate: _CircularLayoutDelegate(
                              itemCount: products2.length,
                              radius: 275.0,
                              sAngle: -(random.nextDouble() * 20.0 + 110.0) *
                                  _radiansPerDegree),
                          children: products2,
                        ),
                        CustomMultiChildLayout(
                          delegate: _CircularLayoutDelegate(
                              itemCount: ring2.length,
                              radius: 415.0,
                              sAngle: -(random.nextDouble() * 20.0 + 110.0) *
                                  _radiansPerDegree),
                          children: ring2,
                        ),
                        CustomMultiChildLayout(
                          delegate: _CircularLayoutDelegate(
                              itemCount: ring3.length,
                              radius: 555.0,
                              sAngle: -(random.nextDouble() * 20.0 + 110.0) *
                                  _radiansPerDegree),
                          children: ring3,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor)),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            )
          ],
        ),
        onWillPop: () => sl.get<DialogHelper>().onBackPress(context),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    products = List<Widget>();
    products2 = List<Widget>();
    planets = List<Widget>();
    ring0 = List<Widget>();
    ring1 = List<Widget>();
    ring2 = List<Widget>();
    ring3 = List<Widget>();

    random = Random();
    for (int i = 0; i < 2; i++) {
      products.add(LayoutId(
        id: 'BUTTON$i',
        //child: Icon(Icons.cloud_circle, size: 75.0,),
        child: FlatButton(
      onPressed: () {
            Navigator.push(
                context,
                FadeNavRoute(
                    builder: (context) => ChatView(
                          peerId: "widget.document.documentID",
                          peerAvatar: "widget.document['photo_url']",
                        )));
          },
          child: Container(
        width: 100,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              'images/planets/PLANET-GLOOPY-1.png',
              width: 100,
              fit: BoxFit.fitWidth,
            ),
            Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                      width: 60.0,
                      height: 60.0,
                      padding: EdgeInsets.all(15.0),
                    ),
                imageUrl: "https://firebasestorage.googleapis.com/v0/b/gloopy-aebbc.appspot.com/o/ic_launcher.png.png?alt=media&token=a1dfcc89-948d-452f-b849-d2cf5a38a396",
                width: 60.0,
                height: 60.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Positioned(
              bottom: 0,
              child: Text('nickname'),
            )
          ],
        ),
      ),
    ),
      ));
      
    }
    for (int i = 0; i < 3; i++) {
      products2.add(LayoutId(
        id: 'BUTTON$i',
        //child: Icon(Icons.cloud_circle, size: 75.0,),
        child: Image.asset(
          planetImages[random.nextInt(4)],
          width: 100,
          fit: BoxFit.fitWidth,
        ),
      ));
      
    }
    _tAnimator = TAnimator(
      animated: false,
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         _tAnimator,
//         Container(
//               padding: EdgeInsets.only(top: 20.0),
//               child: StreamBuilder(
//                 stream: Firestore.instance.collection('users').snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(themeColor),
//                       ),
//                     );
//                   } else {
//                     return ListView.builder(
//                       padding: EdgeInsets.all(10.0),
//                       itemBuilder: (context, index) =>
//                           buildItem(context, snapshot.data.documents[index]),
//                       itemCount: snapshot.data.documents.length,
//                     );
//                   }
//                 },
//               ),
//             ),
//         CustomMultiChildLayout(
//           delegate: _CircularLayoutDelegate(
//             itemCount: 8,
//             radius: 135.0,
//             sAngle: -(random.nextDouble()*20.0+110.0) * _radiansPerDegree
//           ),
//           children: products,
//         ),
//         CustomMultiChildLayout(
//           delegate: _CircularLayoutDelegate(
//             itemCount: 8,
//             radius: 275.0,
//             sAngle: -(random.nextDouble()*20.0+110.0) * _radiansPerDegree
//           ),
//           children: products,
//         ),
//         CustomMultiChildLayout(
//           delegate: _CircularLayoutDelegate(
//             itemCount: 8,
//             radius: 415.0,
//             sAngle: -(random.nextDouble()*20.0+110.0) * _radiansPerDegree
//           ),
//           children: products,
//         ),
//         CustomMultiChildLayout(
//           delegate: _CircularLayoutDelegate(
//             itemCount: 8,
//             radius: 555.0,
//             sAngle: -(random.nextDouble()*20.0+110.0) * _radiansPerDegree
//           ),
//           children: products,
//         ),
//       ],
//     );
//   }
// }

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
