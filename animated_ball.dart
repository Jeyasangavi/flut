import 'package:flutter/material.dart';

void main() {
  runApp(BallApp());
}

class BallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BallPage(),
    );
  }
}

class BallPage extends StatefulWidget {
  @override
  _BallPageState createState() => _BallPageState();
}

class _BallPageState extends State<BallPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> positionAnimation;
  late Animation<double> scaleAnimation;

  bool isAnimating = false;
  double speed = 1.0;
  Color ballColor = Colors.blue;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    positionAnimation =
        Tween<double>(begin: 0, end: 200).animate(controller);

    scaleAnimation =
        Tween<double>(begin: 0.8, end: 1.5).animate(controller);

    controller.addListener(() {
      setState(() {});
    });

    controller.repeat(reverse: true);
    controller.stop();
  }

  void toggleAnimation() {
    setState(() {
      if (isAnimating) {
        controller.stop();
      } else {
        controller.repeat(reverse: true);
      }
      isAnimating = !isAnimating;
    });
  }

  void changeSpeed(double value) {
    setState(() {
      speed = value;
      controller.duration =
          Duration(milliseconds: (2000 / speed).toInt());
      if (isAnimating) {
        controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Ball"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 40),

          // ANIMATION AREA
          Expanded(
            child: Center(
              child: Transform.translate(
                offset: Offset(positionAnimation.value, 0),
                child: Transform.scale(
                  scale: scaleAnimation.value,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: ballColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // START / STOP BUTTON
          ElevatedButton(
            onPressed: toggleAnimation,
            child: Text(isAnimating ? "Stop" : "Start"),
          ),

          SizedBox(height: 10),

          // SPEED SLIDER
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text("Speed"),
                Slider(
                  value: speed,
                  min: 0.5,
                  max: 3,
                  divisions: 5,
                  label: speed.toStringAsFixed(1),
                  onChanged: changeSpeed,
                ),
              ],
            ),
          ),

          // COLOR DROPDOWN
          DropdownButton<Color>(
            value: ballColor,
            items: [
              DropdownMenuItem(
                  value: Colors.blue, child: Text("Blue")),
              DropdownMenuItem(
                  value: Colors.red, child: Text("Red")),
              DropdownMenuItem(
                  value: Colors.green, child: Text("Green")),
              DropdownMenuItem(
                  value: Colors.orange, child: Text("Orange")),
            ],
            onChanged: (value) {
              setState(() {
                ballColor = value!;
              });
            },
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}