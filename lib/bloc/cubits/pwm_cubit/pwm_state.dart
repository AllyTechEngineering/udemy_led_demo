part of 'pwm_cubit.dart';

class PwmState extends Equatable {
  final int dutyCycle;

  const PwmState(this.dutyCycle);

  @override
  List<Object> get props => [dutyCycle];

  @override
  String toString() => 'PwmState(dutyCycle: $dutyCycle)';
}
