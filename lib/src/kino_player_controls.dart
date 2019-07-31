import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'kino_player_control.dart';
import 'kino_player_controller.dart';
import 'kino_player_event.dart';
import 'kino_player_event_type.dart';

class KinoPlayerControls extends StatefulWidget {
  @override
  _KinoPlayerControlsState createState() => _KinoPlayerControlsState();
}

class _KinoPlayerControlsState extends State<KinoPlayerControls> {
  KinoPlayerController _kinoPlayerController;
  bool controlsState = true;
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
    _kinoPlayerController.setControlsState(true);
    if (_kinoPlayerController.videoPlayerController.value.isPlaying) {
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
       _setControlsShown(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: controlsState ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: AspectRatio(
            aspectRatio: getVideoPlayerController().value.aspectRatio,
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(children: _buildProgressRowWidgets()),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: _buildBottomRowControlWidgets())
                        ])),
                Align(
                    alignment: Alignment.center, child: _getMiddlePlayWidget()),
                Align(alignment: Alignment.topRight, child: _getSettingsWidget(),)
              ],
            )));
  }

  void _onPauseClicked() {
    if (controlsState) {
      print("On pause clicked");
      _cancelTimers();
      getVideoPlayerController().pause();
      _kinoPlayerController.setEvent(KinoPlayerEvent(KinoPlayerEventType.PAUSE));
      setState(() {});
    }
  }

  void _onPlayClicked() {
    if (controlsState) {
      print("On play clicked");
      _setupTimers();
      getVideoPlayerController().play();
      _kinoPlayerController.setEvent(KinoPlayerEvent(KinoPlayerEventType.PLAY));
      setState(() {});
    }
  }

  void _onReplayClicked() {
    _kinoPlayerController.setPositionToStart();
    Timer(Duration(milliseconds: 2000), () {
      _onPlayClicked();
    });
    //_onPlayClicked();
  }

  Widget _getMiddlePlayWidget() {
    if (_kinoPlayerController.isVideoFinished()) {
      return _getControlButton(Icons.replay, () {
        _onReplayClicked();
      }, height: 80, width: 80, iconSize: 60);
    }

    if (!_kinoPlayerController.videoPlayerController.value.isPlaying) {
      return _getControlButton(Icons.play_circle_outline, () {
        _onPlayClicked();
      }, height: 80, width: 80, iconSize: 60);
    }

    return null;
  }

  List<Widget> _buildProgressRowWidgets() {
    List<KinoPlayerControl> controls =
        _kinoPlayerController.kinoPlayerConfiguration.playerControls;
    List<Widget> widgets = List();
    if (controls.contains(KinoPlayerControl.TIME)) {
      widgets.add(_getCurrentTimeWidget());
    }
    if (controls.contains(KinoPlayerControl.PROGRESS)) {
      widgets.add(Padding(
        padding: EdgeInsets.only(left: 10),
      ));
      widgets.add(_getProgressIndicatorWidget());
      widgets.add(Padding(
        padding: EdgeInsets.only(right: 10),
      ));
    }
    if (controls.contains(KinoPlayerControl.TIME)){
      widgets.add(_getVideoDurationWidget());
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

  Widget _getCurrentTimeWidget() {
    return Padding(
        padding: EdgeInsets.all(2),
        child: Text(
          _getCurrentTime(),
          style: TextStyle(color: Colors.blue),
        ));
  }

  Widget _getVideoDurationWidget() {
    return Padding(
        padding: EdgeInsets.all(2),
        child: Text(
          _getVideoDuration(),
          style: TextStyle(color: Colors.blue),
        ));
  }

  Widget _getVolumeWidget() {
    double currentVolumeLevel =
        _kinoPlayerController.videoPlayerController.value.volume;
    print("Current volume level: " + currentVolumeLevel.toString());
    IconData icon = Icons.volume_mute;
    if (currentVolumeLevel == 0.0) {
      icon = Icons.volume_off;
    } else if (currentVolumeLevel < 0.3) {
      icon = Icons.volume_mute;
    } else if (currentVolumeLevel < 0.7) {
      icon = Icons.volume_down;
    } else {
      icon = Icons.volume_up;
    }

    return _getControlButton(icon, () {
      print("Current volume level: " + currentVolumeLevel.toString());
      _kinoPlayerController
          .setEvent(KinoPlayerEvent(KinoPlayerEventType.OPEN_VOLUME_PICKER));
    });
  }

  Widget _getPlayPauseWidget() {
    if (getVideoPlayerController().value.isPlaying) {
      return _getControlButton(Icons.pause, () {
        _onPauseClicked();
      });
    } else {
      return _getControlButton(Icons.play_arrow, () {
        _onPlayClicked();
      });
    }
  }

  _getFullscreenWidget() {
    if (_kinoPlayerController.fullScreen) {
      return _getControlButton(Icons.fullscreen_exit, () {
        _cancelTimers();
        _kinoPlayerController.setFullscreen(false);
        Navigator.of(context).pop();
      });
    } else {
      return _getControlButton(Icons.fullscreen, () {
        _cancelTimers();
        _kinoPlayerController.setFullscreen(true);
        setState(() {});
      });
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
    return _getControlButton(Icons.fast_rewind, () {
      bool timersSet = _areTimersSet();
      if (timersSet) {
        _cancelTimers();
        _kinoPlayerController.rewind();
        _setupTimers();
      } else {
        _kinoPlayerController.rewind();
      }
    });
  }

  bool _areTimersSet() {
    return _hideTimer != null && _timeUpdateTimer != null;
  }

  _getForwardWidget() {
    return _getControlButton(Icons.fast_forward, () {
      bool timersSet = _areTimersSet();
      if (timersSet) {
        _cancelTimers();
        _kinoPlayerController.forward();
        _setupTimers();
      } else {
        _kinoPlayerController.forward();
      }
    });
  }

  _getSkipPreviousWidget() {
    return _getControlButton(Icons.skip_previous, () {
      setState(() {});
    });
  }

  _getSkipNextWidget() {
    return _getControlButton(Icons.skip_next, () {
      setState(() {});
    });
  }

  _getSettingsWidget() {
    return _getControlButton(Icons.settings, () {
      _kinoPlayerController
          .setEvent(KinoPlayerEvent(KinoPlayerEventType.OPEN_SETTINGS));
    });
  }

  String _getCurrentTime() {
    Duration currentDuration = getVideoPlayerController().value.position;

    if (currentDuration != null) {
      return _formatDuration(currentDuration);
    } else {
      return _formatDuration(Duration.zero);
    }
  }

  void _setupTimers() {
    _cancelTimers();

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
        _kinoPlayerController.setEvent(KinoPlayerEvent(KinoPlayerEventType.HIDE_CONTROLS));
        _setControlsShown(false);
      });
    });
  }

  Widget _getControlButton(IconData icon, Function onPressedAction,
      {double height = 30, double width = 30, double iconSize = 25}) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: CircleBorder(),
          child: Container(
              width: width,
              height: height,
              child: Icon(
                icon,
                size: iconSize,
                color: Colors.blue,
              )),
          onTap: () {
            onPressedAction();
          },
        ));
  }

  String _getVideoDuration() {
    Duration videoDuration = getVideoPlayerController().value.duration;
    if (videoDuration != null){
      return _formatDuration(videoDuration);
    } else {
      return _formatDuration(Duration.zero);
    }
  }

  String _formatDuration(Duration duration){
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds - 60 * minutes;
    String secondsFormatted = "$seconds";
    if (seconds < 10) {
      secondsFormatted = "0$secondsFormatted";
    }
    return "$minutes:$secondsFormatted";
  }

  void _setControlsShown(bool state){
    controlsState = state;
    _kinoPlayerController.setControlsState(controlsState);
  }

}
