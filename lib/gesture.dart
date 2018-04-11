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
  Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.screenSize.center(Offset.zero);
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
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
        builder: (context, child) => new GestureDetector(
              onPanStart: onPanStart,
              onPanEnd: onPanEnd,
              onPanUpdate: onPanUpdate,
              child: new CustomPaint(
                size: widget.screenSize,
                painter: new _DemoPainter(widget.screenSize, position),
              ),
            ),
      ),
    );
  }

  void onPanStart(DragStartDetails details) {
    print('onPanStart: $details');
    setState(() {
      position = details.globalPosition;
    });
  }

  void onPanEnd(DragEndDetails details) {
    print('onPanEnd: $details');
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      position = details.globalPosition;
    });
  }
}

class _DemoPainter extends CustomPainter {
  final Size screenSize;
  final Offset position;
  Paint painter;

  _DemoPainter(this.screenSize, this.position) {
    painter = new Paint()
      ..strokeWidth = 1.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {

  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;

}
