import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:udemy_led_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_led_demo/services/gpio_services.dart';

part 'flash_on_off_state.dart';

class FlashOnOffCubit extends Cubit<FlashOnOffState> {
  final DataRepository _dataRepository;
  final GpioService _gpioService;

  FlashOnOffCubit(this._dataRepository, this._gpioService)
      : super(FlashOnOffState(_dataRepository.deviceState.flashOn));

  void toggleFlash() {
    final newState = !_dataRepository.deviceState.flashOn;
    final updatedState =
        _dataRepository.deviceState.copyWith(flashOn: newState);
    _dataRepository.updateDeviceState(updatedState);

    newState
        ? _gpioService.startFlashingDevice()
        : _gpioService.stopFlashingDevice();
    emit(FlashOnOffState(newState));
  }
}
