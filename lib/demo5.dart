import 'dart:math';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math.dart' as Vector;
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
      body: new Stack(
        children: <Widget>[
          new DemoBody(
            screenSize: MediaQuery.of(context).size,
            offset: 0,
            color: Colors.black,
          ),
          new DemoBody(
              screenSize: MediaQuery.of(context).size,
              offset: 50,
              color: Colors.red),
        ],
      ),
    );
  }
}

class DemoBody extends StatefulWidget {
  final Size screenSize;
  final int offset;
  final Color color;

  DemoBody({Key key, @required this.screenSize, this.offset, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DemoBodyState();
  }
}

class _DemoBodyState extends State<DemoBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<double> waveList = [];
  List<Offset> animList1 = [];
  List<Offset> animList2 = [];
  int step = 0;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 360; i++) {
      waveList.add(sin(i * Vector.degrees2Radians) * 20 + 50);
    }

    for (int i = 0; i < 360 * 2; i++) {
      animList1.add(new Offset(i.toDouble(), waveList[(i) % 360]));
      animList2.add(new Offset(i.toDouble(), waveList[(i) % 360]));
    }

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animationController.addListener(() {
      step = (animationController.value * 720).toInt();
//      step ++ ;
//      print(step);

      for (int i = 0; i < 360 * 2; i++) {
        animList1[i] = new Offset(
            animList1[i].dx, waveList[(i + step) % 360]);

//        animList2[i] = new Offset(
//            animList2[i].dx,
//            waveList[
//                (i + widget.offset + (360 * animationController.value).toInt()) % 360]);
      }
//      if(step >= 720) step = 0;
    });

    animationController.repeat();
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
                  animationController.value, animList1, animList2),
              child: new ClipPath(
                child: new Container(
                  width: widget.screenSize.width,
                  height: 200.0,
                  color: widget.color,
                ),
                clipper: new WaveClipper(animationController.value, animList1),
              ),
            ),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  final Size screenSize;
  final double animation;
  Paint painter = new Paint()
    ..style = PaintingStyle.stroke
    ..color = Colors.black;
  List<Offset> waveList1 = [];
  List<Offset> waveList2 = [];

  _DemoPainter(this.screenSize, this.animation, this.waveList1, this.waveList2);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(ui.PointMode.polygon, waveList1, painter);
//    canvas.drawPoints(ui.PointMode.polygon, waveList2, painter);
  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

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

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
