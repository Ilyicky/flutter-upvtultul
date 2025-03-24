import 'package:demo_app/pages/login_page.dart';
import 'package:demo_app/themeProvider/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
//import '../pages/maps_page.dart';
//import '../pages/main_page.dart';
//import '../pages/register_page.dart';

Future<void> main() async {
  await setup();
  runApp(const MyApp());
  await Firebase.initializeApp();
}

Future<void> setup() async {
  await dotenv.load(
    fileName: ".env",
  );
  MapboxOptions.setAccessToken(
    dotenv.env["MAPBOX_ACCESS_TOKEN"]!,
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tultul UPV App',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}


/* class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[100], // Light blue background
      child: Center(
        child: Text(
          'Dashboard',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[100], // Light green background
      child: Center(
        child: Text(
          'Search',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[100], // Light yellow background
      child: Center(
        child: Text(
          'Profile',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
} */