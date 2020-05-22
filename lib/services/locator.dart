import 'package:get_it/get_it.dart';
import 'package:voice_of_pilgrim/services/like_dislike_service.dart';

final getIt = GetIt.instance;

void setupSingleton() {
  getIt.registerSingleton<LikeDislikeService>(LikeDislikeService());
}