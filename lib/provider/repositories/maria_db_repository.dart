import 'package:dtc_manager/model/log.dart';
import 'package:mysql1/mysql1.dart';

class MariaDBRepository {
  Future getAllAcronyms(bool flag, String? value) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: '34.64.57.212',
          port: 3306,
          user: 'customer',
          db: 'dtc_manager',
          password: 'cpdbrrhks1234',
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

      if (result.isEmpty)
        return null;
      else
        return result.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getAllDTCCodes(bool flag, String? value) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: '34.64.57.212',
          port: 3306,
          user: 'customer',
          db: 'dtc_manager',
          password: 'cpdbrrhks1234',
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

      if (result.isEmpty)
        return null;
      else
        return result.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getAllLogs(bool flag, String? value) async {
    try {
      final conn = await MySqlConnection.connect(
        ConnectionSettings(
          host: '34.64.57.212',
          port: 3306,
          user: 'customer',
          db: 'dtc_manager',
          password: 'cpdbrrhks1234',
        ),
      );
      var result;
      if (!flag) {
        result = await conn.query(
            'select * from logs left join models on logs.model_id = models.model_id left join codes on logs.code_id = codes.code_id order by date desc');
      } else {
        result = await conn.query(
            'select * from logs left join models on logs.model_id = models.model_id where code_id = ? order by date desc',
            [value]);
      }
      await conn.close();
      return result.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getSpecificDTCLogs(int value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '34.64.57.212',
        port: 3306,
        user: 'customer',
        db: 'dtc_manager',
        password: 'cpdbrrhks1234',
      ),
    );

    var result = await conn.query(
        'select * from logs left join models on logs.model_id = models.model_id where code_id = ? order by date desc',
        [value]);
    await conn.close();
    return result.toList();
  }

  Future getVehicleModel(String value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '34.64.57.212',
        port: 3306,
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
        host: '34.64.57.212',
        port: 3306,
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
        host: '34.64.57.212',
        port: 3306,
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
        host: '34.64.57.212',
        port: 3306,
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
        host: '34.64.57.212',
        port: 3306,
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
        host: '34.64.57.212',
        port: 3306,
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
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '34.64.57.212',
        port: 3306,
        user: 'customer',
        db: 'dtc_manager',
        password: 'cpdbrrhks1234',
      ),
    );

    var result = await conn.query('select * from models');
    await conn.close();
    return result.toList();
  }

  Future uploadLog(Log value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '34.64.57.212',
        port: 3306,
        user: 'customer',
        db: 'dtc_manager',
        password: 'cpdbrrhks1234',
      ),
    );

    var result = await conn.query(
      'insert into logs (date, code_id, model_id, body_no, writer, description, photo, photo_name) values (?, ?, ?, ?, ?, ?, ?, ?)',
      [
        value.date,
        value.codeId,
        value.modelId,
        value.bodyNo,
        value.writer,
        value.description,
        value.photo.readAsBytesSync(),
        value.photoName,
      ],
    );
    await conn.close();
    return result;
  }
}
