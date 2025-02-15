import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_led_demo/bloc/cubits/flash_cubit/flash_cubit.dart';
import 'package:udemy_led_demo/bloc/cubits/flash_on_off_cubit/flash_on_off_cubit.dart';
import 'package:udemy_led_demo/bloc/cubits/pwm_cubit/pwm_cubit.dart';
import 'package:udemy_led_demo/bloc/cubits/pwm_on_off_cubit/pwm_on_off_cubit.dart';
import 'package:udemy_led_demo/bloc/cubits/sensor_cubit/sensor_cubit.dart';
import 'package:udemy_led_demo/bloc/cubits/timer_cubit/timer_cubit.dart';
import 'package:udemy_led_demo/bloc/data_repository/data_repository.dart';
import 'package:udemy_led_demo/services/gpio_services.dart';
import 'package:udemy_led_demo/services/pwm_services.dart';
import 'package:udemy_led_demo/services/timer_services.dart';
import 'package:udemy_led_demo/screens/home_screen.dart';
import 'package:udemy_led_demo/utilities/custom_app_theme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final pwmService = PwmService();
  final gpioService = GpioService();
  final timerService = TimerService();

  // Initialize repository with a default state
  final dataRepository = DataRepository(
    gpioService: gpioService,
    pwmService: pwmService,
    timerService: timerService,
  );

  gpioService.initializeGpioService();

  // Ensure window_manager is initialized
  await windowManager.ensureInitialized();
  final windowListener = MyWindowListener(pwmService, gpioService);
  windowManager.addListener(windowListener);

  runApp(MyApp(dataRepository: dataRepository, pwmService: pwmService, gpioService: gpioService, timerService: timerService));
}

class MyWindowListener extends WindowListener {
  final PwmService pwmService;
  final GpioService gpioService;

  MyWindowListener(this.pwmService, this.gpioService);

  @override
  void onWindowClose() async {
    debugPrint("Window close detected, disposing resources...");
    pwmService.dispose();
    gpioService.dispose();
    windowManager.destroy;
    exit(0);
  }
}

class MyApp extends StatelessWidget {
  final DataRepository dataRepository;
  final PwmService pwmService;
  final GpioService gpioService;
  final TimerService timerService;

  const MyApp({super.key, required this.dataRepository, required this.pwmService, required this.gpioService, required this.timerService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PwmCubit(dataRepository, pwmService)),
        BlocProvider(create: (context) => PwmOnOffCubit(dataRepository, pwmService)),
        BlocProvider(create: (context) => FlashCubit(dataRepository, gpioService)),
        BlocProvider(create: (context) => FlashOnOffCubit(dataRepository, gpioService)),
        BlocProvider(create: (context) => TimerCubit(dataRepository, timerService)),
        BlocProvider(create: (context) => SensorCubit(gpioService, dataRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LED Demo',
        theme: CustomAppTheme.appTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
