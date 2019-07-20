import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'kino_fullscreen_route.dart';
import 'kino_player_controller.dart';
import 'kino_player_controller_provider.dart';
import 'kino_player_controls.dart';
import 'kino_player_event.dart';
import 'kino_player_event_type.dart';
import 'kino_settings_route.dart';
import 'kino_volume_picker_route.dart';

class KinoPlayer extends StatefulWidget {
  const KinoPlayer({Key key, this.kinoPlayerController}) : super(key: key);

  @override
  _KinoPlayerState createState() => _KinoPlayerState();

  final KinoPlayerController kinoPlayerController;
}

class _KinoPlayerState extends State<KinoPlayer>
    with SingleTickerProviderStateMixin {
  bool _fullScreen = false;

  @override
  void initState() {
    print("Url: " + widget.kinoPlayerController.url);
    var _controller =
        VideoPlayerController.network(widget.kinoPlayerController.url)
          ..initialize().then((_) {
            setState(() {});
          });
    widget.kinoPlayerController.videoPlayerController = _controller;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    widget.kinoPlayerController.addListener(_updateListener);
    super.didChangeDependencies();
  }

  void _updateListener() {
    print("Update listener!!!");
    var event = widget.kinoPlayerController.value;

    if (event != null) {
      if (event.eventType == KinoPlayerEventType.OPEN_VOLUME_PICKER) {
        print("Show volume picker " + hashCode.toString());
        _showVolumePicker();
      }
      if (event.eventType == KinoPlayerEventType.OPEN_SETTINGS) {
        _showSettings();
      }
    }

    if (widget.kinoPlayerController.fullScreen && !_fullScreen) {
      print("Show full screen");
      _fullScreen = true;
      _setFullscreen();
    }
  }

  @override
  void didUpdateWidget(KinoPlayer oldWidget) {
    if (oldWidget.kinoPlayerController != widget.kinoPlayerController) {
      print("Did update widget is treue!!!");
      //widget.controller.addListener(listener);
    }
    super.didUpdateWidget(oldWidget);
  }

  VideoPlayerController getVideoPlayerController() {
    return widget.kinoPlayerController.videoPlayerController;
  }

  void _onPlayerClicked() {
    print("On Player clicked!!!");

    print(
        "is playing? " + getVideoPlayerController().value.isPlaying.toString());

    if (getVideoPlayerController().value.isPlaying ||
        widget.kinoPlayerController.isVideoFinished()) {
      widget.kinoPlayerController
          .setEvent(KinoPlayerEvent(KinoPlayerEventType.SHOW_CONTROLS));
      print("Pausing!");
      getVideoPlayerController().pause();
    } else {
      print("Not pausing??");
    }
  }

  @override
  Widget build(BuildContext context) {
    return KinoPlayerControllerProvider(
        controller: widget.kinoPlayerController,
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.orange,
            ),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Center(
                  child: Container(
                      child: GestureDetector(
                onTap: () {
                  _onPlayerClicked();
                },
                child: Stack(children: _getPlayerWidgets()),
              ))),
            )));
  }

  List<Widget> _getPlayerWidgets() {
    var list = List<Widget>();
    if (getVideoPlayerController().value.initialized) {
      list.add(AspectRatio(
        aspectRatio: getVideoPlayerController().value.aspectRatio,
        child: VideoPlayer(getVideoPlayerController()),
      ));
    } else {
      list.add(Container(child: CircularProgressIndicator()));
    }
    list.add(KinoPlayerControls());

    return list;
  }

  void _showVolumePicker() async {
    bool isPlaying =
        widget.kinoPlayerController.videoPlayerController.value.isPlaying;

    if (isPlaying) {
      await getVideoPlayerController().pause();
    }
    final double result = await Navigator.push(context,
        KinoVolumePickerRoute(getVideoPlayerController().value.volume));

    if (isPlaying) {
      await getVideoPlayerController().play();
    }

    if (result != null) {
      getVideoPlayerController().setVolume(result);
      setState(() {});
    }
  }

  double _calculateAspectRatio(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return width > height ? width / height : height / width;
  }

  void _setFullscreen() async {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    var provider = KinoPlayerControllerProvider(
        controller: widget.kinoPlayerController,
        child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.black,
            ),
            child: AspectRatio(
              aspectRatio: _calculateAspectRatio(context),
              child: Center(
                  child: Container(
                      child: GestureDetector(
                onTap: () {
                  _onPlayerClicked();
                },
                child: Stack(children: _getPlayerWidgets()),
              ))),
            )));

    await Navigator.of(context).push(FullscreenRoute(provider));

    setState(() {
      widget.kinoPlayerController.fullScreen = false;
      _fullScreen = false;
    });

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _showSettings() async {
    await Navigator.push(context, KinoSettingsRoute());
  }
}
