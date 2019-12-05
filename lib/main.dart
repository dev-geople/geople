import 'package:flutter/material.dart';
import 'package:geople/router.dart' as router;
import 'package:geople/screens/home/index.dart';
import 'package:geople/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geople/screens/sign_in/index.dart';
import 'package:geople/services/authentication.dart';

import 'assets/theme_main.dart';

Widget _defaultHome = LoginScreen();

Future main() async {
  Auth _auth = Auth();
  // Get result of the login function.
  bool _result = ((await _auth.getCurrentUser()) != null);
  if (_result) {
    _defaultHome = new HomeScreen();
  }

  runApp(Geople());
}

/// Dieses Widget ist der Stamm (root) der App.
class Geople extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      showSemanticsDebugger: false,
      title: 'Geople',
      theme: lightTheme,
      onGenerateRoute: router.generateRoute,
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
          if (locale != null &&
              (supportedLocale.languageCode == locale.languageCode)) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      home: _defaultHome,
    );
  }
}
