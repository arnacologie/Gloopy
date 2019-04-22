import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/views/chat_view.dart';

class Planet extends StatefulWidget {
  final DocumentSnapshot document;
  final String backgroundImg;

  @override
  _PlanetState createState() => _PlanetState();
  const Planet({
    @required this.document,
    @required this.backgroundImg,
  });
}

class _PlanetState extends State<Planet> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
            context,
            FadeNavRoute(
                builder: (context) => ChatView(
                      peerId: widget.document.documentID,
                      peerAvatar: widget.document['photo_url'],
                    )));
      },
      child: Container(
        width: 100,
        height: 150,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              widget.backgroundImg,
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
                imageUrl: widget.document['photo_url'],
                width: 60.0,
                height: 60.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
              clipBehavior: Clip.hardEdge,
            ),
            Positioned(
              bottom: 0,
              child: Text(widget.document['nickname']),
            )
          ],
        ),
      ),
    );
  }
}
