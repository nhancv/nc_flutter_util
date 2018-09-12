import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => new _DemoPageState();

  DemoPage() {
    timeDilation = 2.0;
  }
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new DemoBody(
        screenSize: MediaQuery.of(context).size,
      ),
    );
  }
}

class DemoBody extends StatefulWidget {
  final Size screenSize;

  DemoBody({Key key, @required this.screenSize}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DemoBodyState();
  }
}

class _DemoBodyState extends State<DemoBody> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      child: new CustomPaint(
        painter: _DemoPainter(new Size(
          widget.screenSize.width,
          widget.screenSize.height,
        )),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  final Size screenSize;
  Paint painter = new Paint()
    ..color = Colors.black;
  Paint painter2 = new Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.red;

  _DemoPainter(this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {

  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}

