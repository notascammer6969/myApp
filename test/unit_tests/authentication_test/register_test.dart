// ignore_for_file: avoid_print

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp_test/blocs/authentication/bloc_register.dart';
import 'package:youapp_test/models/user_profile.dart';


void main() async {

  group('Unit Test: LoginBloc', () {
    final UserProfileDatabase users = UserProfileDatabase();
    final RegisterBloc registerBloc = RegisterBloc(userProfileDatabase: users);

    // NOTE : run each blocTest one by one(not all at once because both shared same instance)
    blocTest<RegisterBloc, RegisterState>(
      'test RegisterBloc success',
      build: () => registerBloc,
      act: (bloc) => bloc.add(RegisterButtonPressed(email: 'email', username: 'user', password: 'user1', confirmPassword: 'user1')),
      expect: () => [
        isA<RegisterLoading>(),
        isA<RegisterSuccess>(),
      ],
      wait: const Duration(milliseconds: 2000)
    );

    blocTest<RegisterBloc, RegisterState>(
      'test RegisterBloc failure',
      build: () => registerBloc,
      // trying registering the same username, or and password that doesn't match
      act: (bloc) => bloc.add(RegisterButtonPressed(email: 'email', username: 'user1', password: 'user1', confirmPassword: 'wkwkland')),
      expect: () => [
        isA<RegisterLoading>(),
        isA<RegisterFailure>(),
      ],
      wait: const Duration(milliseconds: 2000)
    );
  });


}