import 'dart:math';
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
      body: new DemoBody(screenSize: MediaQuery.of(context).size),
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

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
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
              painter: new _DemoPainter(widget.screenSize),
              child: new ClipPath(
                child: new Container(
                  width: widget.screenSize.width,
                  height: 200.0,
                  color: Colors.red,
                ),
                clipper: new WaveClipper(animationController.value),
              ),
            ),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  final Size screenSize;

  _DemoPainter(this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;
  double waveHeight = 70.0;
  double padding = 50.0;

  WaveClipper(this.animation);

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
    path.moveTo(0.0 - padding, waveHeight);

    Offset moving = getQuadraticBezier([
      new Offset(0.0 - padding, waveHeight),
      new Offset(size.width / 4, -waveHeight * 2),
      new Offset(size.width / 4 * 3, waveHeight * 4),
      new Offset(size.width +  padding, waveHeight),
    ], animation);
    path.quadraticBezierTo(moving.dx, moving.dy, size.width, waveHeight);

    path.lineTo(size.width + padding, size.height);
    path.lineTo(0.0 - padding, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
