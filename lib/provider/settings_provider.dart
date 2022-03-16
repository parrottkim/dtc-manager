import 'package:dtc_manager/constants.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  DTCLocalization _dtcLocale = DTCLocalization.enUS;
  DTCLocalization get dtcLocale => _dtcLocale;

  changeDTCLocalization(DTCLocalization locale) {
    _dtcLocale = locale;
    notifyListeners();
  }
}
