
import 'package:udemy_led_demo/models/device_state_model.dart';
import 'package:udemy_led_demo/services/gpio_services.dart';
import 'package:udemy_led_demo/services/pwm_services.dart';
import 'package:udemy_led_demo/services/timer_services.dart';

class DataRepository {
  final GpioService _gpioService;
  final PwmService _pwmService;
  final TimerService _timerService;

  DeviceStateModel _deviceState = DeviceStateModel(
    pwmDutyCycle: 0,
    pwmOn: false,
    flashRate: 0,
    flashOn: false,
    timerStart: DateTime.now(),
    timerEnd: DateTime.now().add(const Duration(minutes: 1)),
    gpioSensorState: false,
  );

  DataRepository({
    required GpioService gpioService,
    required PwmService pwmService,
    required TimerService timerService,
  })  : _gpioService = gpioService,
        _pwmService = pwmService,
        _timerService = timerService;

  // Getter for current device state
  DeviceStateModel get deviceState => _deviceState;

  // Update state with a new model (used by Cubits)
  void updateDeviceState(DeviceStateModel newState) {
    _deviceState = newState;
  }
}
