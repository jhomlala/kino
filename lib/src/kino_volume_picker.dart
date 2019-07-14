import 'package:flutter/material.dart';

class KinoVolumePicker extends StatefulWidget {
  final double currentVolume;

  const KinoVolumePicker({ this.currentVolume = 0});

  @override
  _KinoVolumePickerState createState() => _KinoVolumePickerState(currentVolume);
}

class _KinoVolumePickerState extends State<KinoVolumePicker> {
  double _value = 0;

  _KinoVolumePickerState(double startingValue){
    _value = startingValue;
  }

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
                    Text("Volume ${_getFormattedVolume()} %"),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Slider(
                      value: _value,
                      max: 1,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                    Align(alignment: Alignment.topRight,child: FlatButton(
                        child: Text(
                          "Accept",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context, _value);
                        }))
                  ],
                ))));
  }

  String _getFormattedVolume(){
    var volume = _value * 100;
    return volume.floor().toString();
  }
}
