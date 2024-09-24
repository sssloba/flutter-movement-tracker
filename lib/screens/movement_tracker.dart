import 'package:flutter/material.dart';
import 'package:flutter_movement_tracker/services/pedometer_service.dart';

import 'package:pedometer/pedometer.dart';

class MovementTracker extends StatefulWidget {
  const MovementTracker({super.key});

  @override
  MovementTrackerState createState() => MovementTrackerState();
}

class MovementTrackerState extends State<MovementTracker> {
  //final pedometerService = PedometerService();
  // StreamController<StepCount> stepCountStream = StreamController<StepCount>();
  // StreamController<PedestrianStatus> pedestrianStatusStream =
  //     StreamController<PedestrianStatus>();

  @override
  void initState() {
    super.initState();

    //pedometerService.initPlatformState();
    // .then((_) {
    //   pedometerService.stepCountStream.listen((data) {
    //     stepCountStream.add(data);
    //   });
    //   pedometerService.pedestrianStatusStream.listen((data) {
    //     pedestrianStatusStream.add(data);
    //   });
    // });
  }

  // @override
  // void dispose() {
  //   stepCountStream.close();
  //   pedestrianStatusStream.close();
  //   super.dispose();
  // }

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
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20.0,
              children: <Widget>[
                const Text(
                  'Steps Taken:',
                  style: TextStyle(fontSize: 30),
                ),
                StreamBuilder<StepCount>(
                    stream: PedometerService.stepCountStream,
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
                  stream: PedometerService.pedestrianStatusStream,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        Icon(
                          snapshot.data?.status == 'walking'
                              ? Icons.directions_walk
                              : snapshot.data?.status == 'stopped'
                                  ? Icons.accessibility_new
                                  : Icons.error,
                          size: 100,
                          color: snapshot.data?.status == 'walking'
                              ? Colors.green
                              : Colors.red,
                        ),
                        Text(
                          snapshot.data?.status ?? 'Unknown',
                          style: snapshot.data?.status == 'walking' ||
                                  snapshot.data?.status == 'stopped'
                              ? const TextStyle(fontSize: 30)
                              : const TextStyle(
                                  fontSize: 30, color: Colors.red),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
