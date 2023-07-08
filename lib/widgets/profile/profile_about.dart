// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/widgets/profile/profile_about_edit.dart';
import 'package:youapp_test/widgets/profile/profile_about_show.dart';


class ProfileAbout extends StatefulWidget {

  final ModelUser user;
  final Function(ModelUser) updateUser;
  const ProfileAbout({Key? key, required this.user, required this.updateUser}) : super(key: key);

  @override
  State<ProfileAbout> createState() => _ProfileAboutState();
}

class _ProfileAboutState extends State<ProfileAbout> {

  bool _isEditing = false;

  void toggleEdit(){
    setState( () => _isEditing = !_isEditing);
  }

  @override
  Widget build(BuildContext context) {
    return !_isEditing ?
      ProfileAboutShow(toggleEdit: toggleEdit, user: widget.user, updateUser: widget.updateUser):
      ProfileAboutEdit(toggleEdit: toggleEdit, user: widget.user);
  }
}
