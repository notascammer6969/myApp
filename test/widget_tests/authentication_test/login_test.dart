// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/widgets/authentication/authentication_login.dart';

import 'package:youapp_test/blocs/authentication/bloc_login.dart';

void mockToggle(){}

void main(){
  testWidgets('login form test', (WidgetTester tester) async{
    final UserProfileDatabase mockUserRepo = UserProfileDatabase();
    final username = find.byKey(const ValueKey("loginUsername"));
    final password = find.byKey(const ValueKey("loginPassword"));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
            create: (_) => LoginBloc(userProfileDatabase: mockUserRepo),
            child: const Login(toggleView : mockToggle)
        )
      )
    );
    await tester.enterText(username, "enteredUsername");
    await tester.enterText(password, "enteredPassword");
    // await tester.tap(button);
    await tester.pump(); //rebuilds widget

    expect(find.text("enteredUsername"), findsOneWidget);
    expect(find.text("enteredPassword"), findsOneWidget);
  });
}