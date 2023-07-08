import 'package:flutter/material.dart';

// Define a shared style for the TextFormField fields
const TextStyle fieldTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 13.0,
  height: 1.23,
  letterSpacing: 0.0,
  wordSpacing: 0.0,
  textBaseline: TextBaseline.alphabetic,
  overflow: TextOverflow.visible,
);

final InputDecoration fieldDecoration = InputDecoration(
  labelStyle: const TextStyle(
    color: Color(0x66FFFFFF),
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    height: 1.23,
    letterSpacing: 0.0,
    wordSpacing: 0.0,
    textBaseline: TextBaseline.alphabetic,
    overflow: TextOverflow.visible,
  ),
  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
  floatingLabelBehavior: FloatingLabelBehavior.never,
  filled: true,
  fillColor: Colors.white.withOpacity(0.15),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(9.0),
    borderSide: BorderSide.none,
  ),
);

// ======================================================================
// ========== PROFILE ABOUT FIELD

// == GENERAL STYLE FOR THE FIELD
const TextStyle fieldAboutTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 13.0,
  height: 1.23,
  letterSpacing: 0.0,
  wordSpacing: 0.0,
  textBaseline: TextBaseline.alphabetic,
  overflow: TextOverflow.visible,

);

final InputDecoration fieldAbout = InputDecoration(
  labelStyle: const TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    height: 1,
    color: Color(0x4DFFFFFF),
  ),
  hintStyle: const TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    height: 1,
    color: Color(0x4DFFFFFF),
  ),
  //adjust the padding of the text
  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  floatingLabelBehavior: FloatingLabelBehavior.never,
  filled: true,
  fillColor: const Color(0x26D9D9D9),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(color: Color(0x26FFFFFF), width: 1.5),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0x26FFFFFF), width: 1.5),
    borderRadius: BorderRadius.circular(8.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0x26FFFFFF), width: 1.5),
    borderRadius: BorderRadius.circular(8.0),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0x26FFFFFF), width: 1.5),
    borderRadius: BorderRadius.circular(8.0),
  ),
);



// == BUILT-IN DROP DOWN
InputDecoration getDropdownDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    labelStyle: const TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 12.0,
      height: 1.25,
      letterSpacing: 0.0,
      color: Color(0x54FFFFFF),
    ),
  );
}

TextStyle getDropdownTextStyle() {
  return const TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    height: 1.25,
    letterSpacing: 0.0,
    color: Colors.black,
  );
}

Widget fieldAboutDropdown({
  required String labelText,
  required String value,
  required void Function(String?) onChanged,
  required List<DropdownMenuItem<String>> items,
}) {
  return DropdownButtonFormField<String>(
    decoration: fieldAbout.copyWith(labelText: labelText),
    style: getDropdownTextStyle(),
    value: value,
    items: items,
    onChanged: onChanged,
  );
}