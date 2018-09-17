import 'dart:math';
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
    timeDilation = 1.0;
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
        size: widget.screenSize,
        painter: _DemoPainter(widget.screenSize),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  final Size screenSize;
  Paint painter = new Paint()
    ..color = Colors.black
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  _DemoPainter(this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    Offset mid = size.center(Offset.zero);

    double r = 30.0;
    double h = 50.0;
    double left = 0.0;
    double right = size.width;
    double top = mid.dy;
    double bottom = top + h;

    //rect
    canvas.drawLine(
        Offset(left, top), Offset(mid.dx - sqrt(3.0) * r, top), painter);
    canvas.drawLine(
        Offset(mid.dx + sqrt(3.0) * r, top), new Offset(right, top), painter);
    canvas.drawLine(Offset(left, bottom), new Offset(right, bottom), painter);

    //center
    canvas.drawArc(Rect.fromCircle(center: mid, radius: r), 7 / 6 * pi,
        2 / 3 * pi, false, painter);
    //left circle
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(mid.dx - sqrt(3.0) * r, mid.dy - r), radius: r),
        1 / 6 * pi,
        1 / 3 * pi,
        false,
        painter);
    //right circle
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(mid.dx + sqrt(3.0) * r, mid.dy - r), radius: r),
        3 / 6 * pi,
        1 / 3 * pi,
        false,
        painter);

  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}
