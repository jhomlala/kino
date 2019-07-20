import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'kino_configuration.dart';
import 'kino_player_controller_provider.dart';
import 'kino_player_event.dart';
import 'kino_player_event_type.dart';

class KinoPlayerController extends ValueNotifier<KinoPlayerEvent> {
  KinoPlayerConfiguration kinoPlayerConfiguration;
  VideoPlayerController videoPlayerController;
  bool autoPlay;
  String url;
  bool fullScreen = false;
  //KinoPlayerEvent event = KinoPlayerEvent(KinoPlayerEventType.SHOW_CONTROLS);



  KinoPlayerController(
      {this.kinoPlayerConfiguration,
      this.videoPlayerController,
      this.autoPlay,
      this.url}) : super(null);

  static KinoPlayerController of(BuildContext context) {
    final kinoPlayerProvider =
        context.inheritFromWidgetOfExactType(KinoPlayerControllerProvider)
            as KinoPlayerControllerProvider;
    return kinoPlayerProvider.controller;
  }


  void setEvent(KinoPlayerEvent kinoPlayerEvent) {
    this.value = kinoPlayerEvent;
    notifyListeners();
  }

  void setFullscreen(bool state) {
    fullScreen = state;
    notifyListeners();
  }

  void forward() {
    Duration currentDuration = videoPlayerController.value.position;
    Duration videoDuration = videoPlayerController.value.duration;
    int currentDurationMs = currentDuration.inMilliseconds;
    int videoDurationMs = videoDuration.inMilliseconds;
    Duration forwardDuration;
    if (currentDurationMs + 10000 <= videoDurationMs) {
      forwardDuration = Duration(milliseconds: currentDurationMs + 10000);
    } else {
      forwardDuration = videoDuration;
    }
    videoPlayerController.seekTo(forwardDuration);
  }


}
