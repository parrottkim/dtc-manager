import 'dart:io';

import 'package:mysql1/mysql1.dart';

class Log {
  DateTime date;
  String model;
  String bodyNo;
  String code;
  String description;
  File photo;
  String photoName;
  String writer;

  Log(
      {required this.date,
      required this.model,
      required this.bodyNo,
      required this.code,
      required this.description,
      required this.photo,
      required this.photoName,
      required this.writer});
}
