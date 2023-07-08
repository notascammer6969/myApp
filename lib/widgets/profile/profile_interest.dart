// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/widgets/profile/profile_interest_show.dart';


class ProfileInterest extends StatelessWidget {

  final ModelUser user;
  final Function(ModelUser) updateUser;
  const ProfileInterest({Key? key, required this.user, required this.updateUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileInterestShow(user: user, updateUser: updateUser);
  }
}
