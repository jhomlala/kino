import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'kino_configuration.dart';
import 'kino_player_control.dart';
import 'kino_player_controller.dart';
import 'kino_player_controller_provider.dart';
import 'kino_player_event.dart';
import 'kino_player_event_type.dart';

class KinoPlayerControls extends StatefulWidget {
  @override
  _KinoPlayerControlsState createState() => _KinoPlayerControlsState();
}

class _KinoPlayerControlsState extends State<KinoPlayerControls> {
  KinoPlayerController _kinoPlayerController;
  bool _hideControlls = false;
  Timer _hideTimer;
  Timer _timeUpdateTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print("DID CHANGE DEPS!!!");
    _kinoPlayerController = KinoPlayerController.of(context);
    _kinoPlayerController.addListener(_updateListener);
    if (_kinoPlayerController.videoPlayerController.value.isPlaying ) {
      print("Setup hide timer");
       _setupTimers();
    }
    super.didChangeDependencies();
  }

  VideoPlayerController getVideoPlayerController() {
    return _kinoPlayerController.videoPlayerController;
  }

  void _updateListener() {
    print("Kino player controller updated!");
    var event = _kinoPlayerController.value;
    if (event != null && event.eventType == KinoPlayerEventType.SHOW_CONTROLS) {
      _cancelTimers();
      setState(() {
        print("Show controls");
        _hideControlls = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: _hideControlls ? 0.0 : 1.0,
        duration: Duration(milliseconds: 500),
        child: AspectRatio(
            aspectRatio: getVideoPlayerController().value.aspectRatio,
            child: Align(
                alignment: Alignment.bottomCenter,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(children: _buildProgressRowWidgets()),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildBottomRowControlWidgets())
                ]))));
  }

  List<Widget> _buildProgressRowWidgets() {
    List<KinoPlayerControl> controls =
        _kinoPlayerController.kinoPlayerConfiguration.playerControls;
    List<Widget> widgets = List();
    if (controls.contains(KinoPlayerControl.PROGRESS)) {
      widgets.add(Padding(
        padding: EdgeInsets.only(left: 10),
      ));
      widgets.add(_getProgressIndicatorWidget());
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 10),
      ));
    }
    if (controls.contains(KinoPlayerControl.TIME)) {
      widgets.add(_getTimeWidget());
    }
    if (widgets.length > 0) {
      widgets.insert(
          0,
          Padding(
            padding: EdgeInsets.only(left: 10),
          ));
    }

    return widgets;
  }

  List<Widget> _buildBottomRowControlWidgets() {
    List<KinoPlayerControl> controls =
        _kinoPlayerController.kinoPlayerConfiguration.playerControls;
    List<Widget> widgets = List();
    if (controls.contains(KinoPlayerControl.VOLUME)) {
      widgets.add(_getVolumeWidget());
    }
    if (controls.contains(KinoPlayerControl.SKIP_PREVIOUS)) {
      widgets.add(_getSkipPreviousWidget());
    }
    if (controls.contains(KinoPlayerControl.REWIND)) {
      widgets.add(_getRewindWidget());
    }

    if (controls.contains(KinoPlayerControl.PLAY_AND_PAUSE)) {
      widgets.add(_getPlayPauseWidget());
    }
    if (controls.contains(KinoPlayerControl.FORWARD)) {
      widgets.add(_getForwardWidget());
    }
    if (controls.contains(KinoPlayerControl.SKIP_NEXT)) {
      widgets.add(_getSkipNextWidget());
    }
    if (controls.contains(KinoPlayerControl.FULLSCREEN)) {
      widgets.add(_getFullscreenWidget());
    }

    return widgets;
  }

  Widget _getProgressIndicatorWidget() {
    return Expanded(
        child: VideoProgressIndicator(
      getVideoPlayerController(),
      allowScrubbing: true,
    ));
  }

  Widget _getTimeWidget() {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          _getTimeLeft(),
          style: TextStyle(color: Colors.blue),
        ));
  }

  Widget _getVolumeWidget() {
    return InkWell(
      child: Padding(
          padding: EdgeInsets.all(5),
          child: Icon(
            Icons.volume_up,
            color: Colors.blue,
          )),
      onTap: () {
        _kinoPlayerController
            .setEvent(KinoPlayerEvent(KinoPlayerEventType.OPEN_VOLUME_PICKER));
        //_showVolumePicker();
        //Navigator.push(context, new KinoVolumePickerRoute());
      },
    );
  }

  Widget _getPlayPauseWidget() {
    if (getVideoPlayerController().value.isPlaying) {
      return InkWell(
        child: Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.pause,
              color: Colors.blue,
            )),
        onTap: () {
          setState(() {
            getVideoPlayerController().pause();
          });
        },
      );
    } else {
      return InkWell(
        child: Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.play_arrow,
              color: Colors.blue,
            )),
        onTap: () {
          setState(() {
            //_hideControlls = true;
            _setupTimers();
            getVideoPlayerController().play();
          });
        },
      );
    }
  }

  _getFullscreenWidget() {
    if (_kinoPlayerController.fullScreen) {
      return InkWell(
        child: Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.fullscreen_exit,
              color: Colors.blue,
            )),
        onTap: () {
          _cancelTimers();
          _kinoPlayerController.setFullscreen(false);
          Navigator.of(context).pop();
        },
      );
    } else {
      return InkWell(
        child: Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.fullscreen,
              color: Colors.blue,
            )),
        onTap: () {
          _cancelTimers();
          _kinoPlayerController.setFullscreen(true);
          setState(() {});
        },
      );
    }
  }

  _cancelTimers() {
    print("Cancel timers");
    if (_timeUpdateTimer != null && _timeUpdateTimer.isActive) {
      print("Time update timer cancelled");
      _timeUpdateTimer.cancel();
      _timeUpdateTimer = null;
    }
    if (_hideTimer != null && _hideTimer.isActive) {
      print("Hide timer cancelled");
      _hideTimer.cancel();
      _hideTimer = null;
    }
  }

  _getRewindWidget() {
    return InkWell(
      child: Icon(
        Icons.fast_rewind,
        color: Colors.blue,
      ),
      onTap: () {
        setState(() {});
      },
    );
  }

  _getForwardWidget() {
    return InkWell(
      child: Icon(
        Icons.fast_forward,
        color: Colors.blue,
      ),
      onTap: () {
        setState(() {
          _kinoPlayerController.forward();
        });
      },
    );
  }

  _getSkipPreviousWidget() {
    return InkWell(
      child: Icon(
        Icons.skip_previous,
        color: Colors.blue,
      ),
      onTap: () {
        setState(() {});
      },
    );
  }

  _getSkipNextWidget() {
    return InkWell(
      child: Icon(
        Icons.skip_next,
        color: Colors.blue,
      ),
      onTap: () {
        setState(() {});
      },
    );
  }

  _getSettingsWidget() {
    return InkWell(
      child: Icon(
        Icons.settings,
        color: Colors.blue,
      ),
      onTap: () {
        setState(() {});
      },
    );
  }

  String _getTimeLeft() {
    print("GET TIME LEFT!!");
    Duration currentDuration = getVideoPlayerController().value.position;
    Duration videoDuration = getVideoPlayerController().value.duration;
    if (currentDuration != null && videoDuration != null) {
      Duration remainingDuration = videoDuration - currentDuration;
      int minutes = remainingDuration.inMinutes;
      int seconds = remainingDuration.inSeconds - 60 * minutes;
      String secondsFormatted = "$seconds";
      if (seconds < 10) {
        secondsFormatted = "0$secondsFormatted";
      }
      return "-$minutes:$secondsFormatted";
    }

    return "-0:00";
  }

  void _setupTimers() {
    _timeUpdateTimer =
        Timer.periodic(Duration(milliseconds: 900), (Timer timer) {
      print("TIMER INVOKED FROM " + hashCode.toString());

      if (this.mounted && timer.isActive) {
        print("Refresh state!");
        setState(() {});
      } else {
        print("Not mounted and not active");
      }
    });
    _hideTimer = Timer(Duration(milliseconds: 5000), () {
      print("HIDE HIDE HIDE HIDE!!!");
      _cancelTimers();
      setState(() {
        _hideControlls = true;
      });
    });
  }
}
