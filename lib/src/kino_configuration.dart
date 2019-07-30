import 'kino_player_control.dart';

class KinoPlayerConfiguration {
  final String subtitlesPath;
  final List<KinoPlayerControl> playerControls;

  KinoPlayerConfiguration(
      {this.subtitlesPath,
      this.playerControls = const [
        KinoPlayerControl.VOLUME,
        KinoPlayerControl.SKIP_PREVIOUS,
        KinoPlayerControl.REWIND,
        KinoPlayerControl.PLAY_AND_PAUSE,
        KinoPlayerControl.FORWARD,
        KinoPlayerControl.SKIP_NEXT,
        KinoPlayerControl.FULLSCREEN,
        KinoPlayerControl.PROGRESS,
        KinoPlayerControl.TIME
      ]});
}
