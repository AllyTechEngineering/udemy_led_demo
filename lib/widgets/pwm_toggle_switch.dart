import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_led_demo/bloc/cubits/pwm_on_off_cubit/pwm_on_off_cubit.dart';
import 'package:udemy_led_demo/utilities/constants.dart';
import 'package:udemy_led_demo/utilities/custom_button_decorations.dart';

class PwmToggleSwitch extends StatelessWidget {
  const PwmToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PwmOnOffCubit, PwmOnOffState>(
      builder: (context, state) {
        return Container(
          width: Constants.kWidth,
          height: Constants.kHeight,
          padding: const EdgeInsets.all(4.0),
          decoration: CustomDecorations.gradientContainer(isActive: state.isPwmOn),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.isPwmOn ? Constants.kOn : Constants.kOff,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Switch(
                value: state.isPwmOn,
                onChanged: (_) => context.read<PwmOnOffCubit>().togglePwm(),
              ),
            ],
          ),
        );
      },
    );
  }
}
