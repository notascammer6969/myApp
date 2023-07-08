// ignore_for_file: avoid_print

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp_test/blocs/authentication/bloc_login.dart';
import 'package:youapp_test/models/user_profile.dart';


void main() async {

  group('Unit Test: LoginBloc', () {
    final UserProfileDatabase users = UserProfileDatabase();
    final LoginBloc loginBloc = LoginBloc(userProfileDatabase: users);

    // NOTE : run each blocTest one by one(not all at once because both shared same instance)
    blocTest<LoginBloc, LoginState>(
        'test LoginBloc success',
        build: () => loginBloc,
        act: (bloc) => bloc.add(LoginButtonPressed(username: 'user1', password: 'user1')),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginSuccess>(),
        ],
        wait: const Duration(milliseconds: 2000)
    );

    blocTest<LoginBloc, LoginState>(
        'test LoginBloc failure',
        build: () => loginBloc,
        act: (bloc) => bloc.add(LoginButtonPressed(username: 'username', password: 'password')),
        expect: () => [
          isA<LoginLoading>(),
          isA<LoginFailure>(),
        ],
        wait: const Duration(milliseconds: 2000)
    );
  });


}