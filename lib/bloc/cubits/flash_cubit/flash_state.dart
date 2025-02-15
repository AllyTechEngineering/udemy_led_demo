part of 'flash_cubit.dart';

class FlashState extends Equatable {
  final bool isFlashing;
  final int flashRate;

  const FlashState(this.isFlashing, this.flashRate);

  @override
  List<Object> get props => [isFlashing, flashRate];
}
