import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _sliderValue = 1.0;

  @override
  void initState() {
    SharedPreferences.getInstance().then((pref) {
      int value = pref.getInt("Radius");
      if (value != null) {
        setState(() {
          _sliderValue = (value).toDouble();
        });
      }
    });
    super.initState();
  }

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
            Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Radius',
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.title,
                          ),
                          Text(
                            '${_sliderValue.toInt()} km',
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.title,
                          )
                        ],
                      ),
                    ),
                    Slider(
                      activeColor: Colors.indigoAccent,
                      min: 1.0,
                      max: 10.0,
                      onChanged: (newRadius) async {
                        setState(() => _sliderValue = newRadius);
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setInt("Radius", newRadius.toInt());
                      },
                      value: _sliderValue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
