import 'package:easy_localization/easy_localization.dart';

enum DTCLocalization { enUS, koKR, both }

String getDetailDate(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateTime justNow = now.subtract(Duration(seconds: 20));
  DateTime localDateTime = dateTime.toLocal();

  final difference = now.difference(DateTime(dateTime.year, dateTime.month,
      dateTime.day, dateTime.hour, dateTime.minute, dateTime.second));
  String roughTimeString = DateFormat('jm').format(dateTime);
  if (difference.inDays > 8) {
    return '${DateFormat('yyyy.MM.dd').format(dateTime)}, $roughTimeString';
  } else if ((difference.inDays / 7).floor() >= 1) {
    String weekday = DateFormat('EEEE').format(now);
    return 'date1'.tr() + ' $weekday';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays}' + 'date2'.tr();
  } else if (difference.inDays >= 1) {
    return 'date3'.tr();
  } else if (difference.inHours >= 2) {
    return '${difference.inHours}' + 'date4'.tr();
  } else if (difference.inHours >= 1) {
    return 'date5'.tr();
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes}' + 'date6'.tr();
  } else if (difference.inMinutes >= 1) {
    return 'date7'.tr();
  } else {
    return 'date8'.tr();
  }
  // String roughTimeString = DateFormat('jm').format(dateTime);
  // if (localDateTime.day == now.day &&
  //     localDateTime.month == now.month &&
  //     localDateTime.year == now.year) {
  //   return roughTimeString;
  // }
  // DateTime yesterday = now.subtract(Duration(days: 1));
  // if (localDateTime.day == yesterday.day &&
  //     localDateTime.month == now.month &&
  //     localDateTime.year == now.year) {
  //   return 'date2'.tr() + roughTimeString;
  // }
  // if (now.difference(localDateTime).inDays < 4) {
  //   String weekday = DateFormat('EEEE').format(localDateTime);
  //   return '$weekday, $roughTimeString';
  // }
  // return '${DateFormat('yyyy.MM.dd').format(dateTime)}, $roughTimeString';
}
