import 'package:dtc_manager/model/log.dart';
import 'package:mysql1/mysql1.dart';

class MariaDBRepository {
  Future getDTCCode(String value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
      ),
    );

    var result =
        await conn.query('select * from codes_temp where code = ?', [value]);
    await conn.close();
    return result.toList();
  }

  Future getAllDTCCodes(String? value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
      ),
    );

    var result;
    if (value == null) {
      result = await conn.query('select * from codes_temp');
    } else {
      result = await conn
          .query('select * from codes_temp where sub_system = ?', [value]);
    }
    await conn.close();
    return result.toList();
  }

  Future searchDTCCodes(String value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
      ),
    );

    var result = await conn.query(
        'select * from codes_temp where en_description like ? or kr_description like ? or code like ?',
        ['%$value%', '%$value%', '%$value%']);
    await conn.close();
    return result.toList();
  }

  Future getDTCCodeLogs(int value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
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
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
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
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
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
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
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
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
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
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
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
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
      ),
    );

    var result = await conn
        .query('delete from models where model_id = ?', [row['model_id']]);
    await conn.close();
  }

  Future getAllVehicleModels() async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
      ),
    );

    var result = await conn.query('select * from models');
    await conn.close();
    return result.toList();
  }

  Future uploadLog(Log value) async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '192.168.150.113',
        port: 3306,
        user: 'root',
        db: 'dtc_manager',
        password: 'root',
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
