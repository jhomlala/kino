class KinoSubtitle{
  final int id;
  final Duration startTime;
  final Duration endTime;
  final List<String> subtitles;

  KinoSubtitle(this.id, this.startTime, this.endTime, this.subtitles);

  @override
  String toString() {
    return 'KinoSubtitle{id: $id, startTime: $startTime, endTime: $endTime, subtitles: $subtitles}';
  }


}