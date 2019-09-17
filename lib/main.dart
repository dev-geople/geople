import 'package:flutter/material.dart';
import 'package:geople/screens/home/index.dart';
import 'package:geople/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() => runApp(Geople());

/// Dieses Widget ist der Stamm (root) der App.
class Geople extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      title: 'Geople',
      theme: ThemeData(
        // Todo: primarySwatch erstellen (Theming)
        primaryColor: Colors.white, // Das 'Theme' der App.
      ),
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', ''),
        Locale('de', ''),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (locale != null && (supportedLocale.languageCode == locale.languageCode)) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: HomeScreen(),
    );
  }
}
