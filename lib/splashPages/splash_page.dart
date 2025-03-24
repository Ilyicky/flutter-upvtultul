import 'dart:async';
import 'package:demo_app/Assistants/assistant_methods.dart';
import 'package:demo_app/global/global.dart';
import 'package:demo_app/pages/login_page.dart';
import 'package:demo_app/pages/main_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

startTimer(){
  Timer(Duration(seconds: 3), () async {
    if(await firebaseAuth.currentUser != null){
      firebaseAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo() : null;
      Navigator.push(context, MaterialPageRoute(builder: (c) => MainPage()));
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (c) => LoginPage()));
    }
  });
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Flutter App"
        ),
      ),
    );
  }
}