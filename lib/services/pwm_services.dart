import 'dart:io';

import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

// import 'package:led_on_off_pwm/services/gpio_service.dart';
// Must follow the how to enabl e PWM in the Raspberry Pi
// Located on the readme page.
class PwmService {
  static final PwmService _instance = PwmService._internal();
  late PWM pwm0;
  late PWM pwm1;
  static bool systemOnOffState = true;

  factory PwmService() {
    return _instance;
  }

  PwmService._internal() {
    try {
      _exportPwm(); // Ensure PWM0 is available before opening it
      pwm0 = PWM(2, 0);
      pwm1 = PWM(2, 1);
      pwm0.setPeriodNs(10000000);
      pwm1.setPeriodNs(10000000);
      pwm0.setDutyCycleNs(0);
      pwm1.setDutyCycleNs(0);
      pwm0.enable();
      pwm1.enable();
      pwm0.setPolarity(Polarity.pwmPolarityNormal);
      pwm1.setPolarity(Polarity.pwmPolarityNormal);
      debugPrint('PwmService Initialized: ${pwm0.getPWMinfo()}');
      // debugPrint('PwmService Initialized: ${pwm1.getPWMinfo()}');
    } catch (e) {
      debugPrint('Error initializing PwmService: $e');
    }
  }

  /// Ensures PWM is exported before opening it
  void _exportPwm() {
    try {
      if (!File('/sys/class/pwm/pwmchip2/pwm0').existsSync()) {
        debugPrint('Exporting PWM0...');
        Process.runSync(
            'sh', ['-c', 'echo 0 > /sys/class/pwm/pwmchip2/export']);
        debugPrint('Exporting PWM1...');
        Process.runSync(
            'sh', ['-c', 'echo 1 > /sys/class/pwm/pwmchip2/export']);
        sleep(Duration(milliseconds: 500)); // Wait for the system to process
      }
    } catch (e) {
      debugPrint('Error exporting PWM0 or PWM1: $e');
    }
  }

  void updatePwmDutyCycle(int updateDutyCycle) {
    debugPrint(
        'In PwmService updatePwmDutyCycle systemOnOffSate: $systemOnOffState');
    if (systemOnOffState) {
      pwm0.setDutyCycleNs(updateDutyCycle * 100000);
      pwm1.setDutyCycleNs(updateDutyCycle * 100000);
      // pwm2.setDutyCycleNs(updateDutyCycle * 100000);
      // pwm3.setDutyCycleNs(updateDutyCycle * 100000);
      debugPrint(
        'In PwmService updatePwmDutyCycle DutyCycleNs= ${pwm0.getDutyCycleNs()}',
      );
      debugPrint(
        'In PwmService updatePwmDutyCycle PWM Info: ${pwm0.getPWMinfo()}',
      );
    }
  }

  void stopPwm() {
    pwm0.disable();
    pwm1.disable();
  }

  void startPwm() {
    pwm0.enable();
    pwm1.enable();
  }

  void pwmSystemOnOff() {
    systemOnOffState = !systemOnOffState;
    debugPrint('In PwmService systemOnOffState: $systemOnOffState');
    if (!systemOnOffState) {
      pwm0.disable();
      pwm1.disable();
      // pwm2.disable();
      // pwm3.disable();
      // GpioService().setLedState(false);
      // GpioService().setState("isPolling", false);
      debugPrint('In pwmSystemOnOff disable: ${pwm0.getEnabled()}');
    }
    if (systemOnOffState) {
      pwm0.enable();
      pwm1.enable();
      // pwm2.enable();
      // pwm3.enable();
      // GpioService().setLedState(true);
      // GpioService().setState("isPolling", true);
      debugPrint('In pwmSystemOnOff enable: ${pwm0.getEnabled()}');
    }
  }

  //Disposal
  // Add all the enabled pwms to the dispose method
  void dispose() {
    pwm0.disable();
    pwm1.disable();
    pwm0.dispose();
    pwm1.dispose();
    debugPrint('PWM resources released');
  }
} // End of class PwmService