// ignore_for_file: avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:youapp_test/shared/style.dart';
import 'package:youapp_test/blocs/authentication/bloc_login.dart';
import 'package:youapp_test/shared/session_management.dart';

import 'package:youapp_test/screens/profile.dart';


class Login extends StatefulWidget {

  final Function toggleView;
  const Login({Key? key, required this.toggleView}): super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEmailFieldEmpty = false;
  bool _isPasswordFieldEmpty = false;
  bool _isNotificationShown = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showNotification(String message, {Color color = Colors.red}) {

    if(!_isNotificationShown){
      _isNotificationShown = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          key: const Key('loginNotification'),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF1F4247),
                Color(0xFF0D1D23),
                Color(0xFF09141A),
              ],
              stops: [0.0, 0.56, 1.0],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 32),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                      // Navigator.pop(context);
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          TextSpan(
                            text: "Back",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              height: 2,
                              letterSpacing: 0.0,
                              color: Colors.white,
                            ),
                          ),
                        ]
                      )
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35, top: 50),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      height: 1.0,
                      letterSpacing: 0.0,
                      color: Colors.white,
                    ),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(23.0, 30.0, 25.0, 15.0),
                child: _loginForm(context)
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: RichText(
                    key: const Key('registerHere'),
                    text: TextSpan(
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        height: 1.23,
                        letterSpacing: 0.0,
                        color: Colors.white,
                      ),
                      children: [
                        const TextSpan(
                          text: 'No Account? ',
                        ),
                        TextSpan(
                          text: 'Register here',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5, // Adjust the underline thickness
                            decorationStyle: TextDecorationStyle.solid,
                            color: Color(0xFF94783E),
                          ),
                          recognizer: TapGestureRecognizer()..onTap = widget.toggleView as GestureTapCallback?
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {

    final LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return Form(
      key: _formKey,
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if(state is LoginFailure) {
              _showNotification(state.error);
            }else if(state is LoginSuccess){
              final sessionManager = Provider.of<SessionManager>(context, listen: false);
              _showNotification('login success', color: Colors.greenAccent);
              sessionManager.setUsername(_emailController.text);
              sessionManager.setToken('sample_token');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile()));
            }
          });
          return Column(
            children: [
              _usernameField(),
              _passwordField(),
              Container(
                height: 47,
                width: double.infinity, // Width same as the field
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.0),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF62CDCB),
                      Color(0xFF4599DB),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: ElevatedButton(
                  key: const Key("loginButton"),
                  onPressed: state is LoginLoading ? null : () {
                    _isNotificationShown = false;
                    if(_formKey.currentState!.validate() && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
                      loginBloc.add(
                          LoginButtonPressed(username: _emailController.text, password: _passwordController.text)
                      );
                    } else {
                      print('u submitting a black hole');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    elevation: 0,
                  ),
                  child: state is LoginLoading ?
                  const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)) :
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      height: 1.0,
                      letterSpacing: -0.23,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }

      )
    );
  }

  Widget _usernameField(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.0),
          border: Border.all(
            color: _isEmailFieldEmpty ? Colors.red : Colors.transparent,
            width: 2.0,
          ),
        ),
        height: 45,
        child: TextFormField(
          key: const Key("loginUsername"),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: fieldDecoration.copyWith(
            labelText: "Enter Username/Email"),
          style: fieldTextStyle,
          validator: (value) {
            setState(() {
              _isEmailFieldEmpty = value!.isEmpty ? true : false;
            });
            return null; // Return null for no validation errors
          },
        ),
      ),
    );
  }

  Widget _passwordField(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.0),
          border: Border.all(
            color: _isPasswordFieldEmpty ? Colors.red : Colors
                .transparent,
            width: 2.0,
          ),
        ),
        height: 45,
        child: TextFormField(
          key: const Key("loginPassword"),
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          // Obfuscate the password if it's not visible
          decoration: fieldDecoration.copyWith(
            labelText: "Enter Password",
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible =
                  !_isPasswordVisible; // Toggle the visibility of the password
                });
              },
              child: Icon(
                _isPasswordVisible ? Icons.visibility : Icons
                    .visibility_off,
                color: Colors.grey, // Customize the color of the icon
              ),
            ),
          ),
          style: fieldTextStyle,
          validator: (value) {
            setState(() {
              _isPasswordFieldEmpty = value!.isEmpty ? true : false;
            });
            return null; // Return null for no validation errors
          },
        ),
      ),
    );
  }


}
