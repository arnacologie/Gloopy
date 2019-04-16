import 'package:flutter/material.dart';

class ChildLoginView extends StatefulWidget {
  @override
  _ChildLoginViewState createState() => _ChildLoginViewState();
}

class _ChildLoginViewState extends State<ChildLoginView> {
  final _formKey = GlobalKey<FormState>();

  List<String> images = [
    'images/characters/ponys/pony1.png',
    'images/characters/ponys/pony2.png',
    'images/characters/ponys/pony3.png',
    'images/characters/ponys/pony4.png',
    'images/characters/ponys/pony5.png',
    'images/characters/ponys/pony6.png',
    'images/characters/ponys/pony7.png',
    'images/characters/ponys/pony8.png',
    'images/characters/ponys/mylittlepony.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 55.0,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 35.0, vertical: 15.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Pseudo'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(), //manu le boss
                shrinkWrap: true,
                crossAxisCount: 3,
                children: images.map((path) {
                  return InkWell(
                    onTap: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("BAMM!!!!!"),
                          );
                        }),
                    child: Card(child: Image.asset(path)),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("BAMM!!!!!"),
                            );
                          });
                    }
                  },
                  child: Text('Bouton valider'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
