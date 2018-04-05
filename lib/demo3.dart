import 'dart:ui' as ui;
import 'dart:async';
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
    timeDilation = 4.0;
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
  List<Node> nodeList;
  Size screenSize;

  @override
  void initState() {
    super.initState();
    screenSize = widget.screenSize;
    nodeList = new List();
    for (int i = 0; i < 5; i++) {
      nodeList.add(new Node(screenSize: screenSize));
    }

    runSimulation();
  }

  void runSimulation() async {
    new Timer.periodic(new Duration(milliseconds: 10), (timer) {
      for (int i = 0; i < nodeList.length; i++) {
        nodeList[i].move();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return new Container(
      child: new CustomPaint(
        size: new Size(
          screenSize.width,
          screenSize.height,
        ),
        painter: new _DemoPainter(screenSize, nodeList),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  List<Node> nodeList;
  Size screenSize;
  Paint painter;

  _DemoPainter(this.screenSize, this.nodeList) {
    painter = new Paint()
      ..color = Colors.orange
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var node in nodeList) {
      node.display(canvas, painter);
    }
  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}

enum Direction {
  LEFT,
  RIGHT,
  TOP,
  BOTTOM,
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_RIGHT
}

class Node {
  Size screenSize;
  double radius;
  Offset position;
  double dx, dy;
  Direction direction;
  Random random;

  Node({this.radius = 5.0, @required this.screenSize}) {
    random = new Random();
    dx = screenSize.width / 2;
    dy = screenSize.height / 2;
    position = screenSize.center(Offset.zero);
    direction = Direction.values[random.nextInt(Direction.values.length)];
  }

  void move() {
    switch (direction) {
      case Direction.LEFT:
        position -= new Offset(1.0, 0.0);
        if (position.dx <= 5.0) {
          List<Direction> dirAvailableList = [
            Direction.RIGHT,
            Direction.BOTTOM_RIGHT,
            Direction.TOP_RIGHT
          ];
          direction = dirAvailableList[random.nextInt(dirAvailableList.length)];
        }

        break;
      case Direction.RIGHT:
        position += new Offset(1.0, 0.0);
        if (position.dx >= screenSize.width - 5.0) {
          List<Direction> dirAvailableList = [
            Direction.LEFT,
            Direction.BOTTOM_LEFT,
            Direction.TOP_LEFT
          ];
          direction = dirAvailableList[random.nextInt(dirAvailableList.length)];
        }
        break;
      case Direction.TOP:
        position -= new Offset(0.0, 1.0);
        if (position.dy <= 5.0) {
          List<Direction> dirAvailableList = [
            Direction.BOTTOM,
            Direction.BOTTOM_LEFT,
            Direction.BOTTOM_RIGHT
          ];
          direction = dirAvailableList[random.nextInt(dirAvailableList.length)];
        }
        break;
      case Direction.BOTTOM:
        position += new Offset(0.0, 1.0);
        if (position.dy >= screenSize.height - 5.0) {
          List<Direction> dirAvailableList = [
            Direction.TOP,
            Direction.TOP_LEFT,
            Direction.TOP_RIGHT,
          ];
          direction = dirAvailableList[random.nextInt(dirAvailableList.length)];
        }
        break;
      case Direction.TOP_LEFT:
        position -= new Offset(1.0, 1.0);
        if (position.dx <= 5.0 || position.dy <= 5.0) {
          List<Direction> dirAvailableList = [
            Direction.BOTTOM_RIGHT,
          ];

          //if y invalid and x valid
          if (position.dy <= 5.0 && position.dx > 5.0) {
            dirAvailableList.add(Direction.LEFT);
            dirAvailableList.add(Direction.RIGHT);
            dirAvailableList.add(Direction.BOTTOM);
            dirAvailableList.add(Direction.BOTTOM_LEFT);
          }
          //if x invalid and y valid
          if (position.dx <= 5.0 && position.dy > 5.0) {
            dirAvailableList.add(Direction.TOP);
            dirAvailableList.add(Direction.RIGHT);
            dirAvailableList.add(Direction.BOTTOM);
            dirAvailableList.add(Direction.TOP_RIGHT);
          }

          direction = dirAvailableList[random.nextInt(dirAvailableList.length)];
        }
        break;
      case Direction.TOP_RIGHT:
        position -= new Offset(-1.0, 1.0);
        if (position.dx >= screenSize.width - 5.0 || position.dy <= 5.0) {
          List<Direction> dirAvailableList = [
            Direction.BOTTOM_LEFT,
          ];

          //if y invalid and x valid
          if (position.dy <= 5.0 && position.dx < screenSize.width - 5.0) {
            dirAvailableList.add(Direction.LEFT);
            dirAvailableList.add(Direction.RIGHT);
            dirAvailableList.add(Direction.BOTTOM);
            dirAvailableList.add(Direction.BOTTOM_LEFT);
          }
          //if x invalid and y valid
          if (position.dx >= screenSize.width - 5.0 && position.dy > 5.0) {
            dirAvailableList.add(Direction.TOP);
            dirAvailableList.add(Direction.BOTTOM);
            dirAvailableList.add(Direction.LEFT);
            dirAvailableList.add(Direction.TOP_LEFT);
          }

          direction = dirAvailableList[random.nextInt(dirAvailableList.length)];
        }
        break;
      case Direction.BOTTOM_LEFT:
        position -= new Offset(1.0, -1.0);
        if (position.dx <= 5.0 || position.dy >= screenSize.height - 5.0) {
          List<Direction> dirAvailableList = [
            Direction.TOP_RIGHT,
          ];
          //if y invalid and x valid
          if (position.dy >= screenSize.height - 5.0 && position.dx > 5.0) {
            dirAvailableList.add(Direction.LEFT);
            dirAvailableList.add(Direction.RIGHT);
            dirAvailableList.add(Direction.TOP);
            dirAvailableList.add(Direction.TOP_LEFT);
          }
          //if x invalid and y valid
          if (position.dx <= 5.0 && position.dy < screenSize.height - 5.0) {
            dirAvailableList.add(Direction.TOP);
            dirAvailableList.add(Direction.BOTTOM);
            dirAvailableList.add(Direction.RIGHT);
            dirAvailableList.add(Direction.BOTTOM_RIGHT);
          }

          direction = dirAvailableList[random.nextInt(dirAvailableList.length)];
        }
        break;
      case Direction.BOTTOM_RIGHT:
        position += new Offset(1.0, 1.0);
        if (position.dx >= screenSize.width - 5.0 ||
            position.dy >= screenSize.height - 5.0) {
          List<Direction> dirAvailableList = [
            Direction.TOP_LEFT,
          ];
          //if y invalid and x valid
          if (position.dy >= screenSize.height - 5.0 &&
              position.dx < screenSize.width - 5.0) {
            dirAvailableList.add(Direction.LEFT);
            dirAvailableList.add(Direction.RIGHT);
            dirAvailableList.add(Direction.TOP);
            dirAvailableList.add(Direction.TOP_LEFT);
          }
          //if x invalid and y valid
          if (position.dx >= screenSize.width - 5.0 &&
              position.dy < screenSize.height - 5.0) {
            dirAvailableList.add(Direction.TOP);
            dirAvailableList.add(Direction.BOTTOM);
            dirAvailableList.add(Direction.LEFT);
            dirAvailableList.add(Direction.BOTTOM_LEFT);
          }

          direction = dirAvailableList[random.nextInt(dirAvailableList.length)];
        }
        break;
    }
  }

  void display(Canvas canvas, Paint paint) {
    canvas.drawCircle(position, radius, paint);
  }
}
