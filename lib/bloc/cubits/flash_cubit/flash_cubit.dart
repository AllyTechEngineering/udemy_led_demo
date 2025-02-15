import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:udemy_led_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_led_demo/services/gpio_services.dart';

part 'flash_state.dart';

class FlashCubit extends Cubit<FlashState> {
  final DataRepository _dataRepository;
  final GpioService _gpioService;

  FlashCubit(this._dataRepository, this._gpioService)
      : super(FlashState(
          _dataRepository.deviceState.flashOn,
          _dataRepository.deviceState.flashRate,
        ));

  void toggleFlashing() {
    final newState = !_dataRepository.deviceState.flashOn;
    final updatedState =
        _dataRepository.deviceState.copyWith(flashOn: newState);
    _dataRepository.updateDeviceState(updatedState);
    newState
        ? _gpioService.startFlashingDevice()
        : _gpioService.stopFlashingDevice();
    emit(FlashState(newState, _dataRepository.deviceState.flashRate));
  }

  void updateFlashRate(int value) {
    final updatedState = _dataRepository.deviceState.copyWith(flashRate: value);
    _dataRepository.updateDeviceState(updatedState);
    _gpioService.updateDeviceFlashRate(value.toDouble());
    emit(FlashState(_dataRepository.deviceState.flashOn, value));
  }
}
