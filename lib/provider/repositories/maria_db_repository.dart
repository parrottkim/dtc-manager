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

    var result = await conn.query(
        'select * from dtc_manager.dtc_codes_temp where code = ?', [flag]);
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
      result = await conn.query('select * from dtc_manager.dtc_codes_temp');
    } else {
      result = await conn.query(
          'select * from dtc_manager.dtc_codes_temp where sub_system = ?',
          [subsystem]);
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
        'select * from dtc_manager.dtc_codes_temp where en_description like ? or kr_description like ? or code like ?',
        ['%$flag%', '%$flag%', '%$flag%']);
    await conn.close();
    return result.toList();
  }

  Future getDTCCodeLogs(String flag) async {
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
        'select * from dtc_manager.dtc_codes_log where code = ? order by date desc',
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

    var result = await conn.query('select * from dtc_manager.models');
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
      'insert into dtc_manager.dtc_codes_log (date, model, body_no, code, description, photo, photo_name, writer) values (?, ?, ?, ?, ?, ?, ?, ?)',
      [
        log.date,
        log.model,
        log.bodyNo,
        log.code,
        log.description,
        log.photo.readAsBytesSync(),
        log.photoName,
        log.writer
      ],
    );
    await conn.close();
    return result;
  }
}
