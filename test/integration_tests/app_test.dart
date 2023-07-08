// ignore_for_file: avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:youapp_test/main.dart' as app;
import 'package:youapp_test/screens/profile.dart';


// function for tapping the richText children
void fireOnTap(Finder finder, String text) {
  final Element element = finder.evaluate().single;
  final RenderParagraph paragraph = element.renderObject as RenderParagraph;
  // The children are the individual TextSpans which have GestureRecognizers
  paragraph.text.visitChildren((dynamic span) {
    if (span.text != text) return true; // continue iterating.

    (span.recognizer as TapGestureRecognizer).onTap!();
    return false; // stop iterating, we found the one.
  });
}

// check if snackBar shows up
bool isSnackBarShowing(WidgetTester tester, Key key) {
  final snackBarFinder = find.byKey(key);
  return tester.widgetList(snackBarFinder).isNotEmpty;
}

// get snackBar text
String getSnackBarText(WidgetTester tester, Key key) {
  final snackBarFinder = find.byKey(key);
  final snackBarWidgets = tester.widgetList(snackBarFinder);
  final snackBar = snackBarWidgets.first as SnackBar;
  return (snackBar.content as Text).data ?? '';
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {
  testWidgets('Test whole app: register > login > profile',
    (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final profileFinder = find.byType(Profile);
      if (profileFinder.evaluate().isNotEmpty) {
        print('currently logged in');
        await tester.tap(find.byKey(const ValueKey("logout")));
      }
      // cred/new data for register and login
      const String email = 'user@gmail.com';
      const String username = 'userTest';
      const String password = 'userTest';
      const String confirmPassword = 'userTest';

      print('================= register new user');
      final richTextRegHere = find.byKey(const Key('registerHere')).first;
      fireOnTap(richTextRegHere, 'Register here');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey("registerEmail")), email);
      await tester.enterText(find.byKey(const ValueKey("registerUsername")), username);
      await tester.enterText(find.byKey(const ValueKey("registerPassword")), password);
      await tester.enterText(find.byKey(const ValueKey("registerConfirmPassword")), confirmPassword);
      await tester.tap(find.byKey(const ValueKey("registerButton")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      expect(isSnackBarShowing(tester, const Key('registerNotification')), true);
      expect(getSnackBarText(tester, const Key('registerNotification')), 'register success');

      print('================= login registered user');
      final richTextLogHere = find.byKey(const Key('loginHere')).first;
      fireOnTap(richTextLogHere, 'Login here');
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey("loginUsername")), username);
      await tester.enterText(find.byKey(const ValueKey("loginPassword")), password);
      await tester.tap(find.byKey(const ValueKey("loginButton")));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      expect(isSnackBarShowing(tester, const Key('loginNotification')), true);
      expect(getSnackBarText(tester, const Key('loginNotification')), 'login success');
      await tester.pumpAndSettle();

      print('================= expecting profile page');
      expect(find.byType(Profile), findsOneWidget);
    });
  });

}