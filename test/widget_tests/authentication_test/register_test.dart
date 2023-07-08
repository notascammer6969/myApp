// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/widgets/authentication/authentication_register.dart';

import 'package:youapp_test/blocs/authentication/bloc_register.dart';

void mockToggle(){}

void main(){
  testWidgets('register form test', (WidgetTester tester) async{
    final UserProfileDatabase mockUserRepo = UserProfileDatabase();
    final email = find.byKey(const ValueKey("registerEmail"));
    final username = find.byKey(const ValueKey("registerUsername"));
    final password = find.byKey(const ValueKey("registerPassword"));
    final confirmPassword = find.byKey(const ValueKey("registerConfirmPassword"));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
            create: (_) => RegisterBloc(userProfileDatabase: mockUserRepo),
            child: const Register(toggleView : mockToggle)
        )
      )
    );
    await tester.enterText(email, "email@gmail.com");
    await tester.enterText(username, "username123");
    await tester.enterText(password, "password");
    await tester.enterText(confirmPassword, "password");
    await tester.pump();

    expect(find.text("email@gmail.com"), findsOneWidget);
    expect(find.text("username123"), findsOneWidget);
    expect(find.text("password"), findsNWidgets(2));
    expect(find.text("password"), findsNWidgets(2));
  });
}