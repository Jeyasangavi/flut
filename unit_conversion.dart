import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConverterPage(),
    );
  }
}

class ConverterPage extends StatefulWidget {
  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  TextEditingController valueController = TextEditingController();

  String category = "Length";

  String fromUnit = "Meter";
  String toUnit = "Kilometer";

  double result = 0;

  final Map<String, List<String>> units = {
    "Length": ["Meter", "Kilometer", "Centimeter"],
    "Weight": ["Kilogram", "Gram"]
  };

  void convert() {
    double value = double.tryParse(valueController.text) ?? 0;

    if (category == "Length") {
      if (fromUnit == "Meter" && toUnit == "Kilometer") {
        result = value / 1000;
      } else if (fromUnit == "Kilometer" && toUnit == "Meter") {
        result = value * 1000;
      } else if (fromUnit == "Meter" && toUnit == "Centimeter") {
        result = value * 100;
      } else if (fromUnit == "Centimeter" && toUnit == "Meter") {
        result = value / 100;
      } else {
        result = value;
      }
    } else if (category == "Weight") {
      if (fromUnit == "Kilogram" && toUnit == "Gram") {
        result = value * 1000;
      } else if (fromUnit == "Gram" && toUnit == "Kilogram") {
        result = value / 1000;
      } else {
        result = value;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unit Converter"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Category Dropdown
            DropdownButtonFormField(
              value: category,
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: units.keys.map((key) {
                return DropdownMenuItem(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                  fromUnit = units[category]![0];
                  toUnit = units[category]![1];
                });
              },
            ),

            SizedBox(height: 15),

            // Input value
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter value",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            // From unit
            DropdownButtonFormField(
              value: fromUnit,
              decoration: InputDecoration(
                labelText: "From",
                border: OutlineInputBorder(),
              ),
              items: units[category]!.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  fromUnit = value!;
                });
              },
            ),

            SizedBox(height: 15),

            // To unit
            DropdownButtonFormField(
              value: toUnit,
              decoration: InputDecoration(
                labelText: "To",
                border: OutlineInputBorder(),
              ),
              items: units[category]!.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  toUnit = value!;
                });
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: convert,
              child: Text("Convert"),
            ),

            SizedBox(height: 20),

            Text(
              "Result: ${result.toStringAsFixed(2)} $toUnit",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}