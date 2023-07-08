// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youapp_test/models/user_profile.dart';

// =========== Login event
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  LoginButtonPressed({required this.username, required this.password});
}

// =========== Login state
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String username;
  LoginSuccess({required this.username});
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure({required this.error});
}

// =========== LOGIN BLOC
class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final UserProfileDatabase userProfileDatabase;

  LoginBloc({required this.userProfileDatabase}) : super(LoginInitial()) {

    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      final user = await userProfileDatabase.getUser(event.username);
      if(user.username == event.username && user.password == event.password){
        emit(LoginSuccess(username: user.username));
      }else{
        emit(LoginFailure(error: 'Invalid username or password'));
      }
    });
  }
}