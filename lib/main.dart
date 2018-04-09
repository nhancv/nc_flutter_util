import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
//import 'demo1.dart';
//import 'demo2.dart';
//import 'demo3.dart';
import 'gesture.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DemoPage(),
    );
  }
}
