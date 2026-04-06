/*
ADD THIS IN pubspec.yaml (DEPENDENCIES SECTION ONLY):

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  url_launcher: ^6.2.5

THEN RUN:
flutter pub get

THEN RUN flutter run
*/

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MapApp());
}

class MapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapHomePage(),
    );
  }
}

class MapHomePage extends StatefulWidget {
  @override
  _MapHomePageState createState() => _MapHomePageState();
}

class _MapHomePageState extends State<MapHomePage> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  Future<void> openGoogleMaps() async {
    String pickup = pickupController.text;
    String destination = destinationController.text;

    if (pickup.isEmpty || destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both locations")),
      );
      return;
    }

    String url =
        "https://www.google.com/maps/dir/?api=1&origin=$pickup&destination=$destination&travelmode=driving";

    Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Could not open Google Maps";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Maps Direction"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: pickupController,
              decoration: InputDecoration(
                labelText: "Pickup Location",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                labelText: "Destination Location",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: openGoogleMaps,
              child: Text("Get Directions"),
            ),
          ],
        ),
      ),
    );
  }
}