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
    timeDilation = 2.0;
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
  Animation<double> animation;
  Animation<double> scale;
  Animation<double> borderWidth;
  Animation<BorderRadius> borderRadius;
  Animation<Color> color;

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animation = new Tween<double>(begin: -100.0, end: 20.0)
        .animate(animationController);
    scale =
        new Tween<double>(begin: 1.0, end: 0.5).animate(animationController);
    borderWidth =
        new Tween<double>(begin: 3.0, end: 0.0).animate(animationController);
    borderRadius = new BorderRadiusTween(
            begin: new BorderRadius.circular(0.0),
            end: new BorderRadius.circular(75.0))
        .animate(animationController);
    color = new ColorTween(begin: Colors.yellow, end: Colors.red)
        .animate(animationController);

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        animationController.forward();
      } else if (status == AnimationStatus.completed) {
        animationController.reverse();
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
        builder: (context, child) => new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.red,
                ),
                new Container(
                  width: 100.0,
                  height: 100.0,
                  transform: new Matrix4.identity()
                    ..translate(1.0, animation.value, 1.0)
                    ..scale(scale.value),
                  decoration: new BoxDecoration(
                    color: color.value,
                    border: new Border.all(
                      color: Colors.indigo[300],
                      width: borderWidth.value,
                    ),
                    borderRadius: borderRadius.value,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
