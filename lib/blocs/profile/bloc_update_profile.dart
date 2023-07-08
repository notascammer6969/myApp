// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youapp_test/models/user_profile.dart';


// =========== Profile event
abstract class ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String key;
  final ModelUser user;
  UpdateProfile({required this.key, required this.user});
}

abstract class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final ModelUser user;
  UpdateProfileSuccess({required this.user});
}

class UpdateProfileFailure extends UpdateProfileState {
  final String error;
  UpdateProfileFailure({required this.error});
}


class UpdateProfileBloc extends Bloc<ProfileEvent, UpdateProfileState>{
  final UserProfileDatabase userProfileDatabase;

  UpdateProfileBloc({required this.userProfileDatabase}) : super(UpdateProfileInitial()) {

    on<UpdateProfile>((event, emit) async {
      emit(UpdateProfileLoading());
      final user = await userProfileDatabase.getUser(event.key);
      if(user.username == event.key){
        await userProfileDatabase.updateUser(event.user);
        emit(UpdateProfileSuccess(user: user));
      }else{
        emit(UpdateProfileFailure(error: 'Invalid username'));
      }
    });
  }
}