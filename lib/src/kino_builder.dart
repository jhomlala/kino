import 'package:kino/kino.dart';
import 'package:video_player/video_player.dart';

import 'kino_player_controller.dart';

class KinoBuilder {
  static KinoPlayer buildSimpleKinoPlayer(String url) {
    KinoPlayerController kinoPlayerController = KinoPlayerController(url: url);

    return KinoPlayer(
      kinoPlayerController: kinoPlayerController,
    );
  }
}
