import 'package:dtc_manager/model/log.dart';
import 'package:mysql1/mysql1.dart';

class MariaDBRepository {
  Future getDTCCode(String flag) async {
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
        await conn.query('select * from codes_temp where code = ?', [flag]);
    await conn.close();
    return result.toList();
  }

  Future getAllDTCCodes(String? subsystem) async {
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
    if (subsystem == null) {
      result = await conn.query('select * from codes_temp');
    } else {
      result = await conn
          .query('select * from codes_temp where sub_system = ?', [subsystem]);
    }
    await conn.close();
    return result.toList();
  }

  Future searchDTCCodes(String flag) async {
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
        ['%$flag%', '%$flag%', '%$flag%']);
    await conn.close();
    return result.toList();
  }

  Future getDTCCodeLogs(int flag) async {
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
        [flag]);
    await conn.close();
    return result.toList();
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

  Future uploadLog(Log log) async {
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
        log.date,
        log.codeId,
        log.modelId,
        log.bodyNo,
        log.writer,
        log.description,
        log.photo.readAsBytesSync(),
        log.photoName,
      ],
    );
    await conn.close();
    return result;
  }
}
