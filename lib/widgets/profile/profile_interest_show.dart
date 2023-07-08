// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/widgets/profile/profile_interest_edit.dart';
import 'package:youapp_test/blocs/profile/bloc_profile.dart';

class ProfileInterestShow extends StatefulWidget {

  final ModelUser user;
  final Function(ModelUser) updateUser;
  const ProfileInterestShow({Key? key, required this.user, required this.updateUser}) : super(key: key);

  @override
  State<ProfileInterestShow> createState() => _ProfileInterestShowState();
}

class _ProfileInterestShowState extends State<ProfileInterestShow> {
  @override
  Widget build(BuildContext context) {

    final profileBloc = Provider.of<ProfileBloc>(context, listen: false);

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
                  'Interest',
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileInterestEdit(user: widget.user, updateUser: widget.updateUser, profileBloc: profileBloc)));
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
            Padding(
              padding: const EdgeInsets.only(top: 33),
              child: widget.user.profile.interest.isEmpty ? const Text(
                'Add in your interest to find your match',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.0,
                  letterSpacing: 0.0,
                  color: Colors.white54,
                ),
              ): Wrap(
                spacing: 8.0, // horizontal spacing between tags
                runSpacing: 8.0, // vertical spacing between lines
                children: widget.user.profile.interest.map((interest) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Colors.white10,
                    ),
                    child: Text(
                      interest,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
