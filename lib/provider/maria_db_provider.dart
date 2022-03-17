import 'package:dtc_manager/model/log.dart';
import 'package:dtc_manager/provider/repositories/maria_db_repository.dart';
import 'package:flutter/material.dart';

class MariaDBProvider extends ChangeNotifier {
  final MariaDBRepository _mariaDBRepository = MariaDBRepository();

  List<dynamic>? _code;
  List<dynamic>? get code => _code;

  List<dynamic>? _log;
  List<dynamic>? get log => _log;

  List<dynamic>? _model;
  List<dynamic>? get model => _model;

  getDTCCode(String flag) async {
    _code = await _mariaDBRepository.getDTCCode(flag);
    notifyListeners();
  }

  getAllDTCCodes(String? subsystem) async {
    _code = await _mariaDBRepository.getAllDTCCodes(subsystem);
    notifyListeners();
  }

  searchDTCCodes(String flag) async {
    _code = await _mariaDBRepository.searchDTCCodes(flag);
    notifyListeners();
  }

  getDTCCodeLogs(int flag) async {
    _log = await _mariaDBRepository.getDTCCodeLogs(flag);
    notifyListeners();
  }

  getAllVehicleModels() async {
    _model = await _mariaDBRepository.getAllVehicleModels();
    notifyListeners();
  }

  uploadLog(Log log) async {
    await _mariaDBRepository.uploadLog(log);
    notifyListeners();
  }

  clearDTCCode() {
    _code = null;
  }
}
