import 'package:flutter/material.dart';
import 'package:untitled10/shared_preferences.dart';

import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  PreferencesHelper.instance.init();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,

      home:  HomeScreen(),
    );
  }
}




