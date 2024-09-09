import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //if(Platform.isAndroid) {ForegroundService().start();}

  runApp(const MovementTrackerApp());
}

class MovementTrackerApp extends StatefulWidget {
  const MovementTrackerApp({super.key});

  @override
  MovementTrackerAppState createState() => MovementTrackerAppState();
}

class MovementTrackerAppState extends State<MovementTrackerApp> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = 'Unknown', _steps = '0';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    debugPrint('Step Count event: $event');
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    debugPrint('Pedestrian Status event: $event');
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    debugPrint('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    debugPrint(_status);
  }

  void onStepCountError(error) {
    debugPrint('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  Future<void> initPlatformState() async {
    final activityPermission = await Permission.activityRecognition.request();

    if (activityPermission.isGranted) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);

      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);

      if (!mounted) return;
    } else {
      onPedestrianStatusError('Activity permission is not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer Example'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Steps Taken:',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  _steps,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 60, fontWeight: FontWeight.bold),
                ),
                const Divider(
                  height: 50,
                  thickness: 0,
                  color: Colors.white,
                ),
                const Text(
                  'Pedestrian Status:',
                  style: TextStyle(fontSize: 30),
                ),
                Icon(
                  _status == 'walking'
                      ? Icons.directions_walk
                      : _status == 'stopped'
                          ? Icons.accessibility_new
                          : Icons.error,
                  size: 100,
                  color: _status == 'walking' ? Colors.green : Colors.red,
                ),
                Center(
                  child: Text(
                    _status,
                    style: _status == 'walking' || _status == 'stopped'
                        ? const TextStyle(fontSize: 30)
                        : const TextStyle(fontSize: 30, color: Colors.red),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
