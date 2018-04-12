import 'dart:math';
import 'dart:ui' as ui;
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
  bool drawChar = true;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));

    characterFactory = new CharacterFactory();

    animationController.addListener(() {
      if (drawChar) {
        characterFactory.addPoint(animationController.value);
      }
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (drawChar) {
          if (characterFactory.step != -1) {
            characterFactory.step++;
          } else {
            drawChar = false;
          }
          animationController.reset();
          animationController.forward();
        }
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
        builder: (context, child) => new Container(
              child: drawChar
                  ? new CustomPaint(
                      size: widget.screenSize,
                      painter: new _DemoPainter(widget.screenSize,
                          characterFactory.offsetPoint, characterFactory.path),
                    )
                  : new Container(
                      width: animationController.value * 200,
                      child: new Image.asset('images/icon.png'),
                    ),
            ),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  final Size screenSize;
  final Offset offsetPoint;
  final Path path;
  Paint painter;

  _DemoPainter(this.screenSize, this.offsetPoint, this.path) {
    painter = new Paint()
      ..strokeWidth = 1.0
      ..color = Colors.red
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path, painter);
    canvas.drawCircle(offsetPoint, 10.0, painter);

    canvas.drawLine(new Offset(0.0, 100.0), new Offset(550.0, 100.0), painter);
    canvas.drawLine(new Offset(0.0, 150.0), new Offset(550.0, 150.0), painter);
    canvas.drawLine(new Offset(0.0, 200.0), new Offset(550.0, 200.0), painter);
  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}

class CharacterFactory {
  Offset offsetPoint;
  Path path = new Path();
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
    bool finish = false;
    bChar(time, 0.0, 0);
    eChar(time, 50.0, 2);
    eChar(time, 100.0, 4);
    sChar(time, 150.0, 6);
    iChar(time, 185.0, 7);
    gChar(time, 230.0, 10);
    hChar(time, 290.0, 13);
    tChar(time, 330.0, 15);
    sChar(time, 380.0, 18);
    oChar(time, 430.0, 19);
    fChar(time, 480.0, 20);
    finish = tChar(time, 510.0, 22);

    if (finish) {
      step = -1;
    }
  }

  bool bChar(double time, [double xOffset = 0.0, int stepOffset = 0]) {
    if (step == stepOffset) {
      path.moveTo(0.0 + xOffset, 100.0);
      offsetPoint = getQuadraticBezier([
        new Offset(0.0 + xOffset, 100.0),
        new Offset(0.0 + xOffset, 200.0),
      ], time);
    } else if (step == stepOffset + 1) {
      path.moveTo(0.0 + xOffset, 175.0);
      offsetPoint = getQuadraticBezier([
        new Offset(0.0 + xOffset, 175.0),
        new Offset(35.0 + xOffset, 100.0),
        new Offset(80.0 + xOffset, 212.0),
        new Offset(0.0 + xOffset, 200.0),
      ], time);
    } else if (step > stepOffset + 1) {
      return true;
    }
    path.addRect(new Rect.fromCircle(center: offsetPoint, radius: 2.0));
    return false;
  }

  bool eChar(double time, [double xOffset = 0.0, int stepOffset = 0]) {
    if (step == stepOffset) {
      path.moveTo(0.0 + xOffset, 185.0);
      offsetPoint = getQuadraticBezier([
        new Offset(0.0 + xOffset, 185.0),
        new Offset(60.0 + xOffset, 165.0),
        new Offset(45.0 + xOffset, 150.0),
        new Offset(25.0 + xOffset, 150.0),
      ], time);
    } else if (step == stepOffset + 1) {
      path.moveTo(25.0 + xOffset, 150.0);
      offsetPoint = getQuadraticBezier([
        new Offset(25.0 + xOffset, 150.0),
        new Offset(0.0 + xOffset, 155.0),
        new Offset(-5.0 + xOffset, 200.0),
        new Offset(5.0 + xOffset, 215.0),
        new Offset(40.0 + xOffset, 185.0),
      ], time);
    } else if (step > stepOffset + 1) {
      return true;
    }
    path.addRect(new Rect.fromCircle(center: offsetPoint, radius: 2.0));
    return false;
  }

  bool sChar(double time, [double xOffset = 0.0, int stepOffset = 0]) {
    if (step == stepOffset) {
      path.moveTo(40.0 + xOffset, 165.0);
      offsetPoint = getQuadraticBezier([
        new Offset(40.0 + xOffset, 165.0),
        new Offset(40.0 + xOffset, 135.0),
        new Offset(0.0 + xOffset, 150.0),
        new Offset(-20.0 + xOffset, 155.0),
        new Offset(-20.0 + xOffset, 175.0),
        new Offset(100.0 + xOffset, 180.0),
        new Offset(50.0 + xOffset, 185.0),
        new Offset(50.0 + xOffset, 215.0),
        new Offset(25.0 + xOffset, 205.0),
        new Offset(15.0 + xOffset, 200.0),
        new Offset(0.0 + xOffset, 185.0),
      ], time);
    } else if (step > stepOffset) {
      return true;
    }
    path.addRect(new Rect.fromCircle(center: offsetPoint, radius: 2.0));
    return false;
  }

  bool iChar(double time, [double xOffset = 0.0, int stepOffset = 0]) {
    if (step == stepOffset) {
      path.moveTo(20.0 + xOffset, 150.0);
      offsetPoint = getQuadraticBezier([
        new Offset(20.0 + xOffset, 150.0),
        new Offset(20.0 + xOffset, 195.0),
      ], time);
    } else if (step == stepOffset + 1) {
      path.moveTo(20.0 + xOffset, 195.0);
      offsetPoint = getQuadraticBezier([
        new Offset(20.0 + xOffset, 195.0),
        new Offset(25.0 + xOffset, 205.0),
        new Offset(35.0 + xOffset, 195.0),
      ], time);
    } else if (step == stepOffset + 2) {
      path.moveTo(20.0 + xOffset, 135.0);
      offsetPoint = getQuadraticBezier([
        new Offset(20.0 + xOffset, 135.0),
        new Offset(20.0 + xOffset, 140.0),
      ], time);
    } else if (step > stepOffset + 2) {
      return true;
    }
    path.addRect(new Rect.fromCircle(center: offsetPoint, radius: 2.0));
    return false;
  }

  bool gChar(double time, [double xOffset = 0.0, int stepOffset = 0]) {
    if (step == stepOffset) {
      path.moveTo(40.0 + xOffset, 150.0);
      offsetPoint = getQuadraticBezier([
        new Offset(40.0 + xOffset, 150.0),
        new Offset(-5.0 + xOffset, 150.0),
        new Offset(0.0 + xOffset, 200.0),
        new Offset(0.0 + xOffset, 215.0),
        new Offset(20.0 + xOffset, 200.0),
        new Offset(40.0 + xOffset, 180.0),
      ], time);
    } else if (step == stepOffset + 1) {
      path.moveTo(40.0 + xOffset, 150.0);
      offsetPoint = getQuadraticBezier([
        new Offset(40.0 + xOffset, 150.0),
        new Offset(40.0 + xOffset, 240.0),
      ], time);
    } else if (step == stepOffset + 2) {
      path.moveTo(40.0 + xOffset, 240.0);
      offsetPoint = getQuadraticBezier([
        new Offset(40.0 + xOffset, 240.0),
        new Offset(35.0 + xOffset, 285.0),
        new Offset(10.0 + xOffset, 285.0),
        new Offset(-15.0 + xOffset, 250.0),
        new Offset(45.0 + xOffset, 215.0),
      ], time);
    } else if (step > stepOffset + 2) {
      return true;
    }
    path.addRect(new Rect.fromCircle(center: offsetPoint, radius: 2.0));
    return false;
  }

  bool hChar(double time, [double xOffset = 0.0, int stepOffset = 0]) {
    if (step == stepOffset) {
      path.moveTo(0.0 + xOffset, 100.0);
      offsetPoint = getQuadraticBezier([
        new Offset(0.0 + xOffset, 100.0),
        new Offset(0.0 + xOffset, 200.0),
      ], time);
    } else if (step == stepOffset + 1) {
      path.moveTo(0.0 + xOffset, 175.0);
      offsetPoint = getQuadraticBezier([
        new Offset(0.0 + xOffset, 175.0),
        new Offset(45.0 + xOffset, 120.0),
        new Offset(45.0 + xOffset, 200.0),
      ], time);
    } else if (step > stepOffset + 1) {
      return true;
    }
    path.addRect(new Rect.fromCircle(center: offsetPoint, radius: 2.0));
    return false;
  }

  bool tChar(double time, [double xOffset = 0.0, int stepOffset = 0]) {
    if (step == stepOffset) {
      path.moveTo(25.0 + xOffset, 100.0);
      offsetPoint = getQuadraticBezier([
        new Offset(25.0 + xOffset, 100.0),
        new Offset(25.0 + xOffset, 195.0),
      ], time);
    } else if (step == stepOffset + 1) {
      path.moveTo(25.0 + xOffset, 195.0);
      offsetPoint = getQuadraticBezier([
        new Offset(25.0 + xOffset, 195.0),
        new Offset(30.0 + xOffset, 205.0),
        new Offset(45.0 + xOffset, 200.0),
      ], time);
    } else if (step == stepOffset + 2) {
      path.moveTo(10.0 + xOffset, 145.0);
      offsetPoint = getQuadraticBezier([
        new Offset(10.0 + xOffset, 145.0),
        new Offset(25.0 + xOffset, 150.0),
        new Offset(45.0 + xOffset, 145.0),
      ], time);
    } else if (step > stepOffset + 2) {
      return true;
    }
    path.addRect(new Rect.fromCircle(center: offsetPoint, radius: 2.0));
    return false;
  }

  bool oChar(double time, [double xOffset = 0.0, int stepOffset = 0]) {
    if (step == stepOffset) {
      path.moveTo(25.0 + xOffset, 150.0);
      offsetPoint = getQuadraticBezier([
        new Offset(25.0 + xOffset, 150.0),
        new Offset(-5.0 + xOffset, 175.0),
        new Offset(-5.0 + xOffset, 200.0),
        new Offset(25.0 + xOffset, 235.0),
        new Offset(65.0 + xOffset, 175.0),
        new Offset(65.0 + xOffset, 150.0),
        new Offset(25.0 + xOffset, 150.0),
      ], time);
    } else if (step > stepOffset) {
      return true;
    }
    path.addRect(new Rect.fromCircle(center: offsetPoint, radius: 2.0));
    return false;
  }

  bool fChar(double time, [double xOffset = 0.0, int stepOffset = 0]) {
    if (step == stepOffset) {
      path.moveTo(40.0 + xOffset, 100.0);
      offsetPoint = getQuadraticBezier([
        new Offset(40.0 + xOffset, 100.0),
        new Offset(-15.0 + xOffset, 100.0),
        new Offset(50.0 + xOffset, 200.0),
        new Offset(0.0 + xOffset, 200.0),
      ], time);
    } else if (step == stepOffset + 1) {
      path.moveTo(0.0 + xOffset, 140.0);
      offsetPoint = getQuadraticBezier([
        new Offset(0.0 + xOffset, 140.0),
        new Offset(30.0 + xOffset, 125.0),
      ], time);
    } else if (step > stepOffset + 1) {
      return true;
    }
    path.addRect(new Rect.fromCircle(center: offsetPoint, radius: 2.0));
    return false;
  }
}
