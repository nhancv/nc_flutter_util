import 'dart:async';
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
  Animation<double> animationTime;
  Animation<double> animation;
  List<Offset> offsetList;
  List<Curve> curveDemoList;
  String curveStr;
  Size screenSize;
  double axisArea = 300.0;

  int curveDemoIndex = 0;

  @override
  void initState() {
    super.initState();
    screenSize = widget.screenSize;
    offsetList = new List<Offset>();

    curveDemoList = [
      Curves.linear,
      Curves.decelerate,
      Curves.ease,
      Curves.easeIn,
      Curves.easeOut,
      Curves.easeInOut,
      Curves.fastOutSlowIn,
      Curves.bounceIn,
      Curves.bounceOut,
      Curves.bounceInOut,
      Curves.elasticIn,
      Curves.elasticOut,
      Curves.elasticInOut,
      const Cubic(0.25, 0.0, 0.0, 1.0)
    ];

    //CHANGE curve here to see effect
    setUpAnimation(curveDemoList[curveDemoIndex]);
  }

  @override
  void dispose() {
    if (animationController != null) animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      child: new CustomPaint(
        size: new Size(
          axisArea,
          axisArea,
        ),
        painter: new _DemoPainter(offsetList, curveStr, axisArea),
      ),
    );
  }

  void setUpAnimation(Curve curve) {
    if (curve == Curves.linear) {
      curveStr = 'linear';
    } else if (curve == Curves.decelerate) {
      curveStr = 'decelerate';
    } else if (curve == Curves.ease) {
      curveStr = 'ease';
    } else if (curve == Curves.easeIn) {
      curveStr = 'easeIn';
    } else if (curve == Curves.easeOut) {
      curveStr = 'easeOut';
    } else if (curve == Curves.easeInOut) {
      curveStr = 'easeInOut';
    } else if (curve == Curves.fastOutSlowIn) {
      curveStr = 'fastOutSlowIn';
    } else if (curve == Curves.bounceIn) {
      curveStr = 'bounceIn';
    } else if (curve == Curves.bounceOut) {
      curveStr = 'bounceOut';
    } else if (curve == Curves.bounceInOut) {
      curveStr = 'bounceInOut';
    } else if (curve == Curves.elasticIn) {
      curveStr = 'elasticIn';
    } else if (curve == Curves.elasticOut) {
      curveStr = 'elasticOut';
    } else if (curve == Curves.elasticInOut) {
      curveStr = 'elasticInOut';
    } else {
      curveStr = 'Custom';
    }

    animationController = new AnimationController(
      duration: new Duration(milliseconds: 2000),
      vsync: this,
    );

    animation = new Tween<double>(begin: 0.0, end: axisArea)
        .animate(intervalCurved(curve: curve));
    animationTime = new Tween<double>(begin: 0.0, end: axisArea)
        .animate(animationController);

    animationController
      ..addListener(() {
        offsetList.add(new Offset(animationTime.value, animation.value));
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          offsetList.clear();

          new Timer(new Duration(milliseconds: 200), () {
            curveDemoIndex = (curveDemoIndex + 1) % curveDemoList.length;
            setUpAnimation(curveDemoList[curveDemoIndex]);
          });
        } else if (status == AnimationStatus.completed) {
          offsetList.clear();
          animationController.reverse();
        }
      });

    animationController.forward();
  }

  CurvedAnimation intervalCurved(
      {begin = 0.0, end = 1.0, curve = Curves.linear}) {
    return new CurvedAnimation(
      parent: animationController,
      curve: new Interval(begin, end, curve: curve),
    );
  }
}

class _DemoPainter extends CustomPainter {
  Paint curvePainter;
  Paint axisPainter;
  Paint axisPointPainter;
  Paint linearPainter;
  List<Offset> offsetList;
  String curveName;
  double axisArea;

  _DemoPainter(this.offsetList, this.curveName, this.axisArea) {
    curvePainter = new Paint()
      ..color = Colors.orange
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    axisPointPainter = new Paint()
      ..color = Colors.orange
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    axisPainter = new Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    linearPainter = new Paint()
      ..color = Colors.red
      ..strokeWidth = 0.2
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw value axis
    canvas.drawLine(
        new Offset(0.0, 0.0), new Offset(0.0, axisArea + 20), axisPainter);
    canvas.drawLine(new Offset(-5.0, axisArea), new Offset(0.0, axisArea + 20),
        axisPainter);
    canvas.drawLine(
        new Offset(0.0, axisArea + 20), new Offset(5.0, axisArea), axisPainter);

    // Draw time axis
    canvas.drawLine(
        new Offset(0.0, 0.0), new Offset(axisArea + 20, 0.0), axisPainter);
    canvas.drawLine(new Offset(axisArea, -5.0), new Offset(axisArea + 20, 0.0),
        axisPainter);
    canvas.drawLine(
        new Offset(axisArea + 20, 0.0), new Offset(axisArea, 5.0), axisPainter);

    // Draw linear line
    canvas.drawLine(
        new Offset(0.0, 0.0), new Offset(axisArea, axisArea), linearPainter);
    // Draw text
    drawText(canvas, new Offset(-20.0, -20.0), '0,0');
    drawText(canvas, new Offset(-20.0, axisArea + 20), 'value');
    drawText(canvas, new Offset(axisArea + 20, -20.0), 'time');
    drawText(canvas, new Offset(axisArea / 2, axisArea + 20), curveName);

    // Draw points list
    canvas.drawPoints(ui.PointMode.polygon, offsetList, curvePainter);

    // Draw point in axis
    if (offsetList.length > 0) {
      Offset latestPoint = offsetList[offsetList.length - 1];
      canvas.drawCircle(new Offset(0.0, latestPoint.dy), 2.0, axisPointPainter);
      canvas.drawCircle(new Offset(latestPoint.dx, 0.0), 2.0, axisPointPainter);

      canvas.drawLine(
          new Offset(0.0, latestPoint.dy), latestPoint, linearPainter);
      canvas.drawLine(
          new Offset(latestPoint.dx, 0.0), latestPoint, linearPainter);
    }
  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;

  void drawText(Canvas canvas, Offset offset, String text) {
    TextPainter tp = new TextPainter(
        text:
            new TextSpan(style: new TextStyle(color: Colors.black), text: text),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, offset);
  }
}
