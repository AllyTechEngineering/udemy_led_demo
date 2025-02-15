import 'package:flutter/material.dart';
import 'package:udemy_led_demo/widgets/pwm_slider.dart';
import 'package:udemy_led_demo/widgets/pwm_toggle_switch.dart';
import 'package:udemy_led_demo/widgets/sensor_state_widget.dart';
import 'package:udemy_led_demo/widgets/timer_widget.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(Constants.kAppTitle),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sensor State Widget (Original Position & Styling)
            const SensorStateWidget(),
            const SizedBox(height: 20),

            // PWM Control Row (Slider + Toggle Switch)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                
                // PWM Slider (Maintains Original Position)
                const Expanded(child: PwmSlider()),

                const SizedBox(width: 20),

                // PWM Toggle Switch (Maintains Original Position)
                const PwmToggleSwitch(),

                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 20),

            // Timer Widget (Maintains Original Position & Styling)
            const TimerWidget(),
          ],
        ),
      ),
    );
  }
}
