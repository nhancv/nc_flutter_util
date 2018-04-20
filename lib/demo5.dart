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
            xOffset: 0,
            yOffset: 0,
          ),
          new DemoBody(
            screenSize: MediaQuery.of(context).size,
            xOffset: 50,
            yOffset: 10,
          ),
        ],
      ),
    );
  }
}

class DemoBody extends StatefulWidget {
  final Size screenSize;
  final int xOffset;
  final int yOffset;

  DemoBody({Key key, @required this.screenSize, this.xOffset, this.yOffset})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DemoBodyState();
  }
}

class _DemoBodyState extends State<DemoBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
          i <= widget.screenSize.width.toInt() + 2;
          i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) %
                        360 *
                        Vector.degrees2Radians) *
                    20 +
                50 + widget.yOffset));
      }
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
              foregroundPainter: new _DemoPainter(
                  widget.screenSize, animationController.value, animList1),
              child: new ClipPath(
                child: Image.asset('images/demo5bg.jpg'),
//                new Container(
//                  width: widget.screenSize.width,
//                  height: 200.0,
//                  color: Colors.red,
//                ),
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

  _DemoPainter(this.screenSize, this.animation, this.waveList1);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPoints(ui.PointMode.polygon, waveList1, painter);
  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

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
