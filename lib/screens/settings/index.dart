
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SettingsScreen extends StatefulWidget {
  static final INITIAL_ZOOM = 11.0;
  static final INITIAL_POSITION = LatLng(46.948, 7.44744); //Bern

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _sliderValue = 10.0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Radius', textAlign: TextAlign.left),
          Slider(
          activeColor: Colors.indigoAccent,
            min: 0.0,
            max: 50000000.0,
            onChanged: (newRating) {
              setState(() => _sliderValue = newRating);
            },
            value: _sliderValue,
          ),
              Text('${_sliderValue.toInt()} m')
            ],
          )
      ),
    );
  }
}
