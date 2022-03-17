import 'dart:io';

import 'package:mysql1/mysql1.dart';

class Log {
  DateTime date;
  int codeId;
  int modelId;
  String bodyNo;
  String writer;
  String description;
  File photo;
  String photoName;

  Log(
      {required this.date,
      required this.codeId,
      required this.modelId,
      required this.bodyNo,
      required this.writer,
      required this.description,
      required this.photo,
      required this.photoName});
}
