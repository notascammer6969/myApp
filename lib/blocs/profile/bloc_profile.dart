// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youapp_test/models/user_profile.dart';


// =========== Profile event
abstract class ProfileEvent {}

class GetProfile extends ProfileEvent {
  final String key;
  GetProfile({required this.key});
}

class UpdateProfile extends ProfileEvent {
  final String key;
  final ModelUser user;
  UpdateProfile({required this.key, required this.user});
}

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ModelUser user;
  final String flag;
  ProfileSuccess({required this.user, required this.flag});
}

class ProfileFailure extends ProfileState {
  final String error;
  ProfileFailure({required this.error});
}


class ProfileBloc extends Bloc<ProfileEvent, ProfileState>{
  final UserProfileDatabase userProfileDatabase;

  ProfileBloc({required this.userProfileDatabase}) : super(ProfileInitial()) {

    on<GetProfile>((event, emit) async {
      // print('[GetProfile]');
      emit(ProfileLoading());
      final user = await userProfileDatabase.getUser(event.key);
      if(user.username == event.key){
        // print('<< | new data : ${user.profile.gender}');
        emit(ProfileSuccess(user: user, flag: '[getProfile]'));
      }else{
        emit(ProfileFailure(error: 'Invalid username'));
      }
    });

    on<UpdateProfile>((event, emit) async {
      // print('[UpdateProfile]');
      emit(ProfileLoading());
      final user = await userProfileDatabase.getUser(event.key);
      if(user.username == event.key){
        await userProfileDatabase.updateUser(event.user);
        // print('>> | new data : ${event.user.profile.gender}');
        // print('>> | new data2 : ${user.profile.gender}');
        emit(ProfileSuccess(user: event.user, flag: '[updateProfile]'));
      }else{
        emit(ProfileFailure(error: 'Invalid username'));
      }
    });
  }
}