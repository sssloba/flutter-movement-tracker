import 'package:flutter/material.dart';
import 'package:flutter_movement_tracker/services/pedometer_service.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';

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
  final pedometerService = PedometerService();
  StreamController<StepCount> stepCountStream = StreamController<StepCount>();
  StreamController<PedestrianStatus> pedestrianStatusStream =
      StreamController<PedestrianStatus>();

  @override
  void initState() {
    super.initState();

    pedometerService.initPlatformState().then((_) {
      pedometerService.stepCountStream.listen((data) {
        stepCountStream.add(data);
      });
      pedometerService.pedestrianStatusStream.listen((data) {
        pedestrianStatusStream.add(data);
      });
    });
  }

  @override
  void dispose() {
    stepCountStream.close();
    pedestrianStatusStream.close();
    super.dispose();
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
                StreamBuilder<StepCount>(
                    stream: stepCountStream.stream,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data?.steps.toString() ?? '0',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      );
                    }),
                const Divider(
                  height: 50,
                  thickness: 0,
                  color: Colors.white,
                ),
                const Text(
                  'Pedestrian Status:',
                  style: TextStyle(fontSize: 30),
                ),
                StreamBuilder<PedestrianStatus>(
                    stream: pedestrianStatusStream.stream,
                    builder: (context, snapshot) {
                      return Icon(
                        snapshot.data?.status == 'walking'
                            ? Icons.directions_walk
                            : snapshot.data?.status == 'stopped'
                                ? Icons.accessibility_new
                                : Icons.error,
                        size: 100,
                        color: snapshot.data?.status == 'walking'
                            ? Colors.green
                            : Colors.red,
                      );
                    }),
                StreamBuilder<PedestrianStatus>(
                    stream: pedestrianStatusStream.stream,
                    builder: (context, snapshot) {
                      return Center(
                        child: Text(
                          snapshot.data?.status ?? 'Unknown',
                          style: snapshot.data?.status == 'walking' ||
                                  snapshot.data?.status == 'stopped'
                              ? const TextStyle(fontSize: 30)
                              : const TextStyle(
                                  fontSize: 30, color: Colors.red),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
