import 'package:kino/kino.dart';
import 'package:video_player/video_player.dart';

import 'kino_configuration.dart';
import 'kino_player_control.dart';
import 'kino_player_controller.dart';

class KinoBuilder {

  static KinoPlayer buildSimpleKinoPlayerWithUrls(List<String> urls){
    KinoPlayerConfiguration kinoPlayerConfiguration =
    new KinoPlayerConfiguration();
    KinoPlayerController kinoPlayerController = KinoPlayerController(
        urls: urls, kinoPlayerConfiguration: kinoPlayerConfiguration);
    return KinoPlayer(
      kinoPlayerController: kinoPlayerController,
    );
  }

  static KinoPlayer buildSimpleKinoPlayer(String url, String subtitlesPath) {
    KinoPlayerConfiguration kinoPlayerConfiguration =
        new KinoPlayerConfiguration(subtitlesPath: subtitlesPath);

    KinoPlayerController kinoPlayerController = KinoPlayerController(
        urls: List()..add(url), kinoPlayerConfiguration: kinoPlayerConfiguration);

    return KinoPlayer(
      kinoPlayerController: kinoPlayerController,
    );
  }
}
