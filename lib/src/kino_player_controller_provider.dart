import 'package:flutter/material.dart';

import 'kino_player_controller.dart';

class KinoPlayerControllerProvider extends InheritedWidget {
  final KinoPlayerController controller;
  final Widget child;

  KinoPlayerControllerProvider({this.controller, this.child})
      : super( child: child);

  @override
  bool updateShouldNotify(KinoPlayerControllerProvider oldWidget) {
   return controller != oldWidget.controller;
  }
}
