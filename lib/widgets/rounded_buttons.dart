import 'package:flutter/material.dart';
import 'package:geople/app_localizations.dart';

class RoundedButtonPrimary extends StatelessWidget {
  RoundedButtonPrimary({this.translatorKey, this.onPressed});

  final String translatorKey;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: SizedBox(
        height: 45,
        width: double.infinity,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: this.onPressed,
          child:
              Text(AppLocalizations.of(context).translate(this.translatorKey)??''),
        ),
      ),
    );
  }
}

class RoundedButtonSecondary extends StatelessWidget {
  RoundedButtonSecondary({this.translatorKey, this.onPressed});

  final String translatorKey;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: SizedBox(
        height: 45,
        width: double.infinity,
        child: OutlineButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: this.onPressed,
          child: Text(
            AppLocalizations.of(context).translate(this.translatorKey)??'',
          ),
        ),
      ),
    );
  }
}
