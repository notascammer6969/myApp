// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/widgets/profile/_tags.dart';
import 'package:youapp_test/blocs/profile/bloc_profile.dart';
import 'package:youapp_test/shared/session_management.dart';


class ProfileInterestEdit extends StatefulWidget {

  final ModelUser user;
  final Function(ModelUser) updateUser;
  final ProfileBloc profileBloc;
  const ProfileInterestEdit({Key? key, required this.user, required this.updateUser, required this.profileBloc}) : super(key: key);

  @override
  State<ProfileInterestEdit> createState() => _ProfileInterestEditState();
}

class _ProfileInterestEditState extends State<ProfileInterestEdit> {

  late SessionManager sessionManager;
  late String? username;
  late List<String> copyInterest;

  @override
  void initState() {
    super.initState();
    sessionManager = Provider.of<SessionManager>(context, listen: false);
    username = sessionManager.getUsername();
    copyInterest = [...widget.user.profile.interest];
  }

  void _updateInterest() async{
    ModelUser newData = ModelUser(
      email: widget.user.email,
      username: widget.user.username,
      password: widget.user.password,
      profile: ModelUserProfile(
        image: widget.user.profile.image,
        displayName: widget.user.profile.displayName,
        gender: widget.user.profile.gender,
        birthday: widget.user.profile.birthday,
        horoscope: widget.user.profile.horoscope,
        zodiac: widget.user.profile.zodiac,
        height: widget.user.profile.height,
        weight: widget.user.profile.weight,

        // the `widget.user.profile.weight` is updated after passing widget.user to the tagField
        interest: copyInterest,
      )
    );
    if (username != null) {
      widget.profileBloc.add(UpdateProfile(key: username!, user: newData));
    }
  }

  @override
  void dispose() {
    super.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 10, top: 32, right: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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
                                height: 2.0,
                                letterSpacing: 0.0,
                                color: Colors.white,
                              ),
                            ),
                          ]
                        )
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _updateInterest();
                        Navigator.pop(context);
                      },
                      child: const Text("Save",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          height: 1.0,
                          letterSpacing: 0.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 35, top: 73),
                child: Text("Tell everyone about yourself",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: Color(0xFF94783E),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 35, top: 12),
                child: Text("What interest you?",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 35, right: 17),
                child: TagField(user: widget.user, updatedTags: copyInterest),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
