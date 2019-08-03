import 'kino_player_control.dart';

class KinoPlayerConfiguration {
  final String subtitlesPath;
  final List<KinoPlayerControl> playerControls;
  final int videoLoadTimeout;

  KinoPlayerConfiguration(
      {this.subtitlesPath,
        this.videoLoadTimeout = 5000,
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
