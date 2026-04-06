import 'package:flutter/material.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  String selectedWeather = "Sunny";

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget weatherAnimation() {
    switch (selectedWeather) {
      case "Sunny":
        return RotationTransition(
          turns: controller,
          child: Icon(Icons.wb_sunny, size: 120),
        );

      case "Cloudy":
        return FadeTransition(
          opacity: controller.drive(
              Tween(begin: 0.3, end: 1.0)),
          child: Icon(Icons.cloud, size: 120),
        );

      case "Rainy":
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud, size: 80),
                SizedBox(height: 10),
                Container(
                  height: 50,
                  width: 50,
                  child: CustomPaint(
                    painter: RainPainter(controller.value),
                  ),
                )
              ],
            );
          },
        );

      case "Snowy":
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Icon(
              Icons.ac_unit,
              size: 120,
            );
          },
        );

      default:
        return Container();
    }
  }

  Widget button(String weather) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedWeather = weather;
        });
      },
      child: Text(weather),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Animation"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              button("Sunny"),
              button("Cloudy"),
              button("Rainy"),
              button("Snowy"),
            ],
          ),

          Expanded(
            child: Center(
              child: weatherAnimation(),
            ),
          ),
        ],
      ),
    );
  }
}

// RAIN ANIMATION
class RainPainter extends CustomPainter {
  final double value;

  RainPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..strokeWidth = 2;

    for (int i = 0; i < 10; i++) {
      double x = (i * 5) % size.width;
      double y = (value * size.height + i * 10) % size.height;

      canvas.drawLine(
        Offset(x, y),
        Offset(x, y + 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}