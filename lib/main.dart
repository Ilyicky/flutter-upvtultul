//import 'package:demo_app/pages/login_page.dart';
//import 'package:demo_app/pages/maps_page.dart';
import 'package:demo_app/themeProvider/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../splashPages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setup();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

Future<void> setup() async{
  await dotenv.load(fileName: ".env",
  );
  MapboxOptions.setAccessToken(
    dotenv.env['MAPBOX_ACCESS_TOKEN']!,
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPV Tultul App',
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}