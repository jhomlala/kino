import 'dart:async';

import 'package:flutter/material.dart';

import 'kino_player_controller.dart';
import 'kino_player_event_type.dart';
import 'kino_subtitle.dart';

class KinoSubtitles extends StatefulWidget {
  @override
  _KinoSubtitlesState createState() => _KinoSubtitlesState();
}

class _KinoSubtitlesState extends State<KinoSubtitles> {
  KinoPlayerController _kinoPlayerController;
  Timer _updateTimer;
  KinoSubtitle currentSubtitle;
  List<KinoSubtitle> subtitles;

  @override
  void didChangeDependencies() {
    _kinoPlayerController = KinoPlayerController.of(context);
    _kinoPlayerController.addListener(_updateListener);
    print("Kino player controller init in subtitles");
    super.didChangeDependencies();
  }

  void _updateListener() {
    print("Kino player controller updated!");
    var event = _kinoPlayerController.value;
    print("Eventttt:" + event.toString());
    if (event.eventType == KinoPlayerEventType.PLAY) {
      _startTimer();
    }
    if (event.eventType == KinoPlayerEventType.PAUSE) {
      _cancelTimer();
    }
    if (event.eventType == KinoPlayerEventType.SHOW_CONTROLS) {
      _cancelTimer();
    }
    if (event.eventType == KinoPlayerEventType.SUBTITLES_LOADED) {
      print("Subtitles ready");
      subtitles = _kinoPlayerController.kinoSubtitles;
    }
  }

  void _startTimer() {
    print("Start timer!!!");
    _updateTimer = Timer.periodic(Duration(milliseconds: 100), _updateSubtitle);
  }

  void _cancelTimer() {
    print("Cancel timer!!");
    if (_updateTimer != null) {
      _updateTimer.cancel();
      print("Cancelled");
      _updateTimer = null;
    }
  }

  void _updateSubtitle(Timer timer) async {
    Duration currentVideoDuration =
    await _kinoPlayerController.videoPlayerController.position;
    if (currentSubtitle == null) {
      setState(() {
        currentSubtitle = _getSubtitle(currentVideoDuration);
      });
      if (currentSubtitle == null){
        print("no subtitle to show");
        return;
      }
    } else {
      if (!(currentSubtitle.startTime <= currentVideoDuration &&
      currentVideoDuration <= currentSubtitle.endTime)){
        setState(() {
          currentSubtitle = _getSubtitle(currentVideoDuration);
        });

      }
    }

    print("TIME: " + currentVideoDuration.toString() + " subtitle: " + currentSubtitle.toString());

  }

  KinoSubtitle _getSubtitle(Duration currentVideoDuration) {
    for (var subtitle in subtitles) {
      if (subtitle.startTime >= currentVideoDuration){
        continue;
      }
      //00:07

      //00:05
      //00:10
      if (subtitle.startTime <= currentVideoDuration &&
          currentVideoDuration <= subtitle.endTime) {
        return subtitle;
      }
    }
    return null;
  }

  String _getCurrentSubtitleText(){
    if (currentSubtitle != null){
      return currentSubtitle.subtitles.toString();
    }else{
      return "";
    }
  }

    @override
    Widget build(BuildContext context) {
      return Container(
        child: Text(
          _getCurrentSubtitleText(),
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
