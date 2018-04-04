import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => new _DemoPageState();
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
        title: new Text('Hello'),
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
  Size screenSize;

  @override
  void initState() {
    super.initState();
    screenSize = widget.screenSize;

    setUpAnimation();
  }

  @override
  void dispose() {
    if (animationController != null) animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DemoBody oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new CustomPaint(
        size: new Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
        painter: new _DemoPainter(),
      ),
    );
  }

  void setUpAnimation() {
    animationController = new AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );

    animationController
      ..addListener(() {
        setState(() {});
      });

    animationController.forward();
  }

  CurvedAnimation intervalCurved(begin, end, [curve = Curves.easeInOut]) {
    return new CurvedAnimation(
      parent: animationController,
      curve: new Interval(begin, end, curve: curve),
    );
  }
}

class _DemoPainter extends CustomPainter {
  Paint painter;

  _DemoPainter() {
    painter = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = new Path();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}
