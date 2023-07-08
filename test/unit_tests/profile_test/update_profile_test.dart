// ignore_for_file: avoid_print

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youapp_test/blocs/profile/bloc_profile.dart';
import 'package:youapp_test/models/user_profile.dart';


void main() async {

  group('Unit Test: LoginBloc', () {
    final UserProfileDatabase users = UserProfileDatabase();
    final ProfileBloc profileBloc = ProfileBloc(userProfileDatabase: users);
    ModelUser user1 = ModelUser(
        email: 'user1@gmail.com',
        username: 'user1',
        password: 'user1',
        profile: ModelUserProfile(
          // image: 'https://www.pockettactics.com/wp-content/sites/pockettactics/2023/05/honkai-star-rail-silver-wolf.jpeg',
            image : 'newData',
            displayName: 'newData',
            gender: 'newData',
            birthday: 'newData',
            horoscope: 'newData',
            zodiac: 'newData',
            height: 'newData',
            weight: 'newData',
            interest: []
        )
    );

    // NOTE : run each blocTest one by one(not all at once because both shared same instance)
    blocTest<ProfileBloc, ProfileState>(
        'test UpdateProfile success',
        build: () => profileBloc,
        act: (bloc) => bloc.add(UpdateProfile(key: 'user1', user: user1)),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileSuccess>(),
        ],
        wait: const Duration(milliseconds: 4000)
    );

    blocTest<ProfileBloc, ProfileState>(
        'test UpdateProfile failure',
        build: () => profileBloc,
        act: (bloc) => bloc.add(UpdateProfile(key: 'invalid_username', user: user1)),
        expect: () => [
          isA<ProfileLoading>(),
          isA<ProfileFailure>(),
        ],
        wait: const Duration(milliseconds: 4000)
    );
  });


}