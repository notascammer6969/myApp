// ignore_for_file: avoid_print


import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:youapp_test/models/user_profile.dart';


enum ProfileEvent {
  getProfile,
  updateProfile,
}

class ProfileState {
  final bool isLoading;
  final String type;
  final bool isSuccess;
  final String error;
  ModelUser? data;

  ProfileState({
    required this.isLoading,
    required this.type,
    required this.isSuccess,
    required this.error,
    required this.data,
  });
}



class BlocProfile extends ChangeNotifier{
  var stateController = StreamController<ProfileState>();
  Stream<ProfileState> get stateStream => stateController.stream;
  // void setMockStateController(StreamController<ProfileState> mockController) {
  //   _stateController = mockController;
  // }

  Future<void> handleEvent(ProfileEvent event, {required String key, required ModelUserProfile userProfile}) async {
    if (event == ProfileEvent.getProfile) {
      await getProfile(key);
    }else if(event == ProfileEvent.updateProfile) {
      await updateProfile(key, userProfile);
    }
  }

  Future<void> getProfile(String username) async {
    _emitState(ProfileState(isLoading: true, type: '[getProfile]', isSuccess: false, error: '', data: null));

    try {
      print('...[getProfile]...');

      if(username.isNotEmpty){
        if(isUsernameExists(username)){
          userX = getUserByUsername(username);
          _emitState(ProfileState(isLoading: false, type: '[getProfile]', isSuccess: true, error: '', data: userX));
          print("......................");
          print('API Response: success');
          print('API Response: success');
          print('database after fetch:');
          print('data : ${userX.profile.gender}');
          print('data[interest] : ${userX.profile.interest}');
        }else{
          _emitState(ProfileState(isLoading: false, type: '[getProfile]', isSuccess: false, error: 'get profile failed: not match', data: null));
          print('API Response: failed, ');
        }
      } else {
        _emitState(ProfileState(isLoading: false, type: '[getProfile]', isSuccess: false, error: 'get profile failed: empty', data: null));
        print('API Request Failed: empty');
      }
    } catch (e) {
      _emitState(ProfileState(isLoading: false, type: '[getProfile]', isSuccess: false, error: e.toString(), data: null));
      print('API Request Error: $e');
    }
  }

  Future<void> updateProfile(String username, ModelUserProfile userProfile) async {
    // Show loading state
    _emitState(ProfileState(isLoading: true, type: '[updateProfile]', isSuccess: false, error: '', data: null));

    try {
      print('...[updateProfile]...');
      if(username.isNotEmpty) {
        if(isUsernameExists(username)){
          userX = getUserByUsername(username);
          deleteUserByUsername(username);
          addUser(ModelUser(email: userX.email, username: userX.username, password: userX.password, profile: userProfile));
          _emitState(ProfileState(isLoading: false, type: '[updateProfile]', isSuccess: true, error: '', data: null));
          print('API Response: success');
          print('database after update:');
          print('data : ${userX.profile.gender}');
          print('data[interest] : ${userX.profile.interest}');
        }else{
          _emitState(ProfileState(isLoading: false, type: '[updateProfile]', isSuccess: false, error: 'update profile failed: not match', data: null));
          print('API Response: failed, ');
        }
      }else {
        _emitState(ProfileState(isLoading: false, type: '[updateProfile]', isSuccess: false, error: 'update profile failed: empty', data: null));
        print('API Request Failed: empty');
      }

    } catch (e) {
      _emitState(ProfileState(isLoading: false, type: '[updateProfile]', isSuccess: false, error: e.toString(), data: null));
      print('API Request Error: $e');
    }
  }

  Future<ModelUser> fetchUserProfile(String username) {
    return Future.delayed(const Duration(seconds: 2), () {
      return userX;
    });
  }

  bool isUsernameExists(String username) {
    return usersAPI.any((user) => user.username == username);
  }

  void addUser(ModelUser user){
    usersAPI.add(user);
  }

  ModelUser getUserByUsername(String username) {
    return usersAPI.firstWhere((user) => user.username == username, orElse: () => userX);
  }

  void deleteUserByUsername(String username) {
    usersAPI.removeWhere((user) => user.username == username);
  }

  void _emitState(ProfileState state) {
    stateController.add(state);
  }

  @override
  void dispose() {
    stateController.close();
    super.dispose();
  }
}
