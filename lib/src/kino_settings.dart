import 'package:flutter/material.dart';

class KinoSettings extends StatefulWidget {
  @override
  _KinoSettingsState createState() => _KinoSettingsState();
}

class _KinoSettingsState extends State<KinoSettings> {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
            dialogBackgroundColor: Colors.black87,
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            )),
        child: Dialog(
            child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   Text("Test")
                  ],
                ))));
  }
}
