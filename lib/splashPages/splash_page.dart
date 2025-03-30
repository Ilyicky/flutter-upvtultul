//import 'package:demo_app/Assistants/assistant_methods.dart';
//import 'package:demo_app/global/global.dart';
//import 'package:location/location.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:convert';
import 'package:demo_app/constants/restaurants.dart';
import 'package:demo_app/helpers/directions_handler.dart';
import 'package:demo_app/main.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../helpers/shared_prefs.dart'; // Import your shared_prefs file
import '../pages/home_management.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    initializeLocationAndSave();
  }

  Future<void> initializeLocationAndSave() async {
    try {
      // Get user location using the function from shared_prefs
      Point userPoint = await getUserLocation();
      
      // Access the Position object directly
      Position coordinates = userPoint.coordinates;
      
      // Store the user location in sharedPreferences
      sharedPreferences.setDouble('latitude', coordinates.lat.toDouble());
      sharedPreferences.setDouble('longitude', coordinates.lng.toDouble());
      
      // Get and store the directions API response in sharedPreferences
      for (int i = 0; i < restaurants.length; i++) {
        Map modifiedResponse = await getDirectionsAPIResponse(coordinates, i);
        saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
      }

      // Navigate to home screen after a short delay
      Future.delayed(
        const Duration(seconds: 1),
        () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeManagement()),
          (route) => false
        )
      );
    } catch (e) {
      print("Error initializing location: $e");
      // Show error dialog or fallback navigation
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Location Error"),
          content: const Text("There was a problem getting your location. Please check your location settings and try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally navigate to home screen with default location
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeManagement()),
                  (route) => false
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Center(child: Image.asset('images/splash.png')),
    );
  }
}