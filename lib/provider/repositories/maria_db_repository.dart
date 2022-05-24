import 'dart:developer';
import 'dart:io';

import 'package:dtc_manager/model/log.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

import "package:http/http.dart" as http;
import 'dart:convert';

class MariaDBRepository {
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future getAllAcronyms(bool flag, String? value) async {
    final String url;
    url = !flag
        ? 'http://125.141.35.157:13306/acronyms/'
        : 'http://125.141.35.157:13306/acronyms?value=${value!}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['data'].isNotEmpty) {
          return jsonDecode(response.body)['data'];
        } else {
          return null;
        }
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future getAllAirbags(bool flag, String? value) async {
    final String url;
    url = !flag
        ? 'http://125.141.35.157:13306/airbags/'
        : 'http://125.141.35.157:13306/airbags?value=${value!}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['data'].isNotEmpty) {
          return jsonDecode(response.body)['data'];
        } else {
          return null;
        }
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future getAllDTCCodes(bool flag, String? value) async {
    final String url;
    url = !flag
        ? 'http://125.141.35.157:13306/dtc_codes/'
        : 'http://125.141.35.157:13306/dtc_codes?value=${value!}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['data'].isNotEmpty) {
          return jsonDecode(response.body)['data'];
        } else {
          return null;
        }
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future getDecoder() async {
    final url = 'http://125.141.35.157:13306/decoder/';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future getAllLogs(bool flag, String? filter, String? value) async {
    final String url;
    if (!flag) {
      url = 'http://125.141.35.157:13306/logs/';
    } else {
      if (filter == 'body_number') {
        final _whitespaceRE = RegExp(r"\s+");
        var split = value!.replaceAll(_whitespaceRE, ' ').split(' ');
        url =
            'http://125.141.35.157:13306/logs/number?code=${split[0]}&number=${split[1]}';
      } else {
        url =
            'http://125.141.35.157:13306/logs/filter?filter=${filter}&value=${value}';
      }
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['data'].isNotEmpty) {
          return jsonDecode(response.body)['data'];
        } else {
          return null;
        }
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future getSpecificLogs(int value) async {
    final url = 'http://125.141.35.157:13306/logs?id=${value}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['data'].isNotEmpty) {
          return jsonDecode(response.body)['data'];
        } else {
          return null;
        }
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future getLogImages(int value) async {
    final url = 'http://125.141.35.157:13306/logs/images?id=${value}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['data'].isNotEmpty) {
          return jsonDecode(response.body)['data'];
        } else {
          return null;
        }
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future getAllVehicleModels() async {
    final url = 'http://125.141.35.157:13306/models/';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future getEmailDuplicated(String value) async {
    final url = 'http://125.141.35.157:13306/users/email-exist?email=${value}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future uploadLog(Log value, List<XFile> values) async {
    final url = 'http://125.141.35.157:13306/logs/upload-log/';
    final body = {
      'date': value.date,
      'codeId': value.codeId,
      'modelId': value.modelId,
      'bodyNumber': value.bodyNumber,
      'writer': value.writer,
      'description': value.description,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['result']);
        for (var element in values) {
          await uploadImages(jsonDecode(response.body)['result'], element);
        }
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future uploadImages(int id, XFile value) async {
    final url = 'http://125.141.35.157:13306/logs/upload-image/';
    final body = {
      'id': id,
      'photo': File(value.path).readAsBytesSync(),
      'photoName': File(value.path).path.split('image_picker').last,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future checkAuthroized(String email, String token) async {
    final url = 'http://125.141.35.157:13306/users/check-authorized/';
    final body = {
      'email': email,
      'token': token,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  Future registerUser(
      String email, String username, String password, String token) async {
    final url = 'http://125.141.35.157:13306/users/register/';
    final body = {
      'email': email,
      'username': username,
      'password': password,
      'token': token,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 400) {
        throw Exception('400 Bad Request');
      } else if (response.statusCode == 401) {
        throw Exception('401 Unauthorized Request');
      } else if (response.statusCode == 403) {
        throw Exception('403 Forbidden Request');
      } else {
        throw Exception('${response.statusCode}');
      }
    } on SocketException {
      throw Exception('exception1'.tr());
    }
  }

  // Future getVehicleModel(String value) async {
  //   final conn = await MySqlConnection.connect(
  //     ConnectionSettings(
  //       host: '34.64.57.212',
  //       port: 3306,
  //       user: 'customer',
  //       db: 'dtc_manager',
  //       password: 'cpdbrrhks1234',
  //     ),
  //   );

  //   var result = await conn
  //       .query('select count(*) from models where model = ?', [value]);
  //   await conn.close();
  //   return result.toList();
  // }

  // Future getVehicleModelCode(String value) async {
  //   final conn = await MySqlConnection.connect(
  //     ConnectionSettings(
  //       host: '34.64.57.212',
  //       port: 3306,
  //       user: 'customer',
  //       db: 'dtc_manager',
  //       password: 'cpdbrrhks1234',
  //     ),
  //   );

  //   var result = await conn
  //       .query('select count(*) from models where model_code = ?', [value]);
  //   await conn.close();
  //   return result.toList();
  // }

  // Future editVehicleModel(ResultRow row, String value) async {
  //   final conn = await MySqlConnection.connect(
  //     ConnectionSettings(
  //       host: '34.64.57.212',
  //       port: 3306,
  //       user: 'customer',
  //       db: 'dtc_manager',
  //       password: 'cpdbrrhks1234',
  //     ),
  //   );

  //   var result = await conn.query(
  //       'update models set model = ? where model_id = ?',
  //       [value, row['model_id']]);
  //   await conn.close();
  // }

  // Future editVehicleModelCode(ResultRow row, String value) async {
  //   final conn = await MySqlConnection.connect(
  //     ConnectionSettings(
  //       host: '34.64.57.212',
  //       port: 3306,
  //       user: 'customer',
  //       db: 'dtc_manager',
  //       password: 'cpdbrrhks1234',
  //     ),
  //   );

  //   var result = await conn.query(
  //       'update models set model_code = ? where model_id = ?',
  //       [value, row['model_id']]);
  //   await conn.close();
  // }

  // Future addVehicleModel(List<String> value) async {
  //   final conn = await MySqlConnection.connect(
  //     ConnectionSettings(
  //       host: '34.64.57.212',
  //       port: 3306,
  //       user: 'customer',
  //       db: 'dtc_manager',
  //       password: 'cpdbrrhks1234',
  //     ),
  //   );

  //   var result = await conn.query(
  //       'insert into models (model, model_code) value (?, ?)',
  //       [value[0], value[1]]);
  //   await conn.close();
  // }

  // Future deleteVehicleModel(ResultRow row) async {
  //   final conn = await MySqlConnection.connect(
  //     ConnectionSettings(
  //       host: '34.64.57.212',
  //       port: 3306,
  //       user: 'customer',
  //       db: 'dtc_manager',
  //       password: 'cpdbrrhks1234',
  //     ),
  //   );

  //   var result = await conn
  //       .query('delete from models where model_id = ?', [row['model_id']]);
  //   await conn.close();
  // }
}
