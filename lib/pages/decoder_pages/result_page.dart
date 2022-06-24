import 'dart:convert';

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

  // 설명 부분 (DB의 첫번째 칼럼)
  List<dynamic> _description = [];
  // 해석 부분 (DB의 두번째 칼럼)
  List<dynamic> _decoder = [];

  // 해석이 끝난 후 값을 저장하기 위한 리스트 초기화
  List<Map<String, String>> _list = List.filled(12, {'title': '', 'value': ''});

  bool _isLoading = false;

  _getDecoder() async {
    setState(() {
      _isLoading = true;
    });

    // VIN을 한글자씩 나누어 리스트로 저장
    var vin = widget.result.split('');

    await _mariaDBProvider.getDecoder().then((_) {
      if (_mariaDBProvider.decoder != null) {
        // Proivder에서 DB의 vin_decoder의 json으로 된 값을 디코딩해서 리스트에 저장
        _description =
            json.decode(_mariaDBProvider.decoder![0]['data'].toString());
        _decoder = json.decode(_mariaDBProvider.decoder![1]['data'].toString());

        for (var e1 in _decoder) {
          // 3번째 digit의 code 값 반복
          for (var e2 in e1['digit'][3]['code']) {
            // VIN의 세번째 값(차종)과 code의 value가 일치하면
            if (e2['code'] == vin[3]) {
              // 마지막 6자리 숫자를 제외하고 반복
              for (int i = 0; i < vin.length - 6; i++) {
                for (var e3 in e1['digit'][i]['code']) {
                  // 전체 json 비교 후
                  // 일치하면 code의 value
                  // *이면 VIN의 해당 번째 글자와 value 함께
                  // null이면 VIN의 해당 번째 글자
                  // 그 외이면 NO DATA
                  if (e3['code'] == vin[i]) {
                    _list[i] = {
                      'title': _description[i]['title'],
                      'value': e3['value']
                    };
                  } else if (e3['code'] == '*') {
                    _list[i] = {
                      'title': _description[i]['title'],
                      'value': '${vin[i]} | ${e3['value']}'
                    };
                  } else if (e3['code'] == null && e3['value'] == null) {
                    _list[i] = {
                      'title': _description[i]['title'],
                      'value': vin[i]
                    };
                  } else {
                    _list[i] = {
                      'title': _description[i]['title'],
                      'value': 'NO DATA'
                    };
                  }
                }
              }
            }
          }
        }
        _list[11] = {
          'title': _description[11]['title'],
          'value': widget.result.substring(11, 17)
        };
        print(_list);
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
    _getDecoder();
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
      centerTitle: false,
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
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
                  width: double.maxFinite,
                  color: Colors.grey[300],
                  child: Text(
                    _list[index]['title']!,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                  child: Text(
                    _list[index]['value']!,
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
}
