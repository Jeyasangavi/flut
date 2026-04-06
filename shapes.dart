import 'package:flutter/material.dart';

void main() {
  runApp(ShapeApp());
}

class ShapeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShapePage(),
    );
  }
}

// Model for each shape
class DrawnShape {
  Offset position;
  String type;

  DrawnShape(this.position, this.type);
}

class ShapePage extends StatefulWidget {
  @override
  _ShapePageState createState() => _ShapePageState();
}

class _ShapePageState extends State<ShapePage> {
  String selectedShape = "Circle";
  List<DrawnShape> shapes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shape Drawer"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Dropdown
          Padding(
            padding: EdgeInsets.all(10),
            child: DropdownButton<String>(
              value: selectedShape,
              items: ["Circle", "Rectangle", "Square", "Triangle"]
                  .map((shape) => DropdownMenuItem(
                        value: shape,
                        child: Text(shape),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedShape = value!;
                });
              },
            ),
          ),

          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              // TAP
              onTapDown: (details) {
                setState(() {
                  shapes.add(DrawnShape(
                      details.localPosition, selectedShape));
                });
              },

              // DRAG
              onPanUpdate: (details) {
                setState(() {
                  shapes.add(DrawnShape(
                      details.localPosition, selectedShape));
                });
              },

              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: CustomPaint(
                  painter: ShapePainter(shapes),
                ),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              setState(() {
                shapes.clear();
              });
            },
            child: Text("Clear"),
          ),
        ],
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final List<DrawnShape> shapes;

  ShapePainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (var shape in shapes) {
      Offset p = shape.position;

      switch (shape.type) {
        case "Circle":
          canvas.drawCircle(p, 20, paint);
          break;

        case "Rectangle":
          canvas.drawRect(
            Rect.fromCenter(center: p, width: 80, height: 40),
            paint,
          );
          break;

        case "Square":
          canvas.drawRect(
            Rect.fromCenter(center: p, width: 40, height: 40),
            paint,
          );
          break;

        case "Triangle":
          Path path = Path();
          path.moveTo(p.dx, p.dy - 20);
          path.lineTo(p.dx - 20, p.dy + 20);
          path.lineTo(p.dx + 20, p.dy + 20);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}