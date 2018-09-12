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
  final particleSystem = <Particle>[];

  @override
  void initState() {
    super.initState();

    //Generate particles
    new List.generate(100, (i) {
      particleSystem.add(new Particle(widget.screenSize));
    });

    animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 100))
      ..addListener(() {
        for (int i = 0; i < particleSystem.length; i++) {
          // Move particle
          particleSystem[i].move();

          // Restored particle
          if (particleSystem[i].remainingLife < 0 ||
              particleSystem[i].radius < 0) {
            particleSystem[i] = new Particle(widget.screenSize);
          }
        }
      })
      ..repeat();
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
      color: Colors.black,
      child: new AnimatedBuilder(
        animation: animationController,
        builder: (context, child) => new CustomPaint(
              size: widget.screenSize,
              painter: _DemoPainter(
                  new Size(
                    widget.screenSize.width,
                    widget.screenSize.height,
                  ),
                  particleSystem),
            ),
      ),
    );
  }
}

class _DemoPainter extends CustomPainter {
  final List<Particle> particleSystem;
  final Size screenSize;

  _DemoPainter(this.screenSize, this.particleSystem);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particleSystem) {
      particle.display(canvas);
    }
  }

  @override
  bool shouldRepaint(_DemoPainter oldDelegate) => true;
}

class Particle {
  Offset speed;
  Offset location;
  double radius;
  double life;
  double remainingLife;
  Color color;
  Size screenSize;
  double opacity;

  var palette = <Color>[];

  Particle(Size screenSize) {
    Random rd = new Random();

    this.screenSize = screenSize;
    this.speed =
        new Offset(-5 + rd.nextDouble() * 10, -15.0 + rd.nextDouble() * 10);
    this.location =
        new Offset(this.screenSize.width / 2, this.screenSize.height / 3 * 2);
    this.radius = 10 + rd.nextDouble() * 20;
    this.life = 20 + rd.nextDouble() * 10;
    this.remainingLife = this.life;

    for (int i = 30; i < 100; i++) {
      palette.add(HSLColor.fromAHSL(1.0, 0.0, 1.0, i / 100).toColor());
    }

    this.color = palette[0];
  }

  move() {
    this.remainingLife--;
    this.radius--;
    this.location = new Offset(
        this.location.dx + this.speed.dx, this.location.dy + this.speed.dy);
    int colorI = palette.length - (this.remainingLife / this.life * palette.length).round();
    if (colorI >= 0 && colorI < palette.length) {
      this.color = palette[colorI];
    }
  }

  display(Canvas canvas) {
    this.opacity = (this.remainingLife / this.life * 100).round() / 100;
    var gradient = new RadialGradient(
      colors: [
        Color.fromRGBO(
            this.color.red, this.color.green, this.color.blue, this.opacity),
        Color.fromRGBO(
            this.color.red, this.color.green, this.color.blue, this.opacity),
        Color.fromRGBO(this.color.red, this.color.green, this.color.blue, 0.0)
      ],
      stops: [0.0, 0.5, 1.0],
    );

    Paint painter = new Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(
          Rect.fromCircle(center: this.location, radius: this.radius));

    canvas.drawArc(Rect.fromCircle(center: this.location, radius: this.radius),
        0.0, 2 * pi, false, painter);
  }
}
