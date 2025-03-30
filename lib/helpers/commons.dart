import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../constants/restaurants.dart';

Point getPointFromRestaurantData(int index) {
  return Point(
    coordinates: Position(
      double.parse(restaurants[index]['coordinates']['longitude']),
      double.parse(restaurants[index]['coordinates']['latitude'])
    )
  );
}