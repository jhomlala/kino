import 'dart:collection';

import 'kino_player_event_type.dart';

class KinoPlayerEvent {
  final KinoPlayerEventType eventType;
  final DateTime created = DateTime.now();
  final Map<String, dynamic> data;

  KinoPlayerEvent(this.eventType, {this.data = const {}});
}
