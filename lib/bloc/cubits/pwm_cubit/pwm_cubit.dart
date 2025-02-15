import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:udemy_led_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_led_demo/services/pwm_services.dart';
part 'pwm_state.dart';

class PwmCubit extends Cubit<PwmState> {
  final DataRepository _dataRepository;
  final PwmService _pwmService;

  PwmCubit(this._dataRepository, this._pwmService)
      : super(PwmState(_dataRepository.deviceState.pwmDutyCycle));

  void updatePwm(int value) {
    final updatedState = _dataRepository.deviceState.copyWith(pwmDutyCycle: value);
    _dataRepository.updateDeviceState(updatedState);
    _pwmService.updatePwmDutyCycle(value);
    emit(PwmState(value));
  }
}
