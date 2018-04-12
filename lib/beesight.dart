import 'dart:math';
import 'dart:ui' as ui;
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
      body: new Container(
        margin: const EdgeInsets.all(50.0),
        child: new DemoBody(screenSize: MediaQuery.of(context).size),
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
  CharacterFactory characterFactory;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    characterFactory = new CharacterFactory();

    animationController.addListener(() {
      characterFactory.addPoint(animationController.value);
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        characterFactory.step++;
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        characterFactory.step++;
        animationController.forward();
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
              size: widget.screenSize,
              painter: new _DemoPainter(
                widget.screenSize,
                characterFactory.offsetPoints,
              ),
            ),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  final Size screenSize;
  final List<Offset> offsetPoints;
  Paint painter;

  _DemoPainter(this.screenSize, this.offsetPoints) {
    painter = new Paint()
      ..strokeWidth = 1.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(ui.PointMode.polygon, offsetPoints, painter);
    if (offsetPoints.length > 0) {
      canvas.drawCircle(offsetPoints[offsetPoints.length - 1], 10.0, painter);
    }
  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}

class CharacterFactory {
  List<Offset> offsetPoints = [];
  int step = 0;

  Offset getQuadraticBezier(List<Offset> offsetList, double t) {
    return getQuadraticBezier2(offsetList, t, 0, offsetList.length - 1);
  }

  Offset getQuadraticBezier2(List<Offset> offsetList, double t, int i, int j) {
    if (i == j) return offsetList[i];

    Offset b0 = getQuadraticBezier2(offsetList, t, i, j - 1);
    Offset b1 = getQuadraticBezier2(offsetList, t, i + 1, j);
    Offset res =
        new Offset((1 - t) * b0.dx + t * b1.dx, (1 - t) * b0.dy + t * b1.dy);
    return res;
  }

  void addPoint(double time) {
    if (step == 0) {
      offsetPoints.add(bCharStep1(time));
    } else if (step == 1) {
      offsetPoints.add(bCharStep2(time));
    } else {
      step = 0;
      offsetPoints.clear();
    }
  }

  Offset bCharStep1(double time) {
    return getQuadraticBezier([
      new Offset(0.0, 100.0),
      new Offset(0.0, 200.0),
    ], time);
  }

  Offset bCharStep2(double time) {
    return getQuadraticBezier([
      new Offset(0.0, 175.0),
      new Offset(35.0, 112.0),
      new Offset(100.0, 212.0),
      new Offset(0.0, 200.0),
    ], time);
  }
}
