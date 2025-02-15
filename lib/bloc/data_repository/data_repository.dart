

import 'package:udemy_led_demo/models/device_state_model.dart';

class DataRepository {
  DeviceStateModel _deviceState = DeviceStateModel(
    pwmDutyCycle: 0,
    pwmOn: false,
    flashRate: 0,
    flashOn: false,
    timerStart: DateTime.now(),
    timerEnd: DateTime.now().add(const Duration(minutes: 1)),
    gpioSensorState: false,
  );

  DataRepository();

  // Getter for current device state
  DeviceStateModel get deviceState => _deviceState;

  // Update state with a new model (used by Cubits)
  void updateDeviceState(DeviceStateModel newState) {
    _deviceState = newState;
  }
}
