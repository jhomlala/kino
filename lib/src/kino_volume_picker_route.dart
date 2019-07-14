import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'kino_volume_picker.dart';

class KinoVolumePickerRoute extends PopupRoute<double> {

  final double currentVolume;

  KinoVolumePickerRoute(this.currentVolume);

  @override
  Color get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => "BarrierLabel";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return KinoVolumePicker(currentVolume: currentVolume,);
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 500);
}
