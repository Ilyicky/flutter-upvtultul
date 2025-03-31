import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_app/constants/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../helpers/shared_prefs.dart';
import '../widgets/carousel_card.dart';

class RestaurantsMap extends StatefulWidget {
  const RestaurantsMap({super.key});

  @override
  State<RestaurantsMap> createState() => _RestaurantsMapState();
}

class _RestaurantsMapState extends State<RestaurantsMap> {
  // Mapbox related
  MapboxMap? mapboxMap;
  Point? point;
  CameraOptions? _initialCameraOptions;
  late MapOptions _mapOptions;
  List<Map> carouselData = [];

  int pageIndex = 0;
  late List<Widget> carouselItems;

  @override
  void initState() {
    super.initState();

    for (int index = 0; index < restaurants.length; index++) {
      num distance = getDistanceFromSharedPrefs(index) / 1000;
      num duration = getDurationFromSharedPrefs(index) / 60;
      carouselData.add({
        'index': index,
        'distance': distance,
        'duration': duration
      });
    }
    carouselData.sort((a, b) => a['duration'] < b['duration'] ? 0 : 1);

    //Generate the list of carousel widgets
    carouselItems = List<Widget>.generate(
        restaurants.length,
            (index) => carouselCard(
            carouselData[index]['index'],
            carouselData[index]['distance'],
            carouselData[index]['duration']));

    _mapOptions = MapOptions(
      constrainMode: ConstrainMode.HEIGHT_ONLY,
      pixelRatio: 1.0,
    );

    // Initialize point and camera options asynchronously
    _initializeMapData();

    // Check location permissions
    _checkLocationPermission();
  }

  Future<void> _initializeMapData() async {
    try {
      final userPoint = await getPointFromSharedPrefs();
      setState(() {
        point = userPoint;
        _initialCameraOptions = CameraOptions(
          center: userPoint,
          zoom: 18,
        );
      });
    } catch (e) {
      print("Error initializing map data: $e");
      // Set default camera options if there's an error
      setState(() {
        _initialCameraOptions = CameraOptions(
          center: Point(
            coordinates: Position(
              0.0, 0.0, // Default coordinates
            ),
          ),
          zoom: 18,
        );
      });
    }
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      // Permission is granted, you can activate the Maps SDK's LocationComponent
      if (mapboxMap != null) {
        _enableLocationComponent();
      }
    } else if (status.isDenied) {
      // Request permission
      await Permission.location.request();
      // Check the status again after requesting
      if (await Permission.location.status.isGranted) {
        if (mapboxMap != null) {
          _enableLocationComponent();
        }
      } else {
        // Optionally, show a message to the user explaining why the permission is needed
        _showPermissionDeniedDialog();
      }
    } else if (status.isPermanentlyDenied) {
      // The user has permanently denied the permission, show a dialog to direct them to settings
      _showPermissionSettingsDialog();
    }
  }

  void _enableLocationComponent() {
    mapboxMap?.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingMaxRadius: 30.0,
        showAccuracyRing: true,
        puckBearingEnabled: true,
        locationPuck: LocationPuck(
          locationPuck2D: DefaultLocationPuck2D(),
        ),
      ),
    );
  }

  _addSourceAndLineLayer(int index, bool removeLayer) async {
    // Implementation needed
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _checkLocationPermission();
  }

  _onStyleLoadedListener() async {
    // Implementation needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants Map'),
      ),
      body:SafeArea(
        child:Stack(
          children:[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: 
              _initialCameraOptions == null ? const Center(child: CircularProgressIndicator()):
              MapWidget(
                key: const ValueKey("mapWidget"),
                onMapCreated: _onMapCreated,
                cameraOptions: _initialCameraOptions!,
                styleUri: MapboxStyles.STANDARD,
                mapOptions: _mapOptions,
              ),
            ), //SizedBox
            CarouselSlider(
              items: carouselItems, // named argument
              options: CarouselOptions( // named argument
                height: 130,
                viewportFraction: 0.6,
                initialPage: 0,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int index, CarouselPageChangedReason reason) {
                  setState(() {
                    pageIndex = index;
                  });
                },
              ),
            ),         
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mapboxMap != null && _initialCameraOptions != null) {
            mapboxMap!.flyTo(
              _initialCameraOptions!,
              MapAnimationOptions(duration: 2000, startDelay: 0),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Location Permission Denied"),
          content: const Text("This app requires location permission to show your location on the map."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Location Permission Permanently Denied"),
          content: const Text("Please enable location permission in the app settings."),
          actions: [
            TextButton(
              onPressed: () {
                openAppSettings(); // Open app settings to allow the user to enable permissions
                Navigator.of(context).pop();
              },
              child: const Text("Open Settings"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
