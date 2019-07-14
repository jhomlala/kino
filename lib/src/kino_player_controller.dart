import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'kino_player_controller_provider.dart';

class KinoPlayerController with ChangeNotifier {
  VideoPlayerController videoPlayerController;
  bool autoPlay;
  String url;
  int lastEvent;
  bool fullScreen = false;

  KinoPlayerController({this.videoPlayerController, this.autoPlay, this.url});

  static KinoPlayerController of(BuildContext context){
    final kinoPlayerProvider = context.inheritFromWidgetOfExactType(KinoPlayerControllerProvider) as KinoPlayerControllerProvider;
    return kinoPlayerProvider.controller;
  }

  setLastEvent(int id){
    lastEvent = id;
    notifyListeners();
  }

  setFullscreen(bool state){
    fullScreen = state;
    notifyListeners();
  }


}
