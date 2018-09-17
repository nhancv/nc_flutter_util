import 'dart:math';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();

  DemoPage() {
    timeDilation = 1.0;
  }
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DemoBody(
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
    return _DemoBodyState();
  }
}

class _DemoBodyState extends State<DemoBody> with TickerProviderStateMixin {
  AnimationController animationController;
  double cursorX;
  int direction = 1; //1 left-right, -1 right-left

  @override
  void initState() {
    super.initState();

    cursorX = widget.screenSize.width / 2;
    animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..addListener(() {
            if (cursorX >= widget.screenSize.width)
              direction = -1;
            else if (cursorX <= 0)
              direction = 1;

            cursorX += direction;
          })
          ..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) => CustomPaint(
              size: widget.screenSize,
              painter: _DemoPainter(widget.screenSize, cursorX),
            ),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  final Size screenSize;
  final double cursorX;
  final Paint painter = Paint()
    ..color = Colors.black
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  _DemoPainter(this.screenSize, this.cursorX);

  @override
  void paint(Canvas canvas, Size size) {
    Offset cursor = Offset(cursorX, size.height / 2);

    double r = 30.0;
    double h = 50.0;
    double left = 0.0;
    double right = size.width;
    double top = cursor.dy;
    double bottom = top + h;

    Path path = Path()
      ..moveTo(left, top)
      ..lineTo(cursor.dx - sqrt(3.0) * r, top)
      ..addArc(
          Rect.fromCircle(
              center: Offset(cursor.dx - sqrt(3.0) * r, cursor.dy - r), radius: r),
          1 / 6 * pi,
          1 / 3 * pi)
      ..addArc(Rect.fromCircle(center: cursor, radius: r), 7 / 6 * pi, 2 / 3 * pi)
      ..addArc(
          Rect.fromCircle(
              center: Offset(cursor.dx + sqrt(3.0) * r, cursor.dy - r), radius: r),
          3 / 6 * pi,
          1 / 3 * pi)
      ..moveTo(cursor.dx + sqrt(3.0) * r, top)
      ..lineTo(right, top)
      ..lineTo(right, bottom)
      ..lineTo(left, bottom)
      ..lineTo(left, top);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}
