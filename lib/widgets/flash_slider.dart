import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_led_demo/bloc/cubits/flash_cubit/flash_cubit.dart';


class FlashSlider extends StatelessWidget {
  const FlashSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashCubit, FlashState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Flash Rate: ${state.flashRate} ms",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.blueAccent,
                  inactiveTrackColor: Colors.grey,
                  thumbColor: Colors.blue,
                  overlayColor: Colors.blue.withAlpha(32),
                  valueIndicatorColor: Colors.blueAccent,
                  showValueIndicator: ShowValueIndicator.always,
                ),
                child: Slider(
                  value: state.flashRate.toDouble(),
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  label: "${state.flashRate} ms",
                  onChanged: (value) {
                    context.read<FlashCubit>().updateFlashRate(value.toInt());
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
