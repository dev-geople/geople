// basic Flutter widget test.
//
// Um, in einem Test, mit einem Widget zu interagieren, wird die WidgetTester
// Utility-Klasse verwendet. Zum Beispiel kann man Tap- und Scrollgesten
// gesendet werden.
// Der Widgettester kann auch Child-Widgets in einem Widget-Tree finden, Texte
// lesen und überprüfen, ob Widgetattribute korrekt sind.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:geople/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Geople());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
