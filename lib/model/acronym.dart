import 'package:azlistview/azlistview.dart';
import 'package:mysql1/mysql1.dart';

class Acronym extends ISuspensionBean {
  String name;
  String? tagIndex;

  String? descriptionEn;
  String? descriptionKr;

  Acronym(
      {required this.name,
      this.tagIndex,
      this.descriptionEn,
      this.descriptionKr});

  Acronym.fromJson(Map<String, dynamic> json)
      : name = json['acronym'].toString(),
        descriptionEn = json['en_description'].toString(),
        descriptionKr = json['kr_description'].toString();

  @override
  String getSuspensionTag() => tagIndex!;
}
