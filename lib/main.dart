import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
//import 'demo1.dart';
import 'demo2.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new DemoPage(),
    );
  }
}
