import 'dart:io';

import 'package:dtc_manager/model/log.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';

class MariaDBRepository {
  String ipAddress = '192.168.150.100';
  int port = 1300;

  Future getAllAcronyms(bool flag, String? value) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: ipAddress,
          port: port,
          user: 'user',
          db: 'dtc_manager',
          password: 'dantech',
        ),
      );

      var result;
      if (!flag) {
        result = await conn.query('select * from acronyms');
      } else {
        result = await conn.query(
            'select * from acronyms where en_description like ? or kr_description like ? or acronym like ?',
            ['%$value%', '%$value%', '%$value%']);
      }
      await conn.close();

      if (result.isEmpty) {
        return null;
      } else {
        return result.toList();
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getAllAirbags(bool flag, String? value) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: ipAddress,
          port: port,
          user: 'user',
          db: 'dtc_manager',
          password: 'dantech',
        ),
      );

      var result;
      if (!flag) {
        result = await conn.query('select * from airbags');
      } else {
        result = await conn.query(
            'select * from airbags where en_description like ? or kr_description like ? or airbag like ?',
            ['%$value%', '%$value%', '%$value%']);
      }
      await conn.close();

      if (result.isEmpty) {
        return null;
      } else {
        return result.toList();
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getAllDTCCodes(bool flag, String? value) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: ipAddress,
          port: port,
          user: 'user',
          db: 'dtc_manager',
          password: 'dantech',
        ),
      );

      var result;
      if (!flag) {
        result = await conn.query('select * from codes');
      } else {
        result = await conn.query(
            'select * from codes where en_description like ? or kr_description like ? or code like ?',
            [
              '%$value%',
              '%$value%',
              '%$value%',
            ]);
      }
      await conn.close();

      if (result.isEmpty) {
        return null;
      } else {
        return result.toList();
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getDecoder() async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: ipAddress,
          port: port,
          user: 'user',
          db: 'dtc_manager',
          password: 'dantech',
        ),
      );

      var result = await conn.query('select data from vin_decoder');
      await conn.close();

      if (result.isEmpty) {
        return null;
      } else {
        return result.toList();
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getAllLogs(bool flag, String? filter, String? value) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: ipAddress,
          port: port,
          user: 'user',
          db: 'dtc_manager',
          password: 'dantech',
        ),
      );

      var result;
      if (!flag) {
        result = await conn.query(
            'select * from logs left join models on logs.model_id = models.model_id left join codes on logs.code_id = codes.code_id order by date desc');
      } else {
        if (filter == 'body_number') {
          final _whitespaceRE = RegExp(r"\s+");
          var split = value!.replaceAll(_whitespaceRE, ' ').split(' ');
          print(split);
          result = await conn.query(
              'select * from logs left join models on logs.model_id = models.model_id left join codes on logs.code_id = codes.code_id where model_code = ? and body_no = ?',
              [split[0], split[1]]);
        } else {
          result = await conn.query(
              'select * from logs left join models on logs.model_id = models.model_id left join codes on logs.code_id = codes.code_id where ${filter} like ?',
              ['%${value}%']);
        }
      }
      await conn.close();
      return result.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getSpecificLogs(int value) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: ipAddress,
          port: port,
          user: 'user',
          db: 'dtc_manager',
          password: 'dantech',
        ),
      );

      var result = await conn.query(
          'select * from logs left join models on logs.model_id = models.model_id where code_id = ? order by date desc',
          [value]);
      await conn.close();
      return result.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getLogImages(int value) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: ipAddress,
          port: port,
          user: 'user',
          db: 'dtc_manager',
          password: 'dantech',
        ),
      );

      var result = await conn.query(
          'select * from logs right join log_images on logs.log_id = log_images.log_id where logs.log_id = ?',
          [value]);
      await conn.close();
      return result.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getVehicleModel(String value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: ipAddress,
        port: port,
        user: 'customer',
        db: 'dtc_manager',
        password: 'cpdbrrhks1234',
      ),
    );

    var result = await conn
        .query('select count(*) from models where model = ?', [value]);
    await conn.close();
    return result.toList();
  }

  Future getVehicleModelCode(String value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: ipAddress,
        port: port,
        user: 'customer',
        db: 'dtc_manager',
        password: 'cpdbrrhks1234',
      ),
    );

    var result = await conn
        .query('select count(*) from models where model_code = ?', [value]);
    await conn.close();
    return result.toList();
  }

  Future editVehicleModel(ResultRow row, String value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: ipAddress,
        port: port,
        user: 'customer',
        db: 'dtc_manager',
        password: 'cpdbrrhks1234',
      ),
    );

    var result = await conn.query(
        'update models set model = ? where model_id = ?',
        [value, row['model_id']]);
    await conn.close();
  }

  Future editVehicleModelCode(ResultRow row, String value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: ipAddress,
        port: port,
        user: 'customer',
        db: 'dtc_manager',
        password: 'cpdbrrhks1234',
      ),
    );

    var result = await conn.query(
        'update models set model_code = ? where model_id = ?',
        [value, row['model_id']]);
    await conn.close();
  }

  Future addVehicleModel(List<String> value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: ipAddress,
        port: port,
        user: 'customer',
        db: 'dtc_manager',
        password: 'cpdbrrhks1234',
      ),
    );

    var result = await conn.query(
        'insert into models (model, model_code) value (?, ?)',
        [value[0], value[1]]);
    await conn.close();
  }

  Future deleteVehicleModel(ResultRow row) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: ipAddress,
        port: port,
        user: 'customer',
        db: 'dtc_manager',
        password: 'cpdbrrhks1234',
      ),
    );

    var result = await conn
        .query('delete from models where model_id = ?', [row['model_id']]);
    await conn.close();
  }

  Future getAllVehicleModels() async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: ipAddress,
          port: port,
          user: 'user',
          db: 'dtc_manager',
          password: 'dantech',
        ),
      );

      var result = await conn.query('select * from models');
      await conn.close();
      return result.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future uploadLog(Log value) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: ipAddress,
          port: port,
          user: 'user',
          db: 'dtc_manager',
          password: 'dantech',
        ),
      );

      var result = await conn.query(
        'insert into logs (date, code_id, model_id, body_no, writer, description) values (?, ?, ?, ?, ?, ?)',
        [
          value.date,
          value.codeId,
          value.modelId,
          value.bodyNumber,
          value.writer,
          value.description,
        ],
      );
      await conn.close();
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future uploadImages(Log value, List<XFile> values) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: ipAddress,
          port: port,
          user: 'user',
          db: 'dtc_manager',
          password: 'dantech',
        ),
      );

      var select = await conn.query(
          'select log_id from logs where date = ? and code_id = ? and model_id = ? and body_no = ? and writer = ? and description = ?',
          [
            value.date,
            value.codeId,
            value.modelId,
            value.bodyNumber,
            value.writer,
            value.description,
          ]);

      var insert;

      for (var element in values) {
        insert = await conn.query(
          'insert into log_images (log_id, photo, photo_name) values (?, ?, ?)',
          [
            select.first['log_id'],
            File(element.path).readAsBytesSync(),
            File(element.path).path.split('image_picker').last,
          ],
        );
      }
      await conn.close();
      return insert;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
