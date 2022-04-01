import 'package:dtc_manager/model/log.dart';
import 'package:dtc_manager/provider/repositories/maria_db_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';

class MariaDBProvider extends ChangeNotifier {
  final MariaDBRepository _mariaDBRepository = MariaDBRepository();

  List<ResultRow>? _acronym;
  List<ResultRow>? get acronym => _acronym;

  List<ResultRow>? _airbag;
  List<ResultRow>? get airbag => _airbag;

  List<ResultRow>? _code;
  List<ResultRow>? get code => _code;

  List<ResultRow>? _log;
  List<ResultRow>? get log => _log;

  List<ResultRow>? _image;
  List<ResultRow>? get image => _image;

  List<ResultRow>? _modelCount;
  List<ResultRow>? get modelCount => _modelCount;

  List<ResultRow>? _modelCodeCount;
  List<ResultRow>? get modelCodeCount => _modelCodeCount;

  List<ResultRow>? _model;
  List<ResultRow>? get model => _model;

  getAllAcronyms(bool flag, String? value) async {
    _acronym = await _mariaDBRepository.getAllAcronyms(flag, value);
    notifyListeners();
  }

  getAllAirbags(bool flag, String? value) async {
    _airbag = await _mariaDBRepository.getAllAirbags(flag, value);
    notifyListeners();
  }

  getAllDTCCodes(bool flag, String? value) async {
    _code = await _mariaDBRepository.getAllDTCCodes(flag, value);
    notifyListeners();
  }

  getAllLogs(bool flag, String? filter, String? value) async {
    _log = await _mariaDBRepository.getAllLogs(flag, filter, value);
    notifyListeners();
  }

  getSpecificLogs(int flag) async {
    _log = await _mariaDBRepository.getSpecificLogs(flag);
    notifyListeners();
  }

  getLogImages(int flag) async {
    _image = await _mariaDBRepository.getLogImages(flag);
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

  uploadImages(Log log, List<XFile> values) async {
    await _mariaDBRepository.uploadImages(log, values);
    notifyListeners();
  }
}
