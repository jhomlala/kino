import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'kino_configuration.dart';
import 'kino_player_control.dart';
import 'kino_player_controller.dart';
import 'kino_player_controller_provider.dart';

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
    if (_hideTimer != null){
      _hideTimer.cancel();
    }
    if (_timeUpdateTimer != null){
      _timeUpdateTimer.cancel();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _kinoPlayerController = KinoPlayerController.of(context);
    _kinoPlayerController.addListener(_updateListener);
    super.didChangeDependencies();
  }

  VideoPlayerController getVideoPlayerController() {
    return _kinoPlayerController.videoPlayerController;
  }

  void _updateListener() {
    print("Kino player controller updated!");
    if (_kinoPlayerController.lastEvent == 1) {
      setState(() {
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
      widgets.add( Padding(padding: EdgeInsets.only(left: 10),));
      widgets.add(_getProgressIndicatorWidget());
      widgets.add( Padding(padding: EdgeInsets.only(right: 10),));
    }
    if (controls.contains(KinoPlayerControl.TIME)) {
      widgets.add(_getTimeWidget());
    }
    if (widgets.length > 0){
      widgets.insert(0, Padding(padding: EdgeInsets.only(left: 10),));
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
    _getTimeLeft();
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
            _setupHideTimer();
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
          setState(() {
            _kinoPlayerController.setFullscreen(false);
            Navigator.of(context).pop();
            // _setFullscreen();
          });
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
          setState(() {
            setState(() {
              _kinoPlayerController.setFullscreen(true);
            });
            // _setFullscreen();
          });
        },
      );
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
        setState(() {});
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
    Duration currentDuration = getVideoPlayerController().value.position;
    Duration videoDuration = getVideoPlayerController().value.duration;
    print("Current duration: " + currentDuration.toString());
    print("Video duration: " + videoDuration.toString());
    if (currentDuration != null && videoDuration != null) {
      Duration remainingDuration = videoDuration - currentDuration;
      print("remaining: " + remainingDuration.inSeconds.toString());
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

  void _setupHideTimer() {
    _timeUpdateTimer =
        Timer.periodic(Duration(milliseconds: 900), (Timer timer) {
          if (this.mounted){
            print("Moundted");
            setState(() {});
          } else {
            print("Not mounted");
          }
    });
    _hideTimer = Timer(Duration(milliseconds: 10000), () {
      setState(() {
        _timeUpdateTimer.cancel();
        _timeUpdateTimer = null;
        _hideControlls = true;
      });
    });
  }
}
