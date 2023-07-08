import 'package:intl/intl.dart' as intl;
import 'dart:math';

import 'package:youapp_test/models/user_profile.dart';


String getHoroscope(String date) {
  // Parse the date string to get day, month, and year
  List<String> parts = date.split(" ");
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  // Define the horoscope signs and their corresponding date ranges
  final horoscopeSigns = {
    // Year, Month, Day
    'Aquarius': {'start': DateTime(0, 1, 20), 'end': DateTime(0, 2, 18)},
    'Pisces': {'start': DateTime(0, 2, 19), 'end': DateTime(0, 3, 20)},
    'Aries': {'start': DateTime(0, 3, 21), 'end': DateTime(0, 4, 19)},
    'Taurus': {'start': DateTime(0, 4, 20), 'end': DateTime(0, 5, 20)},
    'Gemini': {'start': DateTime(0, 5, 21), 'end': DateTime(0, 6, 20)},
    'Cancer': {'start': DateTime(0, 6, 21), 'end': DateTime(0, 7, 22)},
    'Leo': {'start': DateTime(0, 7, 23), 'end': DateTime(0, 8, 22)},
    'Virgo': {'start': DateTime(0, 8, 23), 'end': DateTime(0, 9, 22)},
    'Libra': {'start': DateTime(0, 9, 23), 'end': DateTime(0, 10, 22)},
    'Scorpio': {'start': DateTime(0, 10, 23), 'end': DateTime(0, 11, 21)},
    'Sagittarius': {'start': DateTime(0, 11, 22), 'end': DateTime(0, 12, 21)},
    'Capricorn': {'start': DateTime(0, 12, 22), 'end': DateTime(0, 12, 31)},
  };

  // Iterate over the horoscope signs to find the matching sign for the given date
  for (var sign in horoscopeSigns.keys) {
    DateTime start = horoscopeSigns[sign]!['start']!;
    DateTime end = horoscopeSigns[sign]!['end']!;

    // Adjust the year for the horoscope date range
    if (end.month == 12 && start.month == 1 && month == 12) {
      start = DateTime(year - 1, start.month, start.day);
    } else {
      start = DateTime(year, start.month, start.day);
      end = DateTime(year, end.month, end.day);
    }

    // Check if the given date falls within the horoscope date range
    if (DateTime(year, month, day).isAfter(start) &&
        DateTime(year, month, day).isBefore(end)) {
      return sign;
    }
  }

  return '--'; // Return 'Unknown' if no matching horoscope sign is found
}

String getZodiacSign(String date) {
  List<String> dateParts = date.split(' ');
  int day = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int year = int.parse(dateParts[2]);

  DateTime inputDate = DateTime(year, month, day);

  Map<String, DateTime> zodiacSigns = {
    'Aries': DateTime(0, 3, 21),
    'Taurus': DateTime(0, 4, 20),
    'Gemini': DateTime(0, 5, 21),
    'Cancer': DateTime(0, 6, 21),
    'Leo': DateTime(0, 7, 23),
    'Virgo': DateTime(0, 8, 23),
    'Libra': DateTime(0, 9, 23),
    'Scorpio': DateTime(0, 10, 23),
    'Sagittarius': DateTime(0, 11, 22),
    'Capricorn': DateTime(0, 12, 22),
    'Aquarius': DateTime(0, 1, 20),
    'Pisces': DateTime(0, 2, 19),
  };

  for (var entry in zodiacSigns.entries) {
    String zodiacSign = entry.key;
    DateTime startDate = entry.value;

    if (inputDate.compareTo(startDate) >= 0) {
      int nextMonth = (month % 12) + 1;
      DateTime endDate = DateTime(year, nextMonth, startDate.day);

      if (inputDate.compareTo(endDate) < 0) {
        return zodiacSign;
      }
    }
  }

  return '--';
}

DateTime stringToDate(String dateString) {
  intl.DateFormat format = intl.DateFormat('dd MM yyyy');
  DateTime parsedDate = format.parse(dateString);
  return parsedDate;
}

String generateUniqueFileName() {
  final random = Random();
  final uniqueString = DateTime.now().microsecondsSinceEpoch.toString() +
      random.nextInt(10000).toString();
  return uniqueString;
}
