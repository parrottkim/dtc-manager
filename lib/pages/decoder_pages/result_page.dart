import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  final String result;
  ResultPage({Key? key, required this.result}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late MariaDBProvider _mariaDBProvider;

  _getDecoder() {
    var vin = widget.result.split('');
    List<Map<String, String>> list =
        List.filled(12, {'title': '', 'value': ''});
    for (var e1 in _mariaDBProvider.decoder![1]['data']) {
      for (var e2 in e1['digit'][3]['code']) {
        if (e2['code'] == vin[3]) {
          for (int i = 0; i < vin.length - 6; i++) {
            for (var e3 in e1['digit'][i]['code']) {
              if (e3['code'] == vin[i]) {
                list[i] = {
                  'title': _mariaDBProvider.decoder![0]['data'][i]['title'],
                  'value': e3['value']
                };
              } else if (e3['code'] == '*') {
                list[i] = {
                  'title': _mariaDBProvider.decoder![0]['data'][i]['title'],
                  'value': '${vin[i]} | ${e3['value']}'
                };
              } else if (e3['code'] == null && e3['value'] == null) {
                list[i] = {
                  'title': _mariaDBProvider.decoder![0]['data'][i]['title'],
                  'value': vin[i]
                };
              } else {
                list[i] = {
                  'title': _mariaDBProvider.decoder![0]['data'][i]['title'],
                  'value': 'NO DATA'
                };
              }
            }
          }
        }
      }
    }
    list[11] = {
      'title': _mariaDBProvider.decoder![0]['data'][11]['title'],
      'value': widget.result.substring(11, 17)
    };
    return list;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: _bodyWidget(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      titleSpacing: 0.0,
      title: MainLogo(subtitle: 'homePage3'.tr()),
    );
  }

  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _number(),
        _items(),
      ],
    );
  }

  Widget _number() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 26.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VIN',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            widget.result,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _items() {
    var list = _getDecoder();
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                width: double.maxFinite,
                color: Colors.grey[300],
                child: Text(
                  list[index]['title'],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                child: Text(
                  list[index]['value'],
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 10.0);
        },
      ),
    );
  }
}
