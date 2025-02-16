part of 'pwm_on_off_cubit.dart';

class PwmOnOffState extends Equatable {
  final bool isPwmOn ;

  const PwmOnOffState(this.isPwmOn);

  @override
  List<Object> get props => [isPwmOn];
}
