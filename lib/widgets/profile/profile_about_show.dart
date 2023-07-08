// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/shared/library.dart';

class ProfileAboutShow extends StatefulWidget {

  final Function toggleEdit;
  final ModelUser user;
  final Function(ModelUser) updateUser;

  const ProfileAboutShow({Key? key, required this.toggleEdit, required this.user, required this.updateUser}) : super(key: key);

  @override
  State<ProfileAboutShow> createState() => _ProfileAboutShowState();
}

class _ProfileAboutShowState extends State<ProfileAboutShow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF0E191F),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(27, 13, 22, 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'About',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('editing...');
                    widget.toggleEdit();
                  },
                  child: RichText(
                    text: TextSpan(
                      text: String.fromCharCode(Icons.edit_outlined.codePoint),
                      style: TextStyle(
                        fontFamily: Icons.edit_outlined.fontFamily,
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              ],
            ),
            widget.user.profile.birthday.isEmpty && widget.user.profile.height.isEmpty && widget.user.profile.weight.isEmpty ?
            const Padding(
              padding: EdgeInsets.only(top: 33),
              child: Text(
                'Add in your your to help others know you \nbetter',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: Colors.white54,
                ),
              ),
            ):
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(widget.user.profile.birthday.isNotEmpty) Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                          height: 1.21,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Birthday: ',
                            style: TextStyle(
                              color: Colors.white30
                            ),
                          ),
                          TextSpan(
                            text: '${widget.user.profile.birthday} (Age ${widget.user.profile.getAge()})',
                            style: const TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(widget.user.profile.birthday.isNotEmpty) Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                          height: 1.21,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Horoscope: ',
                            style: TextStyle(
                                color: Colors.white30
                            ),
                          ),
                          TextSpan(
                            text: getHoroscope(widget.user.profile.birthday),
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(widget.user.profile.birthday.isNotEmpty) Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                          height: 1.21,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Zodiac: ',
                            style: TextStyle(
                                color: Colors.white30
                            ),
                          ),
                          TextSpan(
                            text: getZodiacSign(widget.user.profile.birthday),
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(widget.user.profile.height.isNotEmpty) Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                          height: 1.21,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Height: ',
                            style: TextStyle(
                                color: Colors.white30
                            ),
                          ),
                          TextSpan(
                            text: widget.user.profile.height,
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(widget.user.profile.weight.isNotEmpty) Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 13.0,
                          height: 1.21,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Weight: ',
                            style: TextStyle(
                                color: Colors.white30
                            ),
                          ),
                          TextSpan(
                            text: widget.user.profile.weight,
                            style: const TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
