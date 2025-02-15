import 'package:flutter/material.dart';
import 'package:udemy_led_demo/widgets/flash_toggle_switch.dart';
import 'package:udemy_led_demo/widgets/pwm_toggle_switch.dart';
import 'package:udemy_led_demo/widgets/sensor_state_widget.dart';
import 'package:udemy_led_demo/widgets/timer_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sensor State Widget
            const SensorStateWidget(),
            const SizedBox(height: 20),

            // PWM Toggle Switch
            const PwmToggleSwitch(),
            const SizedBox(height: 20),

            // Flash Toggle Switch
            const FlashToggleSwitch(),
            const SizedBox(height: 20),

            // Timer Widget
            const TimerWidget(),
          ],
        ),
      ),
    );
  }
}
