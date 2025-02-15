part of 'flash_on_off_cubit.dart';

class FlashOnOffState extends Equatable {
  final bool isFlashOn;

  const FlashOnOffState(this.isFlashOn);

  @override
  List<Object> get props => [isFlashOn];
}
