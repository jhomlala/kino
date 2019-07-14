import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'kino_fullscreen_route.dart';
import 'kino_player_controller.dart';
import 'kino_player_controller_provider.dart';
import 'kino_player_controls.dart';
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
    if (widget.kinoPlayerController.fullScreen && !_fullScreen) {
      print("Show full screen");
      _fullScreen = true;
      _setFullscreen();
    } else {}
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
    if (getVideoPlayerController().value.isPlaying) {
      print("Pausing!");
      setState(() {
        //_hideControlls = false;
        getVideoPlayerController().pause();
        widget.kinoPlayerController.setLastEvent(1);
      });
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

    list.add((AspectRatio(
        aspectRatio: getVideoPlayerController().value.aspectRatio,
        child: Align(
          alignment: Alignment.topRight,
          child: _getSettingsWidget(),
        ))));

    /* list.add(VideoProgressIndicator(
      _controller,
      allowScrubbing: true,
    ));*/

    /* list.add(Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: <Widget>[
            FlatButton(
              child: Text("Play"),
              onPressed: () {
                _controller.play();
              },
            ),
            FlatButton(
              child: Text("Pause"),
              onPressed: () {
                //_controller.pause();
              },
            )
          ],
        )));*/

    return list;
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

  void _showVolumePicker() async {
    final double result = await Navigator.push(context,
        KinoVolumePickerRoute(getVideoPlayerController().value.volume));
    if (result != null) {
      getVideoPlayerController().setVolume(result);
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
}
