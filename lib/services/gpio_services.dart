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
  late GPIO gpio5; // Output GPIO
  late GPIO gpio6; // Output GPIO
  late GPIO gpio22;
  late GPIO gpio26; // Input GPIO
  late GPIO gpio27; // Relay GPIO

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
      gpio5 = GPIO(5, GPIOdirection.gpioDirOut, 0);
      gpio6 = GPIO(6, GPIOdirection.gpioDirOut, 0);
      gpio22 = GPIO(22, GPIOdirection.gpioDirOut, 0); // UI state LED
      gpio26 = GPIO(26, GPIOdirection.gpioDirIn, 0); // Binary sensor input
      gpio27 = GPIO(27, GPIOdirection.gpioDirOut, 0); // Sensor state LED
      debugPrint('GPIO Service Initialized');
    } on Exception catch (e) {
      debugPrint('Error initializing GpioService: $e');
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
      checkBuildMode();
      gpio5.write(false);
      gpio6.write(false);
      gpio22.write(false);
      gpio26.read();
      gpio27.write(false);
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
    if (isPolling) return;
    setState("isPolling", true);

    _pollingTimer = Timer.periodic(pollingDuration, (_) {
      bool newState = gpio26.read();
      if (newState != isInputDetected) {
        setState("isInputDetected", newState);
        onData(newState);
      }
    });
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
      int flashRate = (newFlashRate * 10).toInt();
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
    gpio26.dispose();
    gpio27.dispose();

    debugPrint('GPIO resources released');
  }
}