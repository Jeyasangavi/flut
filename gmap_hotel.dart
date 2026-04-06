/*

run in andriod studio
Guys this needs phone like setup in android emulator
ADD THIS IN pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.3
  geolocator: ^10.1.0
  intl: ^0.19.0
  geocoding: ^3.0.0

THEN RUN:
flutter pub get
(Run flutter pub get in your terminal after adding these).

You need to replace the contents of the file located exactly at 
android/app/src/main/AndroidManifest.xml with the code below.

<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
    <uses-permission android:name="android.permission.INTERNET"/>

    <application
        android:label="hotel_map_app"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <meta-data 
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
    
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>

*/

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:geocoding/geocoding.dart'; // Add this at the top

void main() {
  runApp(const HotelFinderApp());
}

class HotelFinderApp extends StatelessWidget {
  const HotelFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};

  // Search UI State
  final TextEditingController _locationController = TextEditingController();
  DateTimeRange? _selectedDateRange;
  String _selectedPreference = 'Any';
  final List<String> _preferences = ['Any', 'Budget', 'Luxury', 'Pool', 'Pet Friendly'];

  // Default location (San Francisco) if location services are denied
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  /// Gets the user's current location and asks for permissions
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  /// Prompts user to pick check-in and check-out dates
  Future<void> _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  /// Simulates fetching hotel data from an API based on location
  void _searchHotels() async {
      String query = _locationController.text;

      // 1. Validation: Ensure the user typed something
      if (query.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a location (e.g. Chennai)')),
        );
        return;
      }

      try {
        // 2. Geocoding: Turn "Chennai" into coordinates
        List<Location> locations = await locationFromAddress(query);

        if (locations.isNotEmpty) {
          var first = locations.first;
          LatLng newTarget = LatLng(first.latitude, first.longitude);

          // 3. Move the Camera to the new city
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: newTarget, zoom: 13),
            ),
          );

          // 4. Update the Map Markers
          setState(() {
            _markers.clear();
            final random = Random();
            for (int i = 0; i < 5; i++) {
              // Randomly scatter hotels near the center
              double latOffset = (random.nextDouble() - 0.5) * 0.04;
              double lngOffset = (random.nextDouble() - 0.5) * 0.04;

              LatLng hotelPos = LatLng(newTarget.latitude + latOffset, newTarget.longitude + lngOffset);

              _markers.add(
                Marker(
                  markerId: MarkerId('hotel_$i'),
                  position: hotelPos,
                  infoWindow: InfoWindow(
                    title: 'Hotel in $query ${i + 1}',
                    snippet: 'Preference: $_selectedPreference',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                ),
              );
            }
          });
        }
      } catch (e) {
        // Handles cases where the city name is not recognized
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not find "$query". Please try another city.')),
        );
      }

      // Hide keyboard after searching
      FocusScope.of(context).unfocus();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Google Map
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // Custom button provided below
            zoomControlsEnabled: false,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),

          // 2. Search Interface UI Overlay
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Location Input
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Where do you want to stay?',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Dates and Preferences Row
                    Row(
                      children: [
                        // Date Picker Button
                        Expanded(
                          flex: 3,
                          child: OutlinedButton.icon(
                            onPressed: _pickDateRange,
                            icon: const Icon(Icons.calendar_month, size: 18),
                            label: Text(
                              _selectedDateRange == null
                                  ? 'Dates'
                                  : '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Preferences Dropdown
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _selectedPreference,
                                items: _preferences.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value, style: const TextStyle(fontSize: 12)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedPreference = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Search Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _searchHotels,
                        child: const Text('Search Hotels'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // 3. Current Location Button
          Positioned(
            bottom: 30,
            right: 15,
            child: FloatingActionButton(
              onPressed: _determinePosition,
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
