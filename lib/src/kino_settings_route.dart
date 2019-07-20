import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'kino_settings.dart';
import 'kino_volume_picker.dart';

class KinoSettingsRoute extends PopupRoute<void> {
  @override
  Color get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => "BarrierLabel";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return KinoSettings();
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 500);
}
