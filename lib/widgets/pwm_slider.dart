import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_led_demo/bloc/cubits/pwm_cubit/pwm_cubit.dart';

class PwmSlider extends StatelessWidget {
  const PwmSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PwmCubit, PwmState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "PWM Duty Cycle: ${state.dutyCycle}%",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.greenAccent,
                  inactiveTrackColor: Colors.grey,
                  thumbColor: Colors.green,
                  overlayColor: Colors.green.withAlpha(32),
                  valueIndicatorColor: Colors.greenAccent,
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Slider(
                  value: state.dutyCycle.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: "${state.dutyCycle}%",
                  onChanged: (value) {
                    context.read<PwmCubit>().updatePwm(value.toInt());
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
