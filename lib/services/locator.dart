import 'package:get_it/get_it.dart';
import 'package:voice_of_pilgrim/services/radio_control_service.dart';

final getIt = GetIt.instance;

void setupSingleton() {
  getIt.registerSingleton<RadioControlService>(RadioControlService());
}