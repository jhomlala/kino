import 'dart:io';

import 'kino_subtitle.dart';

class KinoUtils {
  static Duration extractDurationFromSrtTime(String srtTime) {
    List<String> srtFirstSplit = srtTime.split(",");
    if (srtFirstSplit.length == 2) {
      List<String> srtSecondSplit = srtFirstSplit[0].split(":");
      if (srtSecondSplit.length == 3) {
        int hours = int.parse(srtSecondSplit[0]);
        int minutes = int.parse(srtSecondSplit[1]);
        int seconds = int.parse(srtSecondSplit[2]);
        int milliseconds = int.parse(srtFirstSplit[1]);

        return Duration(
            milliseconds: 60 * 60 * 1000 * hours +
                60 * 1000 * minutes +
                seconds * 1000 +
                milliseconds);
      }
    }
    return Duration.zero;
  }

  static Future<List<KinoSubtitle>> parseSubtitles(String filePath) async {
    File file = File(filePath);
    List<KinoSubtitle> kinoSubtitles = List();
    int count = 0;
    String currentId;
    String currentDurationLine;
    List<String> subtitles = List();





    await file.readAsLines().then((value) => value.forEach((String line) {
          if (count == 0) {
            currentId = line;
          } else if (count == 1 && line.contains("-->")) {
            currentDurationLine = line;
          } else {
            subtitles.add(line);
          }

          if (line.trim().isEmpty) {
            if (currentId != null && currentId.length > 0) {
              KinoSubtitle kinoSubtitle =
                  _getKinoSubtitle(currentId, currentDurationLine, subtitles);
              if (kinoSubtitle != null) {
                kinoSubtitles.add(kinoSubtitle);
                print("Added kinosubtitle: " + kinoSubtitle.toString());
              }
            }
            count = 0;
            currentId = "";
            currentDurationLine = "";
            subtitles = List();
          } else {
            count++;
          }
        }));

    print("Here finishing!!");
    return kinoSubtitles;
  }

  static KinoSubtitle _getKinoSubtitle(
      String idLine, String durationLine, List<String> subtitles) {
    int id = 0;
    if (idLine.trim().isNotEmpty) {
      id = int.parse(idLine);
    }
    List<String> durationSplit = durationLine.split("-->");
    if (durationSplit != null && durationSplit.length == 2) {
      String startDurationRaw = durationSplit[0].trim();
      String endDurationRaw = durationSplit[1].trim();

      Duration startDuration =
          KinoUtils.extractDurationFromSrtTime(startDurationRaw);
      Duration endDuration =
          KinoUtils.extractDurationFromSrtTime(endDurationRaw);
      return KinoSubtitle(id, startDuration, endDuration, subtitles);
    }

    return null;
  }
}
