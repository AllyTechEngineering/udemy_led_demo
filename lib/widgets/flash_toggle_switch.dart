import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_led_demo/bloc/cubits/flash_on_off_cubit/flash_on_off_cubit.dart';
import 'package:udemy_led_demo/utilities/constants.dart';
import 'package:udemy_led_demo/utilities/custom_button_decorations.dart';

class FlashToggleSwitch extends StatelessWidget {
  const FlashToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashOnOffCubit, FlashOnOffState>(
      builder: (context, state) {
        return Container(
          width: Constants.kWidth,
          height: Constants.kHeight,
          padding: const EdgeInsets.all(4.0),
          decoration: CustomDecorations.gradientContainer(isActive: state.isFlashOn),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.isFlashOn ? Constants.kLabelFlashOn : Constants.kLabelFlashOff,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Switch(
                value: state.isFlashOn,
                onChanged: (_) => context.read<FlashOnOffCubit>().toggleFlash(),
              ),
            ],
          ),
        );
      },
    );
  }
}

