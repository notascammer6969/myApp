// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youapp_test/models/user_profile.dart';

// =========== Register event
abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  RegisterButtonPressed({required this.email, required this.username, required this.password, required this.confirmPassword});
}

// =========== Register state
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String username;
  RegisterSuccess({required this.username});
}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure({required this.error});
}

// =========== Register BLOC
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  final UserProfileDatabase userProfileDatabase;

  RegisterBloc({required this.userProfileDatabase}) : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());

      ModelUser user = await userProfileDatabase.getUser(event.username);

      if(event.password != event.confirmPassword){
        emit(RegisterFailure(error: 'confirm password not match with password'));
        print('register failed: confirm password not match with password');
      }else{
        if(user.username.isNotEmpty){
          emit(RegisterFailure(error: 'username already used'));
          print('register failed: username already used');
        }else{
          if(user.email.isNotEmpty){
            emit(RegisterFailure(error: 'email already used'));
            print('register failed: email already used');
          }else{
            userProfileDatabase.addUser(
              ModelUser(email: event.email, username: event.username, password: event.password,
                profile: ModelUserProfile(
                  image: '',
                  displayName: '',
                  gender: '',
                  birthday: '',
                  horoscope: '',
                  zodiac: '',
                  height: '',
                  weight: '',
                  interest: [],
                )
              )
            );
            emit(RegisterSuccess(username: event.username));
          }
        }
      }
    });
  }
}