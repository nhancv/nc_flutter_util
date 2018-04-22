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
  AnimationController animationController;
  List<Offset> pointList = [];
  List<Offset> pivotList = [];

  @override
  void initState() {
    super.initState();
    pivotList = [
      new Offset(
          widget.screenSize.width * 3 / 6, widget.screenSize.height * 1 / 6),
      new Offset(
          widget.screenSize.width * 5 / 6, widget.screenSize.height * 3 / 6),
      new Offset(
          widget.screenSize.width * 3 / 6, widget.screenSize.height * 5 / 6),
      new Offset(
          widget.screenSize.width * 1 / 6, widget.screenSize.height * 3 / 6),
      new Offset(
          widget.screenSize.width * 3 / 6, widget.screenSize.height * 1 / 6),
    ];

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 5));
    animationController.addListener(() {
      pointList.add(getQuadraticBezier(pivotList, animationController.value));
    });
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        new Timer(new Duration(seconds: 1), () {
          pointList.clear();
          animationController.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        new Timer(new Duration(seconds: 1), () {
          pointList.clear();
          animationController.forward();
        });
      }
    });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      child: new AnimatedBuilder(
        animation: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => new CustomPaint(
              size: new Size(
                widget.screenSize.width,
                widget.screenSize.height,
              ),
              foregroundPainter: new _DemoPainter(widget.screenSize,
                  animationController.value, pointList, pivotList),
            ),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  final Size screenSize;
  final double animation;
  final List<Offset> pointList;
  final List<Offset> pivotList;
  Paint painter = new Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black;
  Paint painter2 = new Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.red;

  _DemoPainter(this.screenSize, this.animation, this.pointList, this.pivotList);

  @override
  void paint(Canvas canvas, Size size) {
    getQuadraticBezier(pivotList, animation, canvas: canvas, paint: painter2);

    for (var o in pointList) {
      canvas.drawCircle(o, 1.0, painter);
    }
  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}

Offset getQuadraticBezier(List<Offset> offsetList, double t,
    {Canvas canvas, Paint paint}) {
  return getQuadraticBezier2(offsetList, t, 0, offsetList.length - 1,
      canvas: canvas, paint: paint);
}

Offset getQuadraticBezier2(List<Offset> offsetList, double t, int i, int j,
    {Canvas canvas, Paint paint}) {
  if (i == j) return offsetList[i];

  Offset b0 = getQuadraticBezier2(offsetList, t, i, j - 1,
      canvas: canvas, paint: paint);
  Offset b1 = getQuadraticBezier2(offsetList, t, i + 1, j,
      canvas: canvas, paint: paint);
  Offset res =
      new Offset((1 - t) * b0.dx + t * b1.dx, (1 - t) * b0.dy + t * b1.dy);
  if (canvas != null && paint != null) {
    canvas.drawLine(b1, b0, paint);
    canvas.drawCircle(res, 2.0, paint);
  }
  return res;
}
