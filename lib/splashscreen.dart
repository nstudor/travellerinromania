import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class splashScreen extends StatefulWidget {
  Function callback;
  splashScreen(this.callback);
  @override
  _splashScreen createState() => _splashScreen();
}

class _splashScreen extends State<splashScreen> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset('assets/logo.png', fit: BoxFit.fitWidth),
      ),
      Text("Loading...")
    ]));

    // child: FittedBox(
    //   child:
    // ),
    //   FittedBox(
    //     child:
    //
    // ]),
  }
}
