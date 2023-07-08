// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/widgets/profile/profile_about_edit.dart';


void mockToggle(){}

void main(){
  testWidgets('register form test', (WidgetTester tester) async{
    final ModelUser mockUser = ModelUser(
      email: '',
      username: '',
      password: '',
      profile: ModelUserProfile(
        image : '',
        displayName: '',
        gender: '',
        birthday: '',
        horoscope: '',
        zodiac: '',
        height: '',
        weight: '',
        interest: []
      )
    );
    final displayName = find.byKey(const ValueKey("profileEditDN"));
    final height = find.byKey(const ValueKey("profileEditHeight"));
    final weight = find.byKey(const ValueKey("profileEditWeight"));

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileAboutEdit(toggleEdit: mockToggle, user: mockUser)
      )
    );
    await tester.enterText(displayName, "name to display");
    await tester.enterText(height, "200m");
    await tester.enterText(weight, "100kg");
    await tester.pump();

    expect(find.text("name to display"), findsOneWidget);
    expect(find.text("200m"), findsOneWidget);
    expect(find.text("100kg"), findsNWidgets(2));

  });
}