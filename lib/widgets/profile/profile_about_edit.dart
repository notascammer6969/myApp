// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youapp_test/shared/style.dart';
import 'package:intl/intl.dart' as intl;
import 'package:youapp_test/models/user_profile.dart';
import 'package:youapp_test/shared/library.dart';
import 'package:youapp_test/blocs/profile/bloc_profile.dart';
import 'package:youapp_test/shared/session_management.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileAboutEdit extends StatefulWidget {

  final Function toggleEdit;
  final ModelUser user;

  const ProfileAboutEdit({Key? key, required this.toggleEdit, required this.user}) : super(key: key);

  @override
  State<ProfileAboutEdit> createState() => _ProfileAboutEditState();
}

class _ProfileAboutEditState extends State<ProfileAboutEdit> {

  late SessionManager sessionManager;
  late ProfileBloc profileBloc;
  late String selectedDate = widget.user.profile.birthday.isEmpty ? "DD MM YYYY" : widget.user.profile.birthday;
  File? selectedImage;
  String? savedImagePath;
  late TextEditingController _aboutImageController;
  late TextEditingController _aboutDisplayNameController;
  late TextEditingController _aboutGenderController;
  late TextEditingController _aboutBirthdayController;
  late TextEditingController _aboutHoroscopeController;
  late TextEditingController _aboutZodiacController;
  late TextEditingController _aboutHeightController;
  late TextEditingController _aboutWeightController;

  @override
  void initState() {
    super.initState();
    sessionManager = Provider.of<SessionManager>(context, listen: false);
    profileBloc = Provider.of<ProfileBloc>(context, listen: false);
    _aboutImageController = TextEditingController(text: widget.user.profile.image);
    _aboutDisplayNameController = TextEditingController(text: widget.user.profile.displayName);
    _aboutGenderController = TextEditingController(text: widget.user.profile.gender);
    _aboutBirthdayController = TextEditingController(text: widget.user.profile.birthday);
    _aboutHoroscopeController = TextEditingController(text: widget.user.profile.birthday.isEmpty ? '' : getHoroscope(widget.user.profile.birthday));
    _aboutZodiacController = TextEditingController(text: widget.user.profile.birthday.isEmpty ? '' : getZodiacSign(widget.user.profile.birthday));
    _aboutHeightController = TextEditingController(text: widget.user.profile.height);
    _aboutWeightController = TextEditingController(text: widget.user.profile.weight);

  }

  @override
  void dispose() {
    super.dispose();
    _aboutImageController.dispose();
    _aboutDisplayNameController.dispose();
    _aboutGenderController.dispose();
    _aboutBirthdayController.dispose();
    _aboutHoroscopeController.dispose();
    _aboutZodiacController.dispose();
    _aboutHeightController.dispose();
    _aboutWeightController.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate == "DD MM YYYY" ? DateTime.now() : stringToDate(selectedDate),
      firstDate: DateTime(1950, 1),
      lastDate: DateTime(2045)
    );

    setState(() {
      selectedDate = picked != null ? intl.DateFormat('dd MM yyyy').format(picked) : "DD MM YYYY";
      _aboutBirthdayController.text = selectedDate;
      if(selectedDate != "DD MM YYYY"){
        _aboutHoroscopeController.text = getHoroscope(selectedDate);
        _aboutZodiacController.text = getZodiacSign(selectedDate);
      }

    });
  }

  Future<void> _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      final appDir = await getApplicationDocumentsDirectory();
      String fileName = '${generateUniqueFileName()}.png';
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');

      setState(() {
        selectedImage = imageFile;
        savedImagePath = savedImage.path;
        _aboutImageController.text = savedImagePath ?? widget.user.profile.image;
        print('savedImagePath: $savedImagePath');
      });
    }
  }

  Widget buildInitialImage() {
    if (widget.user.profile.image.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(widget.user.profile.image),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const Icon(
        Icons.add,
        size: 21,
        color: Colors.white,
      );
    }
  }

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
                  onTap: () async {

                    ModelUser newData = ModelUser(
                      email: widget.user.email,
                      username: widget.user.username,
                      password: widget.user.password,
                      profile: ModelUserProfile(
                        image: _aboutImageController.text,
                        displayName: _aboutDisplayNameController.text,
                        gender: _aboutGenderController.text,
                        birthday: _aboutBirthdayController.text != "DD MM YYYY" ? _aboutBirthdayController.text : '',
                        horoscope: _aboutHoroscopeController.text,
                        zodiac: _aboutZodiacController.text,
                        height: _aboutHeightController.text,
                        weight: _aboutWeightController.text,
                        interest: widget.user.profile.interest
                      )
                    );
                    final username = sessionManager.getUsername();

                    if (username != null) {
                      profileBloc.add(UpdateProfile(key: username, user: newData));
                      // profileBloc.add(GetProfile(key: username));

                    }

                    // print('==========finished==========');
                    widget.toggleEdit();
                  },
                  child: const Text(
                    'Save & Edit',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      color: Color(0xFF94783E),
                    ),
                  )
                )
              ],
            ),
            const SizedBox(height: 33,),
            Row(
              children: [
                InkWell(
                  onTap: _selectImage,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0x14FFFFFF),
                    ),
                    height: 57,
                    width: 57,
                    child: selectedImage != null ?
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ) : buildInitialImage(),
                  ),
                ),
                const SizedBox(width: 15.0,),
                const Text(
                  'Add image',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    height: 1.25,
                    letterSpacing: 0.0,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Display name:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                      height: 1.25,
                      letterSpacing: 0.0,
                      color: Color(0x54FFFFFF),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 202,
                    child: TextFormField(
                      key: const Key("profileEditDN"),
                      initialValue: widget.user.profile.displayName.isEmpty ? '' : widget.user.profile.displayName,
                      textAlign: TextAlign.right,
                      decoration: fieldAbout.copyWith(hintText: "Enter name"),
                      style: fieldAboutTextStyle,
                      onChanged: (value) {
                        _aboutDisplayNameController.text = value;
                      },
                    ),
                  ),
                ],
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gender:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                      height: 1.25,
                      letterSpacing: 0.0,
                      color: Color(0x54FFFFFF),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 202,
                    child: DropdownButtonFormField<String>(
                      decoration: fieldAbout.copyWith(hintText: "Select gender"),
                      style: fieldAboutTextStyle,
                      dropdownColor: const Color(0xFF162329),
                      value: widget.user.profile.gender.isEmpty ? null : widget.user.profile.gender,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'Male',
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("Male"),
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'Female',
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("Female"),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        value != null ? _aboutGenderController.text = value : _aboutGenderController.text = '';
                      },
                    ),
                  ),
                ],
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Birthday:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                      height: 1.25,
                      letterSpacing: 0.0,
                      color: Color(0x54FFFFFF),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 202,
                    child: Directionality(
                      textDirection: TextDirection.ltr,

                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color(0x26D9D9D9),
                          border: Border.all(
                            color: const Color(0x26FFFFFF),
                            width: 1.0,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _selectDate(context);
                          } ,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent, // Make the button background transparent
                            padding: const EdgeInsets.all(0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                selectedDate,
                                style: selectedDate == "DD MM YYYY" ?
                                fieldAboutTextStyle.copyWith(color: const Color(0x4DFFFFFF)) :
                                fieldAboutTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ),
                  ),
                ],
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Horoscope:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                      height: 1.25,
                      letterSpacing: 0.0,
                      color: Color(0x54FFFFFF),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 202,
                    child: TextFormField(
                      initialValue: widget.user.profile.birthday.isEmpty ? '--' : getHoroscope(widget.user.profile.birthday),
                      enabled: false,
                      textAlign: TextAlign.right,
                      decoration: fieldAbout.copyWith(hintText: "--"),
                      style: fieldAboutTextStyle.copyWith(color: const Color(0x4DFFFFFF)),
                    ),
                  ),
                ],
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Zodiac:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                      height: 1.25,
                      letterSpacing: 0.0,
                      color: Color(0x54FFFFFF),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 202,
                    child: TextFormField(
                      initialValue: widget.user.profile.birthday.isEmpty ? '--' : getZodiacSign(widget.user.profile.birthday),
                      enabled: false,
                      textAlign: TextAlign.right,
                      decoration: fieldAbout.copyWith(hintText: "--"),
                      style: fieldAboutTextStyle.copyWith(color: const Color(0x4DFFFFFF)),
                    ),
                  ),
                ],
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Height:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                      height: 1.25,
                      letterSpacing: 0.0,
                      color: Color(0x54FFFFFF),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 202,
                    child: TextFormField(
                      key: const Key("profileEditHeight"),
                      initialValue: widget.user.profile.height.isEmpty ? '' : widget.user.profile.height,
                      textAlign: TextAlign.right,
                      decoration: fieldAbout.copyWith(hintText: "Add height"),
                      style: fieldAboutTextStyle,
                      onChanged: (value){
                        _aboutHeightController.text = value;
                      },
                    ),
                  ),
                ],
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Weight:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0,
                      height: 1.25,
                      letterSpacing: 0.0,
                      color: Color(0x54FFFFFF),
                    ),
                  ),
                  SizedBox(
                    height: 36,
                    width: 202,
                    child: TextFormField(
                      key: const Key("profileEditWeight"),
                      initialValue: widget.user.profile.weight.isEmpty ? '' : widget.user.profile.weight,
                      textAlign: TextAlign.right,
                      decoration: fieldAbout.copyWith(hintText: "Add weight"),
                      style: fieldAboutTextStyle,
                      onChanged: (value){
                        _aboutWeightController.text = value;
                      },
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
