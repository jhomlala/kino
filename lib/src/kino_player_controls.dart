import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'kino_player_controller.dart';
import 'kino_player_controller_provider.dart';

class KinoPlayerControls extends StatefulWidget {
  @override
  _KinoPlayerControlsState createState() => _KinoPlayerControlsState();
}

class _KinoPlayerControlsState extends State<KinoPlayerControls> {

  KinoPlayerController _kinoPlayerController;
  bool _hideControlls = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies(){
    _kinoPlayerController = KinoPlayerController.of(context);
    _kinoPlayerController.addListener(_updateListener);
    super.didChangeDependencies();
  }

  VideoPlayerController getVideoPlayerController() {
    return _kinoPlayerController.videoPlayerController;
  }

  void _updateListener(){
    print("Kino player controller updated!");
    if (_kinoPlayerController.lastEvent == 1){
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
                child: Row(
                  children: [
                    _getPlayPauseWidget(),
                    _getVolumeWidget(),
                    Expanded(
                        child: VideoProgressIndicator(
                          getVideoPlayerController(),
                          allowScrubbing: true,
                        )),
                    _getTimeWidget(),
                    _getFullscreenWidget()
                  ],
                ))));
  }

  Widget _getTimeWidget() {
    return Text(
      "-0:25",
      style: TextStyle(color: Colors.blue),
    );
  }

  Widget _getVolumeWidget() {
    return InkWell(
      child: Icon(
        Icons.volume_up,
        color: Colors.blue,
      ),
      onTap: () {
        //_showVolumePicker();
        //Navigator.push(context, new KinoVolumePickerRoute());
      },
    );
  }

  Widget _getPlayPauseWidget() {
    if (getVideoPlayerController().value.isPlaying) {
      return InkWell(
        child: Icon(
          Icons.pause,
          color: Colors.blue,
        ),
        onTap: () {
          setState(() {
            getVideoPlayerController().pause();
          });
        },
      );
    } else {
      return InkWell(
        child: Icon(
          Icons.play_arrow,
          color: Colors.blue,
        ),
        onTap: () {
          setState(() {
            _hideControlls = true;
            getVideoPlayerController().play();
          });
        },
      );
    }
  }

  _getFullscreenWidget() {
    if (_kinoPlayerController.fullScreen){
      return InkWell(
        child: Icon(
          Icons.fullscreen_exit,
          color: Colors.blue,
        ),
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
        child: Icon(
          Icons.fullscreen,
          color: Colors.blue,
        ),
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
}
