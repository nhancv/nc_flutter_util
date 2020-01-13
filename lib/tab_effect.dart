import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => new _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int fromTabIndex = 0;
  int toTabIndex = 0;
  Random r = new Random();

  void update() {
    setState(() {
      fromTabIndex = toTabIndex;
      toTabIndex = (r.nextInt(4) + fromTabIndex) % 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Hello'),
      ),
      body: new TabIndicator(
        screenSize: MediaQuery.of(context).size,
        fromIndex: fromTabIndex,
        toIndex: toTabIndex,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: update,
        child: new Icon(Icons.repeat),
      ),
    );
  }
}

class TabIndicator extends StatefulWidget {
  final Size screenSize;
  final int fromIndex;
  final int toIndex;

  TabIndicator(
      {Key key, @required this.screenSize, this.fromIndex, this.toIndex})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _TabIndicatorState();
  }
}

class _TabIndicatorState extends State<TabIndicator>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> dxTargetAnim;
  Animation<double> dxEntryAnim;

  Size screenSize;
  double iconSize;
  double height;
  double section;
  double horizontalPadding;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    iconSize = 47.0;
    height = 70.0;
    screenSize = widget.screenSize;
    section = screenSize.width / 8;
    horizontalPadding = section - iconSize / 2;

    setUpAnimation(widget.fromIndex, widget.toIndex);
  }

  @override
  void dispose() {
    if (animationController != null) animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TabIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fromIndex != widget.fromIndex ||
        oldWidget.toIndex != widget.toIndex) {
      setUpAnimation(widget.fromIndex, widget.toIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: const Color(0xffee613a),
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: new CustomPaint(
            size: new Size(
              MediaQuery.of(context).size.width * 2,
              MediaQuery.of(context).size.height,
            ),
            painter: new _TabIndicationPainter(
              dxTarget: dxTargetAnim.value,
              dxEntry: dxEntryAnim.value,
              dy: height / 2,
              radius: iconSize / 2,
            ),
            child: indicatorIcon(),
          ),
        ));
  }

  void setUpAnimation(int fromIndex, int toIndex) {
    animationController = new AnimationController(
      duration: new Duration(milliseconds: 700),
      vsync: this,
    );

    dxTargetAnim = new Tween<double>(
            begin: section * (fromIndex * 2 + 1),
            end: section * (toIndex * 2 + 1))
        .animate(intervalCurved(begin: 0.0, end: 1.0));
    dxEntryAnim = new Tween<double>(
            begin: section * (fromIndex * 2 + 1),
            end: section * (toIndex * 2 + 1))
        .animate(intervalCurved(begin: 0.5, end: 1.0));

    animationController
      ..addListener(() {
        setState(() {});
      });

    if (fromIndex != toIndex) {
      animationController.forward();
    }

    if(scrollController != null) {
      scrollController.animateTo(section * (toIndex * 2 + 1) - 100, duration: Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  CurvedAnimation intervalCurved(
      {begin = 0.0, end = 1.0, curve = Curves.easeInOut}) {
    return new CurvedAnimation(
      parent: animationController,
      curve: new Interval(begin, end, curve: curve),
    );
  }

  Widget indicatorIcon() {
    return new Container(
      width: screenSize.width * 2,
      height: height,
      padding: new EdgeInsets.symmetric(
        vertical: height / 2 - iconSize / 2,
      ),
      child: new Stack(
        children: <Widget>[
          getIcon(0),
          getIcon(1),
          getIcon(2),
          getIcon(3),
        ],
      ),
    );
  }

  Widget getIcon(index) {
    return new Positioned(
      left: section * (index * 2 + 1) - iconSize / 2,
      child: new Container(
        width: 47.0,
        height: 47.0,
        alignment: Alignment.center,
        child: new Text('x'),
      ),
    );
  }
}

class _TabIndicationPainter extends CustomPainter {
  Paint painter;
  final double dxTarget;
  final double dxEntry;
  final double radius;
  final double dy;

  _TabIndicationPainter(
      {this.dxTarget = 200.0,
      this.dxEntry = 50.0,
      this.radius = 25.0,
      this.dy = 25.0}) {
    painter = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    bool left2right = dxEntry < dxTarget;
    Offset entry = new Offset(left2right ? dxEntry : dxTarget, dy);
    Offset target = new Offset(left2right ? dxTarget : dxEntry, dy);

    Path path = new Path();
    path.addArc(
        new Rect.fromCircle(center: entry, radius: radius), 0.5 * pi, 1 * pi);
    path.addRect(
        new Rect.fromLTRB(entry.dx, dy - radius, target.dx, dy + radius));
    path.addArc(
        new Rect.fromCircle(center: target, radius: radius), 1.5 * pi, 1 * pi);
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(_TabIndicationPainter oldDelegate) => true;
}
