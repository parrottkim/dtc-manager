import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class LogPage extends StatefulWidget {
  final ResultRow result;
  LogPage({Key? key, required this.result}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  late MariaDBProvider _mariaDBProvider;

  _getCacheImage(dynamic log) async {
    Uint8List image = Uint8List.fromList(log['photo'].toBytes());
    final dir = await getTemporaryDirectory();
    File file = await File('${dir.path}/${log['photo_name']}').create();
    file.writeAsBytesSync(image);
    return file;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _mariaDBProvider.getDTCCodeLogs(widget.result['code_id'] as int),
      builder: (context, snapshot) {
        if (_mariaDBProvider.log == null)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _mariaDBProvider.log!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {},
              child: ExpansionTile(
                leading: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 6.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    border: Border.all(
                      width: 0.5,
                      color: Colors.black,
                    ),
                  ),
                  child: Text(
                    '${_mariaDBProvider.log![index]['model']}',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_mariaDBProvider.log![index]['model_code']} ${_mariaDBProvider.log![index]['body_no']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy.MM.dd HH:mm')
                          .format(_mariaDBProvider.log![index]['date']),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('detailPage3-1'.tr(),
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w300)),
                        Text('${_mariaDBProvider.log![index]['writer']}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0)),
                        SizedBox(height: 10.0),
                        Divider(height: 1.0),
                        SizedBox(height: 10.0),
                        Text('detailPage3-2'.tr(),
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w300)),
                        Text('${_mariaDBProvider.log![index]['description']}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0)),
                        SizedBox(height: 10.0),
                        Divider(height: 1.0),
                        SizedBox(height: 10.0),
                        Text('detailPage3-3'.tr(),
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w300)),
                        SizedBox(height: 4.0),
                        Stack(
                          children: [
                            Image.memory(
                              Uint8List.fromList(_mariaDBProvider.log![index]
                                      ['photo']
                                  .toBytes()),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            IconButton(
                              onPressed: () async {
                                File file = await _getCacheImage(
                                    _mariaDBProvider.log![index]);
                                Share.shareFiles([file.path],
                                    text: 'Share image');
                              },
                              splashRadius: 24.0,
                              icon: Icon(Icons.share),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
