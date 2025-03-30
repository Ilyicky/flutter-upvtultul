import 'dart:convert';
import 'package:demo_app/main.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart'; // Import the location package

// Function to get the user's current location
Future<Point> getUserLocation() async {
  Location location = Location();
  LocationData? currentLocation;

  // Check for location permission
  var permissionStatus = await Permission.location.status;
  if (permissionStatus.isGranted) {
    // Get the current location
    currentLocation = await location.getLocation();
    return Point(
      coordinates: Position(
        currentLocation.longitude ?? 10.640845, // Fallback to default if null
        currentLocation.latitude ?? 122.227672,  // Fallback to default if null
      ),
    );
  } else {
    // Request permission
    var requestStatus = await Permission.location.request();
    if (requestStatus.isGranted) {
      currentLocation = await location.getLocation();
      return Point(
        coordinates: Position(
          currentLocation.longitude ?? 10.640845,
          currentLocation.latitude ?? 122.227672,
        ),
      );
    } else {
      // Handle the case where permission is not granted
      return Point(
        coordinates: Position(
          10.640845, // Default longitude
          122.227672, // Default latitude
        ),
      );
    }
  }
}

// Function to get the point from shared preferences
Future<Point> getPointFromSharedPrefs() async {
  // You can call getUserLocation() here to get the user's location
  return await getUserLocation();
}

Map getDecodedResponseFromSharedPrefs(int index) {
  String key = 'restaurant--$index';
  Map response = json.decode(sharedPreferences.getString(key)!);
  return response;
}

num getDistanceFromSharedPrefs(int index) {
  num distance = getDecodedResponseFromSharedPrefs(index)['distance'];
  return distance;
}

num getDurationFromSharedPrefs(int index) {
  num duration = getDecodedResponseFromSharedPrefs(index)['duration'];
  return duration;
}

Map getGeometryFromSharedPrefs(int index) {
  Map geometry = getDecodedResponseFromSharedPrefs(index)['geometry'];
  return geometry;
}