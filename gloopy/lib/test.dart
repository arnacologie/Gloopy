import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/managers/user_manager.dart';
import 'package:gloopy/numbers_list.dart';
import 'package:gloopy/radial_list.dart';
import 'package:gloopy/service_locator.dart';
import 'package:gloopy/services/dialog_helper.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/views/chat_view.dart';
import 'package:gloopy/widgets/animator.dart';
import 'package:gloopy/widgets/planet_widget.dart';
import 'package:circle_wheel_scroll/circle_wheel_scroll_view.dart';
import 'package:gloopy/widgets/radial_position.dart';

class ContactTestView extends StatefulWidget {
  @override
  ContactTestViewState createState() => ContactTestViewState();
}

class ContactTestViewState extends State<ContactTestView> {
  Color caughtColor = Colors.grey;
  TAnimator _tAnimator;
  static double _radiansPerDegree = pi / 180;
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
  List<Planet> ring0, ring1, ring2, ring3;
  bool isLoading = false;
  Offset position = Offset(0.0, 1.0);
  bool isDragging = false;
  double rotationValue = 0.0;
  DragUpdateDetails lastDragCoord;

  @override
  void initState() {
    super.initState();
    ring0 = List<Planet>();
    ring1 = List<Planet>();
    ring2 = List<Planet>();
    ring3 = List<Planet>();
    random = Random();
    _tAnimator = TAnimator(
      animated: false,
    );
  }

  _onHDragStart(coord) {
    print('The user has started dragging horizontally at: $coord');
    setState(() {
      isDragging = true;
      lastDragCoord = coord;
    });
  }

  _onHDragUpdate(coord) {
    print('The user has dragged horizontally to: $coord');
    setState(() {
      lastDragCoord = coord;
      rotationValue =
          ((rotationValue + (lastDragCoord.primaryDelta) * 0.01) % 360);
      print("rotationValue $rotationValue");
    });
  }

  _onHDragEnd(coord) {
    print('The user has stopped dragging horizontally. $coord');
    setState(() => isDragging = false);
  }

  _dragStatus() {
    if (isDragging) {
      return '$lastDragCoord';
    } else {
      return '';
    }
  }

  void buildRings(BuildContext context, List<DocumentSnapshot> documents) {
    if (ring3.length <= 8) {
      LayoutId currentLID;
      documents.forEach((doc) {
        noRing++;
        print(noRing);
        Planet p = Planet(
          document: doc,
          backgroundImg: planetImages[noRing%4],
        );
        switch (noRing % 4) {
          case 0:
            currentLID = LayoutId(
              id: 'BUTTON$noRing',
              child: p,
            );
            //if (!ring0.contains(currentLID)) ring0.add(currentLID);
            if (ring0
                .every((pT) => pT.document.documentID != p.document.documentID))
              ring0.add(p);
            print("Nickname : ${doc['nickname']}");
            break;
          case 1:
            currentLID = LayoutId(
              id: 'BUTTON$noRing',
              child: p,
            );
            //if (!ring1.contains(currentLID)) ring1.add(currentLID);
            if (ring1
                .every((pT) => pT.document.documentID != p.document.documentID))
              ring1.add(p);
            print("Nickname : ${doc['nickname']}");
            break;
          case 2:
            currentLID = LayoutId(
              id: 'BUTTON$noRing',
              child: p,
            );
            //if (!ring2.contains(currentLID)) ring2.add(currentLID);
            if (ring2
                .every((pT) => pT.document.documentID != p.document.documentID))
              ring2.add(p);
            print("Nickname : ${doc['nickname']}");
            break;
          case 3:
            currentLID = LayoutId(
              id: 'BUTTON$noRing',
              child: p,
            );
            //if (!ring3.contains(currentLID)) ring3.add(currentLID);
            if (ring3
                .every((pT) => pT.document.documentID != p.document.documentID))
              ring3.add(p);
            print("Nickname : ${doc['nickname']}");
            break;
          default:
        }
      });
    }
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
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        child: GestureDetector(
          onHorizontalDragStart: _onHDragStart,
          onHorizontalDragUpdate: _onHDragUpdate,
          onHorizontalDragEnd: _onHDragEnd,
          child: Stack(
            children: <Widget>[
              _tAnimator,
              // List
              Container(
                child: Transform.rotate(
                  angle: rotationValue,
                  origin: Offset(
                    0,
                    size.height/2,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: StreamBuilder(
                      stream:
                          Firestore.instance.collection('users').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                          );
                        } else {
                          buildRings(
                            context,
                            snapshot.data.documents,
                          );
                          print(
                              "0 : ${ring0.length}, 1 : ${ring1.length}, 2 : ${ring2.length}, 3 : ${ring3.length},");
                          return Stack(
                            children: <Widget>[
                              Positioned(
                                left: size.width / 2.4,
                                top: size.height /2.1,
                                child: RadialList(
                                  radialList: ring0,
                                  radius: 10.00,
                                ),
                              ),
                              Positioned(
                                left: size.width / 2.4,
                                top: size.height / 2.2,
                                child: Transform.rotate(
                                  angle: 0.2,
                                                                  child: RadialList(
                                    radialList: ring1,
                                    radius: 150.00,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: size.width / 2.4,
                                top: size.height / 2.2,
                                child: RadialList(
                                  radialList: ring2,
                                  radius: 250.00,
                                ),
                              ),
                            ],

                            // Container(
                            //   child: CircleListScrollView(
                            //     physics: ScrollPhysics(),
                            //     clipToSize: false,
                            //     axis: Axis.horizontal,
                            //     children: _radialListItems(),
                            //     itemExtent: 80,
                            //     radius: MediaQuery.of(context).size.width*0.3,
                            //   ),
                            // ),
                            // CustomMultiChildLayout(
                            //   delegate: _CircularLayoutDelegate(
                            //       itemCount: 8,
                            //       radius: 135.0,
                            //       sAngle:
                            //           -(random.nextDouble() * 20.0 + 110.0) *
                            //               _radiansPerDegree),
                            //   children: ring0,
                            // ),
                            // CustomMultiChildLayout(
                            //   delegate: _CircularLayoutDelegate(
                            //       itemCount: 8,
                            //       radius: 275.0,
                            //       sAngle:
                            //           -(random.nextDouble() * 20.0 + 110.0) *
                            //               _radiansPerDegree),
                            //   children: ring1,
                            // ),
                            // CustomMultiChildLayout(
                            //   delegate: _CircularLayoutDelegate(
                            //       itemCount: 8,
                            //       radius: 415.0,
                            //       sAngle:
                            //           -(random.nextDouble() * 20.0 + 110.0) *
                            //               _radiansPerDegree),
                            //   children: ring2,
                            // ),
                            // CustomMultiChildLayout(
                            //   delegate: _CircularLayoutDelegate(
                            //       itemCount: 8,
                            //       radius: 555.0,
                            //       sAngle:
                            //           -(random.nextDouble() * 20.0 + 110.0) *
                            //               _radiansPerDegree),
                            //   children: ring3,
                            // ),
                          );
                        }
                      },
                    ),
                  ),
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
        ),
        onWillPop: () => sl.get<DialogHelper>().onBackPress(context),
      ),
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
      print('actionButtonId $actionButtonId itemCount $itemCount');

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
