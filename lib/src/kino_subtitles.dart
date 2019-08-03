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
  bool _showControls = true;

  @override
  void didChangeDependencies() {
    _kinoPlayerController = KinoPlayerController.of(context);
    _kinoPlayerController.addListener(_updateListener);
    subtitles = _kinoPlayerController.kinoSubtitles;
    if (subtitles != null) {
      _startTimer();
    }
    print("Kino player controller init in subtitles");
    //setShownControls(_kinoPlayerController.controlsState);
    // _showControls = _kinoPlayerController.controlsState;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    print("DISPOSE CALLLLED!!!!");
    _cancelTimer();
    super.dispose();
  }

  void _updateListener() {
    print("Kino player controller updated!");
    var event = _kinoPlayerController.value;
    print("Eventttt:" + event.toString());
    if (event == null){
      return;
    }
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
    if (event.eventType == KinoPlayerEventType.SHOW_CONTROLS) {
      print("KINO_SUBTITLES : Show controlls");
      setState(() {
        setShownControls(true);
        //_showControls = true;
      });
    }
    if (event.eventType == KinoPlayerEventType.HIDE_CONTROLS) {
      print("KINO_SUBTITLES : Show controlls");
      setState(() {
        setShownControls(false);
        //_showControls = false;
      });
    }
  }

  void _startTimer() {
    if (subtitles == null || subtitles.isEmpty){
      return;
    }
    print("Start timer!!!");
    _cancelTimer();
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
    if (!this.mounted) {
      return;
    }
    Duration currentVideoDuration =
        await _kinoPlayerController.videoPlayerController.position;
    if (currentSubtitle == null) {
      var newSubtitle = _getSubtitle(currentVideoDuration);
      if (newSubtitle != null) {
        setState(() {
          print("Get new subtitle!!");
          currentSubtitle = newSubtitle;
        });
      }
      if (currentSubtitle == null) {
        //print("no subtitle to show");
        return;
      }
    } else {
      if (!(currentSubtitle.startTime <= currentVideoDuration &&
          currentVideoDuration <= currentSubtitle.endTime)) {
        setState(() {
          print("Get new subtitle because time left!");
          currentSubtitle = _getSubtitle(currentVideoDuration);
        });
      }
    }

    /*print("TIME: " +
        currentVideoDuration.toString() +
        " subtitle: " +
        currentSubtitle.toString());*/
  }

  KinoSubtitle _getSubtitle(Duration currentVideoDuration) {
    for (var subtitle in subtitles) {
      if (subtitle.startTime >= currentVideoDuration) {
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

  List<Widget> _getCurrentSubtitleTexts() {
    List widgets = List<Widget>();
    if (currentSubtitle != null && currentSubtitle.subtitles.length > 0) {
      currentSubtitle.subtitles.forEach((subtitle) {
        widgets.add(Text(subtitle,
            style: TextStyle(
                color: Colors.white,
                fontSize: _kinoPlayerController.fullScreen ? 24.0 : 14.0)));
      });
    }
    return widgets;
  }

  setShownControls(bool state) {
    print("!!!CONTROLS STATE " + state.toString());
    _showControls = state;
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD WITH CONTROLS: " + _showControls.toString());
    return AspectRatio(
        aspectRatio:
            _kinoPlayerController.videoPlayerController.value.aspectRatio,
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeInsets.only(bottom: _showControls ? 35 : 5),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _getCurrentSubtitleTexts()))));
  }
}
