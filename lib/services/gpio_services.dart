import 'dart:async';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';
import 'package:udemy_led_demo/utilities/constants.dart';

class GpioService {
  static final GpioService _instance = GpioService._internal();
  static Duration pollingDuration =
      const Duration(milliseconds: Constants.kPollingDuration);
  Timer? _pollingTimer;
  Timer? _flashTimer;
  static GPIO gpio5 = GPIO(5, GPIOdirection.gpioDirOut, 0); // Output GPIO
  static GPIO gpio6 = GPIO(6, GPIOdirection.gpioDirOut, 0); // Output GPIO
  static GPIO gpio22 = GPIO(22, GPIOdirection.gpioDirOut, 0);
  static GPIO gpio16 = GPIO(16, GPIOdirection.gpioDirIn, 0); //Sensor input
  static GPIO gpio27 = GPIO(27, GPIOdirection.gpioDirOut, 0); //Sensor state LED

  // Use a map for managing boolean states
  final Map<String, bool> _gpioStates = {
    "directionState": true, // true = forward, false = backward
    "gpioToggleState": true,
    "isInputDetected": false,
    "isPolling": false,
    "currentInputState": false,
    "isFlashing": true,
  };

  factory GpioService() => _instance;

  GpioService._internal() {
    try {
      gpio5.write(false);
      gpio5.getGPIOinfo();
      debugPrint('gpio5 Initialized');
    } on Exception catch (e) {
      debugPrint('Error initializing gpio5: $e');
    }
    try {
      gpio6.write(false);
      gpio6.getGPIOinfo();
      debugPrint('gpio6 Initialized');
    } on Exception catch (e) {
      debugPrint('Error initializing gpio6: $e');
    }
    try {
      gpio22.write(false);
      gpio22.getGPIOinfo();
      debugPrint('gpio22 Initialized');
    } on Exception catch (e) {
      debugPrint('Error initializing gpio22: $e');
    }
    try {
      gpio16.read();
      gpio16.getGPIOinfo();
      debugPrint('gpio16 Initialized');
    } on Exception catch (e) {
      debugPrint('Error initializing gpio16: $e');
    }
    try {
      gpio27.write(false);
      gpio27.getGPIOinfo();
      debugPrint('gpio27 Initialized');
    } on Exception catch (e) {
      debugPrint('Error initializing gpio27: $e');
    }
  }

  // Getters for boolean states
  bool get directionState => _gpioStates["directionState"]!;
  bool get gpioToggleState => _gpioStates["gpioToggleState"]!;
  bool get isInputDetected => _gpioStates["isInputDetected"]!;
  bool get isPolling => _gpioStates["isPolling"]!;
  bool get currentInputState => _gpioStates["currentInputState"]!;
  bool get isFlashing => _gpioStates["isFlashing"]!;

  
  // Methods to modify state values
  void setState(String key, bool value) {
    _gpioStates[key] = value;
  }

  void initializeGpioService() {
    try {
      debugPrint('Dummy Code');
      // checkBuildMode();
      // gpio5.write(false);
      // gpio5.getGPIOinfo();
      // gpio6.write(false);
      // gpio6.getGPIOinfo();
      // gpio22.write(false);
      // gpio22.getGPIOinfo();
      // gpio16.read();
      // gpio16.getGPIOinfo();
      // gpio27.write(false);
      // gpio27.getGPIOinfo();
    } on Exception catch (e) {
      debugPrint('gpip initialization failed: $e');
    }
  }

  void checkBuildMode() {
    if (kDebugMode) {
      debugPrint('Running in debug mode');
    } else if (kReleaseMode) {
      debugPrint('Running in release mode');
    } else if (kProfileMode) {
      debugPrint('Running in profile mode');
    }
  }

  // GPIO Input Polling
  void startInputPolling(Function(bool) onData) {
    debugPrint('Starting GPIO input polling onDate: $onData, isPolling: $isPolling');
    if (isPolling) return;
    setState("isPolling", true);

    _pollingTimer = Timer.periodic(pollingDuration, (_) {
      bool newState = gpio16.read();
      if (newState != isInputDetected) {
        setState("isInputDetected", newState);
        onData(newState);
      }
    });
  }

bool getFlashState() {
    return gpio22.read();
  }
  

  void stopInputPolling() {
    _pollingTimer?.cancel();
    setState("isPolling", false);
  }

  // GPIO Output Control
  void toggleGpioState() {
    final bool newState = !gpioToggleState;
    setState("gpioToggleState", newState);
    gpio5.write(newState);
    gpio6.write(newState);
  }

  void setRelayState(bool state) {
    gpio5.write(state);
    debugPrint('Relay GPIO 5 set to: $state');
  }

  void pwmMotorServiceDirection() {
    gpio5.write(true);
    gpio6.write(true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState("directionState", !directionState);
      gpio5.write(!directionState);
      gpio6.write(directionState);
    });
  }

  // Sensor input LED control
  void setLedState(bool state) {
    gpio27.write(state);
    debugPrint('Relay GPIO 27 set to: $state');
  }

  // Flashing Device Control
  void updateDeviceFlashRate(double newFlashRate) {
    debugPrint('Device newFlashRate: $newFlashRate');
    if (newFlashRate == 0 && isFlashing) {
      stopFlashingDevice();
    } else {
      setState("isFlashing", true);
      int flashRate = (newFlashRate).toInt();
      debugPrint('Device flash rate: $flashRate');
      _flashTimer?.cancel();
      _flashTimer = Timer.periodic(Duration(milliseconds: flashRate), (_) {
        gpio22.write(!gpio22.read()); // Toggle LED state
      });
    }
  }

  void startFlashingDevice() {
    debugPrint('Device startFlashingDevice');
    setState("isFlashing", true);
  }

  void stopFlashingDevice() {
    debugPrint('Device stopFlashingDevice');
    setState("isFlashing", false);
    _flashTimer?.cancel();
    gpio22.write(false);
  }

  // Disposal
  void dispose() {
    _pollingTimer?.cancel();
    _flashTimer?.cancel();

    gpio5.write(false);
    gpio6.write(false);
    gpio22.write(false);
    gpio27.write(false);

    gpio5.dispose();
    gpio6.dispose();
    gpio22.dispose();
    gpio16.dispose();
    gpio27.dispose();

    debugPrint('GPIO resources released');
  }
}
