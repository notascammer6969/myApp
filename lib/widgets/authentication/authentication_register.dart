// ignore_for_file: avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youapp_test/shared/style.dart';
import 'package:youapp_test/blocs/authentication/bloc_register.dart';
import 'package:youapp_test/screens/profile.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  const Register({Key? key, required this.toggleView}): super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _registerEmailController = TextEditingController();
  final TextEditingController _registerUsernameController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();
  final TextEditingController _registerConfirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isRegisterEmailFieldEmpty = false;
  bool _isRegisterUsernameFieldEmpty = false;
  bool _isRegisterPasswordFieldEmpty = false;
  bool _isRegisterConfirmPasswordFieldEmpty = false;
  bool isKeyboardVisible = false;
  bool _isNotificationShown = false;

  @override
  void dispose() {
    _registerEmailController.dispose();
    _registerUsernameController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  void _showNotification(String message, {Color color = Colors.red}) {
    if(!_isNotificationShown){
      _isNotificationShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('registerNotification'),
            content: Text(
              message,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: color,
          ),
        );
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    // final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
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
                    'Register',
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(23.0, 30.0, 25.0, 15.0),
                  child: _registerForm(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 120),
                child: RichText(
                  key: const Key('loginHere'),
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
                        text: 'Have an account? ',
                      ),
                      TextSpan(
                        text: 'Login here',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          decorationThickness: 1.5, // Adjust the underline thickness
                          decorationStyle: TextDecorationStyle.solid,
                          color:  Color(0xFF94783E),
                        ),
                        recognizer: TapGestureRecognizer()..onTap = widget.toggleView as GestureTapCallback?
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerForm(BuildContext context){
    final RegisterBloc registerBloc = BlocProvider.of<RegisterBloc>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            if(state is RegisterFailure) {
              _showNotification(state.error);
            }else if(state is RegisterSuccess){
              _showNotification('register success', color: Colors.greenAccent);
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      border: Border.all(
                        color: _isRegisterEmailFieldEmpty ? Colors.red : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    height: 45,
                    child: TextFormField(
                      key: const Key("registerEmail"),
                      controller: _registerEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: fieldDecoration.copyWith(labelText: "Enter Email"),
                      style: fieldTextStyle,
                      validator: (value) {
                        setState(() {
                          _isRegisterEmailFieldEmpty = value!.isEmpty ? true : false;
                        });
                        return null; // Return null for no validation errors
                      },
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      border: Border.all(
                        color: _isRegisterUsernameFieldEmpty ? Colors.red : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    height: 45,
                    child: TextFormField(
                      key: const Key("registerUsername"),
                      controller: _registerUsernameController,
                      decoration: fieldDecoration.copyWith(labelText: "Create Username"),
                      style: fieldTextStyle,
                      validator: (value) {
                        setState(() {
                          _isRegisterUsernameFieldEmpty = value!.isEmpty ? true : false;
                        });
                        return null; // Return null for no validation errors
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      border: Border.all(
                        color: _isRegisterPasswordFieldEmpty ? Colors.red : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    height: 45,
                    child: TextFormField(
                      key: const Key("registerPassword"),
                      controller: _registerPasswordController,
                      obscureText: !_isPasswordVisible, // Obfuscate the password if it's not visible
                      decoration: fieldDecoration.copyWith(
                        labelText: "Create Password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible; // Toggle the visibility of the password
                            });
                          },
                          child: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey, // Customize the color of the icon
                          ),
                        ),
                      ),
                      style: fieldTextStyle,
                      validator: (value) {
                        setState(() {
                          _isRegisterPasswordFieldEmpty = value!.isEmpty ? true : false;
                        });
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      border: Border.all(
                        color: _isRegisterConfirmPasswordFieldEmpty ? Colors.red : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    height: 45,
                    child: TextFormField(
                      key: const Key("registerConfirmPassword"),
                      controller: _registerConfirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible, // Obfuscate the password if it's not visible
                      decoration: fieldDecoration.copyWith(
                        labelText: "Confirm Password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible; // Toggle the visibility of the password
                            });
                          },
                          child: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey, // Customize the color of the icon
                          ),
                        ),
                      ),
                      style: fieldTextStyle,
                      validator: (value) {
                        setState(() {
                          _isRegisterConfirmPasswordFieldEmpty = value!.isEmpty ? true : false;
                        });
                        return null;
                      },
                    ),
                  ),
                ),
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
                    key: const Key("registerButton"),
                    onPressed: state is RegisterLoading ? null : (){
                      _isNotificationShown = false;
                      if (_formKey.currentState!.validate() && _registerEmailController.text.isNotEmpty &&
                          _registerUsernameController.text.isNotEmpty && _registerPasswordController.text.isNotEmpty &&
                          _registerConfirmPasswordController.text.isNotEmpty
                      ) {
                        registerBloc.add(RegisterButtonPressed(
                          email: _registerEmailController.text,
                          username: _registerUsernameController.text,
                          password: _registerPasswordController.text,
                          confirmPassword: _registerConfirmPasswordController.text
                        ));
                      }else{
                        print('u submitting a black hole');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // Make the button background transparent
                      padding: const EdgeInsets.all(0),
                      elevation: 0,
                    ),
                    child: state is RegisterLoading ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ) : const Text(
                      'Register',
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
        ),
      ),
    );
  }
}
