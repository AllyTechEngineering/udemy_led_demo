import 'package:flutter/material.dart';
import 'package:udemy_led_demo/widgets/flash_slider.dart';
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
      //   title: Text(
      //     Constants.kTitle,
      //     style: Theme.of(context).textTheme.titleLarge,
      //   ),
      //   centerTitle: true,
      // ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // First Column: Timer Widget
          const Expanded(
            child: TimerWidget(),
          ),

          // Second Column: Flash Toggle Switch
          const Expanded(
            child: Center(
              child: SizedBox(
                width: 100.0,
                height: 300.0,
                child: FlashSlider(),
              ),
            ),
          ),

          // Third Column: Vertical PWM Speed Slider
          const Expanded(
            child: Center(
              child: SizedBox(
                width: 100.0,
                height: 300.0,
                child: PwmSlider(),
              ),
            ),
          ),

          // Fourth Column: Toggle Switch and Input Status Indicator
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                PwmToggleSwitch(),
                SizedBox(height: 20),
                SensorStateWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
