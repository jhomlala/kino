import 'package:kino/kino.dart';
import 'package:video_player/video_player.dart';

import 'kino_configuration.dart';
import 'kino_player_control.dart';
import 'kino_player_controller.dart';

class KinoBuilder {
  static KinoPlayer buildSimpleKinoPlayer(String url) {
    KinoPlayerConfiguration kinoPlayerConfiguration =
        new KinoPlayerConfiguration();

    KinoPlayerController kinoPlayerController = KinoPlayerController(
        url: url, kinoPlayerConfiguration: kinoPlayerConfiguration);

    return KinoPlayer(
      kinoPlayerController: kinoPlayerController,
    );
  }
}
