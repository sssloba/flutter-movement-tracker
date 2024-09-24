import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerService {
  static late Stream<StepCount> stepCountStream;
  static late Stream<PedestrianStatus> pedestrianStatusStream;
  String _status = 'Unknown', _steps = '0';

  String get status => _status;
  String get steps => _steps;
  // Stream<StepCount> get stepCountStream => _stepCountStream;
  // Stream<PedestrianStatus> get pedestrianStatusStream =>
  //     _pedestrianStatusStream;

  void onStepCount(StepCount event) {
    debugPrint('Step Count event: $event');

    _steps = event.steps.toString();
    // final time = event.timeStamp;
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    debugPrint('Pedestrian Status event: $event');
    _status = event.status;
  }

  void onPedestrianStatusError(error) {
    debugPrint('onPedestrianStatusError: $error');
    debugPrint(_status);
    _status = 'Pedestrian Status not available';
  }

  void onStepCountError(error) {
    debugPrint('onStepCountError: $error');

    _steps = 'Step Count not available';
  }

  Future<void> initPlatformState() async {
    //final activityPermission = await Permission.activityRecognition.request();

    //if (activityPermission.isGranted) {
    pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    stepCountStream = Pedometer.stepCountStream;
    stepCountStream.listen(onStepCount).onError(onStepCountError);
    // } else {
    //   onPedestrianStatusError('Activity permission is not granted');
    // }
  }
}
