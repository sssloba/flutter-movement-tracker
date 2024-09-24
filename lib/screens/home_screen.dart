import 'package:flutter/material.dart';
import 'package:flutter_movement_tracker/screens/movement_tracker.dart';
import 'package:flutter_movement_tracker/services/pedometer_service.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool permisssionGranted = false;
  @override
  void initState() {
    super.initState();

    Permission.activityRecognition.request().then((value) {
      if (value.isGranted) {
        permisssionGranted = true;
        PedometerService().initPlatformState();
        setState(() {});
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Activity Recognation Permission must be enable for Mouvemetn Tracking',
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movement Tracker Home Screen'),
        ),
        body: Center(
          child: Builder(builder: (context) {
            return ElevatedButton(
              onPressed: permisssionGranted
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MovementTracker(),
                        ),
                      )
                  : null,
              child: const Text('Go To Movement Tracker Page'),
            );
          }),
        ),
      ),
    );
  }
}
