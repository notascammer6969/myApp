// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:youapp_test/widgets/profile/profile_about.dart';
import 'package:youapp_test/widgets/profile/profile_interest.dart';
import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/shared/library.dart';
import 'package:youapp_test/shared/session_management.dart';
import 'package:youapp_test/blocs/profile/bloc_profile.dart';
import 'package:youapp_test/screens/authentication.dart';


class Profile extends StatelessWidget {

  Profile({Key? key}) : super(key: key);
  final UserProfileDatabase userRepository = UserProfileDatabase();

  @override
  Widget build(BuildContext context) {
    final sessionManager = Provider.of<SessionManager>(context, listen: false);
    if (sessionManager.isLoggedIn() && sessionManager.getUsername() != null) {
      print('welcome ${sessionManager.getUsername()}');
      return BlocProvider(
        create: (_) => ProfileBloc(userProfileDatabase: userRepository),
        child: const ProfileLayout()
      );
    } else{
      // Session is not active or required data is not available, redirect to login
      print('u r not logged in');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Authentication()),
        );
      });

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class ProfileLayout extends StatefulWidget {
  const ProfileLayout({Key? key}) : super(key: key);

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {

  ModelUser user = ModelUser(
    email: 'user1@gmail.com',
    username: 'user1',
    password: 'user1',
    profile: ModelUserProfile(
      // image: 'https://www.pockettactics.com/wp-content/sites/pockettactics/2023/05/honkai-star-rail-silver-wolf.jpeg',
        image: '',
        displayName: '',
        gender: '',
        birthday: '',
        horoscope: '',
        zodiac: '',
        height: '',
        weight: '',
        interest: []
    )
  );
  late SessionManager sessionManager;
  late ProfileBloc profileBloc;
  StreamSubscription<ProfileState>? _subscription;

  void updateUser(ModelUser updateData){
    setState((){
      //fetch the data from API/backend
      user = updateData;
    });
  }


  @override
  void initState() {
    super.initState();
    sessionManager = Provider.of<SessionManager>(context, listen: false);
    profileBloc = Provider.of<ProfileBloc>(context, listen: false);
    final username = sessionManager.getUsername();

    if (username != null) {
      // print('state: ${pp.state}');
      _subscription = profileBloc.stream.listen((state) {
        if(state is ProfileSuccess){
          print('success fetching data| ${state.user.profile.gender}');
          print('flag: ${state.flag}');
          updateUser(state.user);
        }else{
          print('failed fetching data');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const Authentication()));
        }
      });
      profileBloc.add(GetProfile(key: username));
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(0xFF09141A),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('logged out...');
                        sessionManager.clearToken();
                        sessionManager.clearUsername();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Authentication()));
                      },
                      child: RichText(
                        key: const Key("logout"),
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
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          user.profile.displayName.isNotEmpty ? user.profile
                              .displayName : '',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            height: 1.0,
                            letterSpacing: 0.0,
                            color: Colors.white,
                          ),
                        ),

                      ),
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 28, 8, 24),
                child: Stack(
                  children: [
                    user.profile.image.isEmpty ?
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFF162329),
                      ),
                      height: 190.0,
                      width: double.infinity,
                    ) :
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(user.profile.image),
                        fit: BoxFit.cover,
                        height: 190,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      bottom: 17.0,
                      left: 13.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '@${user.profile.displayName}, ${user.profile
                                .getAge()}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              letterSpacing: 0.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6,),
                          Text(
                            user.profile.gender,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              letterSpacing: 0.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if(user.profile.birthday.isNotEmpty) Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white10,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 9.5, horizontal: 16),
                                  child: Text(
                                    getHoroscope(user.profile.birthday),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.0,
                                      letterSpacing: 0.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15,),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white10,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 9.5, horizontal: 16),
                                  child: Text(
                                    getZodiacSign(user.profile.birthday),
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      height: 1.0,
                                      letterSpacing: 0.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ProfileAbout(user: user, updateUser: updateUser),
                        const SizedBox(height: 18,),
                        ProfileInterest(user: user, updateUser: updateUser),
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
}
