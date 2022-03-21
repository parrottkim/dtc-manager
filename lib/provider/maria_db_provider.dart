import 'package:dtc_manager/model/log.dart';
import 'package:dtc_manager/provider/repositories/maria_db_repository.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class MariaDBProvider extends ChangeNotifier {
  final MariaDBRepository _mariaDBRepository = MariaDBRepository();

  List<ResultRow>? _code;
  List<ResultRow>? get code => _code;

  List<ResultRow>? _log;
  List<ResultRow>? get log => _log;

  List<ResultRow>? _modelCount;
  List<ResultRow>? get modelCount => _modelCount;

  List<ResultRow>? _modelCodeCount;
  List<ResultRow>? get modelCodeCount => _modelCodeCount;

  List<ResultRow>? _model;
  List<ResultRow>? get model => _model;

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

  getVehicleModel(String value) async {
    _modelCount = await _mariaDBRepository.getVehicleModel(value);
    notifyListeners();
  }

  getVehicleModelCode(String value) async {
    _modelCodeCount = await _mariaDBRepository.getVehicleModelCode(value);
    notifyListeners();
  }

  editVehicleModel(ResultRow row, String value) async {
    await _mariaDBRepository.editVehicleModel(row, value);
    notifyListeners();
  }

  editVehicleModelCode(ResultRow row, String value) async {
    await _mariaDBRepository.editVehicleModelCode(row, value);
    notifyListeners();
  }

  addVehicleModel(List<String> value) async {
    await _mariaDBRepository.addVehicleModel(value);
    notifyListeners();
  }

  deleteVehicleModel(ResultRow row) async {
    await _mariaDBRepository.deleteVehicleModel(row);
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
