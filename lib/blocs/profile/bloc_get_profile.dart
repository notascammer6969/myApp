// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youapp_test/models/user_profile.dart';


// =========== Profile event
abstract class ProfileEvent {}

class GetProfile extends ProfileEvent {
  final String key;
  GetProfile({required this.key});
}

abstract class GetProfileState {}

class GetProfileInitial extends GetProfileState {}

class GetProfileLoading extends GetProfileState {}

class GetProfileSuccess extends GetProfileState {
  final ModelUser user;
  GetProfileSuccess({required this.user});
}

class GetProfileFailure extends GetProfileState {
  final String error;
  GetProfileFailure({required this.error});
}


class GetProfileBloc extends Bloc<ProfileEvent, GetProfileState>{
  final UserProfileDatabase userProfileDatabase;

  GetProfileBloc({required this.userProfileDatabase}) : super(GetProfileInitial()) {

    on<GetProfile>((event, emit) async {
      emit(GetProfileLoading());
      final user = await userProfileDatabase.getUser(event.key);
      if(user.username == event.key){
        emit(GetProfileSuccess(user: user));
      }else{
        emit(GetProfileFailure(error: 'Invalid username'));
      }
    });
  }
}