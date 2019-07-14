import 'package:flutter/material.dart';

import 'kino_fullscreen.dart';
import 'kino_player_controller_provider.dart';

class FullscreenRoute extends PageRoute {
  final KinoPlayerControllerProvider provider;

  FullscreenRoute(this.provider);

  @override
  Color get barrierColor => Colors.black87;

  @override
  String get barrierLabel => "BarrierLabel??";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Scaffold(
              backgroundColor: Colors.black,
              resizeToAvoidBottomPadding: true,
              body: Container(alignment: Alignment.center, child: provider));
        });
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}
