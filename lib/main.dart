import 'package:flutter/material.dart';
import 'package:flutter_movement_tracker/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //if(Platform.isAndroid) {ForegroundService().start();}

  runApp(const HomeScreen());
}
