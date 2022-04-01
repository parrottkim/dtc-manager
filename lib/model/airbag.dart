import 'package:azlistview/azlistview.dart';

class Airbag extends ISuspensionBean {
  String name;
  String? tagIndex;

  String? descriptionEn;
  String? descriptionKr;

  Airbag(
      {required this.name,
      this.tagIndex,
      this.descriptionEn,
      this.descriptionKr});

  Airbag.fromJson(Map<String, dynamic> json)
      : name = json['airbag'].toString(),
        descriptionEn = json['en_description'].toString(),
        descriptionKr = json['kr_description'].toString();

  @override
  String getSuspensionTag() => tagIndex!;
}
