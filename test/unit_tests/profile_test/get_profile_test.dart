// ignore_for_file: avoid_print

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp_test/blocs/profile/bloc_profile.dart';
import 'package:youapp_test/models/user_profile.dart';


void main() async {

  group('Unit Test: LoginBloc', () {
    final UserProfileDatabase users = UserProfileDatabase();
    final ProfileBloc profileBloc = ProfileBloc(userProfileDatabase: users);

    // NOTE : run each blocTest one by one(not all at once because both shared same instance)
    blocTest<ProfileBloc, ProfileState>(
        'test GetProfile success',
        build: () => profileBloc,
        act: (bloc) => bloc.add(GetProfile(key: 'user1')),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileSuccess>(),
        ],
        wait: const Duration(milliseconds: 2000)
    );

    blocTest<ProfileBloc, ProfileState>(
        'test GetProfile failure',
        build: () => profileBloc,
        act: (bloc) => bloc.add(GetProfile(key: 'invalid_username')),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileFailure>(),
        ],
        wait: const Duration(milliseconds: 2000)
    );
  });


}