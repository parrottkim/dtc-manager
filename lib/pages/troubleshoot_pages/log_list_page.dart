import 'package:dtc_manager/pages/troubleshoot_pages/log_detail_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogListPage extends StatefulWidget {
  final Map<String, dynamic> result;
  LogListPage({Key? key, required this.result}) : super(key: key);

  @override
  State<LogListPage> createState() => _LogListPageState();
}

class _LogListPageState extends State<LogListPage> {
  late MariaDBProvider _mariaDBProvider;

  List<dynamic> _list = [];

  bool _isLoading = false;

  Future<List<dynamic>?> _getData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    await _mariaDBProvider.getSpecificLogs(widget.result['code_id']).then((_) {
      if (_mariaDBProvider.log != null) {
        _list = _mariaDBProvider.log!;
      }
    }).catchError((e) => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message))));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    return _list;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: true);

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && _mariaDBProvider.log == null) {
      return Center(child: Text('No elements'));
    }
    if (_list.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _list.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LogDetailPage(result: _list[index]),
              ),
            );
          },
          child: ListTile(
            leading: Container(
              width: 50.0,
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
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
                '${_list[index]['model']}',
                textAlign: TextAlign.center,
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
                  '${_list[index]['model_code']} ${_list[index]['body_no']}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('yyyy.MM.dd HH:mm')
                      .format(DateTime.parse(_list[index]['date'])),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ],
            ),
            trailing: Icon(Icons.arrow_right),
          ),
        );
      },
    );
  }
}
