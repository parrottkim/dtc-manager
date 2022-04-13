import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DescriptionPage extends StatefulWidget {
  DescriptionPage({Key? key}) : super(key: key);

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  late MariaDBProvider _mariaDBProvider;

  List<dynamic> _list = [];

  bool _isLoading = false;

  _loadData() async {
    setState(() {
      _isLoading = true;
    });
    await _mariaDBProvider.getDecoder().then((_) {
      if (_mariaDBProvider.decoder != null) {
        _list = _mariaDBProvider.decoder!;
      }
    }).catchError((e) => ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.message))));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && _mariaDBProvider.decoder == null) {
      return Center(child: Text('No elements'));
    }
    if (_list.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Digit',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Contents',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            shrinkWrap: true,
            itemCount: _mariaDBProvider.decoder![0]['data'].length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(left: 0.4, top: 0.4, bottom: 1.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40.0,
                        child: Text(
                          _mariaDBProvider.decoder![0]['data'][index]['digit'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      VerticalDivider(
                          width: 1, color: Colors.grey.withOpacity(0.5)),
                      SizedBox(width: 10.0),
                      Flexible(
                        child: Text(
                          _mariaDBProvider.decoder![0]['data'][index]['title'],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
