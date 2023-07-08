import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/widgets/authentication/authentication_register.dart';
import 'package:youapp_test/widgets/authentication/authentication_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youapp_test/blocs/authentication/bloc_login.dart';
import 'package:youapp_test/blocs/authentication/bloc_register.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  bool toggleAuthentication = true;
  final UserProfileDatabase userRepository = UserProfileDatabase();
  void toggleView(){
    setState( () => toggleAuthentication = !toggleAuthentication);
  }

  @override
  Widget build(BuildContext context) {
    return toggleAuthentication ?
      BlocProvider(
        create: (_) => LoginBloc(userProfileDatabase: userRepository),
        child: Login(toggleView : toggleView)
      ) :
      BlocProvider(
        create: (_) => RegisterBloc(userProfileDatabase: userRepository),
        child: Register(toggleView : toggleView)
    );

  }
}
