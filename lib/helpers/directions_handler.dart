import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../main.dart';
import '../constants/restaurants.dart';
import '../requests/mapbox_requests.dart';

Future<Map> getDirectionsAPIResponse(Position currentPosition, int index) async {
  final response = await getCyclingRouteUsingMapbox(
      currentPosition,
      Position(
        double.parse(restaurants[index]['coordinates']['longitude']),
        double.parse(restaurants[index]['coordinates']['latitude'])
      ));
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  print('-------------------${restaurants[index]['name']}-------------------');
  print(distance);
  print(duration);

  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
  };
  return modifiedResponse;
}

void saveDirectionsAPIResponse(int index, String response) {
  sharedPreferences.setString('restaurant--$index', response);
}