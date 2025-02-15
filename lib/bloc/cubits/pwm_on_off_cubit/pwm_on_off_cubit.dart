import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:udemy_led_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_led_demo/services/pwm_services.dart';

part 'pwm_on_off_state.dart';

class PwmOnOffCubit extends Cubit<PwmOnOffState> {
  final DataRepository _dataRepository;
  final PwmService _pwmService;

  PwmOnOffCubit(this._dataRepository, this._pwmService)
      : super(PwmOnOffState(_dataRepository.deviceState.pwmOn));

  void togglePwm() {
    final newState = !_dataRepository.deviceState.pwmOn;
    final updatedState = _dataRepository.deviceState.copyWith(pwmOn: newState);
    _dataRepository.updateDeviceState(updatedState);
    _pwmService.pwmSystemOnOff();
    emit(PwmOnOffState(newState));
  }
}
