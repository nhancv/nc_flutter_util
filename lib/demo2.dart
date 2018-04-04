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
    timeDilation = 4.0;
  }
}

class _DemoPageState extends State<DemoPage> {
  Random r = new Random();

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Demo Curves'),
      ),
      body: new DemoBody(
        screenSize: MediaQuery.of(context).size,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: update,
        child: new Icon(Icons.repeat),
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
  String curveStr;

  Size screenSize;

  @override
  void initState() {
    super.initState();
    screenSize = widget.screenSize;
    offsetList = new List<Offset>();
    setUpAnimation(Curves.easeInOut);
  }

  @override
  void dispose() {
    if (animationController != null) animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(30.0),
      child: new CustomPaint(
        size: new Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
        painter: new _DemoPainter(offsetList, curveStr),
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
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );

    animation = new Tween<double>(begin: 0.0, end: 300.0)
        .animate(intervalCurved(curve: curve));
    animationTime =
        new Tween<double>(begin: 0.0, end: 300.0).animate(animationController);

    animationController
      ..addListener(() {
        offsetList.add(new Offset(animation.value, animationTime.value));
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          offsetList.clear();
          animationController.forward();
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

  _DemoPainter(this.offsetList, this.curveName) {
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
    canvas.drawLine(new Offset(0.0, 0.0), new Offset(0.0, 320.0), axisPainter);
    canvas.drawLine(
        new Offset(-10.0, 310.0), new Offset(0.0, 320.0), axisPainter);
    canvas.drawLine(
        new Offset(0.0, 320.0), new Offset(10.0, 310.0), axisPainter);

    // Draw time axis
    canvas.drawLine(new Offset(0.0, 0.0), new Offset(320.0, 0.0), axisPainter);
    canvas.drawLine(
        new Offset(310.0, -10.0), new Offset(320.0, 0.0), axisPainter);
    canvas.drawLine(
        new Offset(320.0, 0.0), new Offset(310.0, 10.0), axisPainter);

    // Draw linear line
    canvas.drawLine(
        new Offset(0.0, 0.0), new Offset(300.0, 300.0), linearPainter);
    // Draw text
    drawText(canvas, new Offset(-20.0, -20.0), '0,0');
    drawText(canvas, new Offset(-20.0, 320.0), 'value');
    drawText(canvas, new Offset(320.0, -20.0), 'time');
    drawText(canvas, new Offset(150.0, 320.0), curveName);

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
            new TextSpan(style: new TextStyle (color: Colors.black), text: text),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, offset);
  }
}
