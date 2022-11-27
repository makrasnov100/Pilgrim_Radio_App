import 'package:get_it/get_it.dart';
import 'package:voice_of_pilgrim/services/general_info_service.dart';
import 'package:voice_of_pilgrim/services/like_dislike_service.dart';

final getIt = GetIt.instance;

Future<void> setupSingleton() async {
  getIt.registerSingleton<LikeDislikeService>(LikeDislikeService());
  getIt.registerSingleton<GeneralInfoService>(GeneralInfoService());
  await getIt<GeneralInfoService>().initializeService();
}
