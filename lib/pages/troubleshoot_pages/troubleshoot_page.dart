import 'package:dtc_manager/constants.dart';
import 'package:dtc_manager/pages/detail_pages/detail_page.dart';
import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/provider/settings_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

class TroubleshootPage extends StatefulWidget {
  TroubleshootPage({Key? key}) : super(key: key);

  @override
  State<TroubleshootPage> createState() => _TroubleshootPageState();
}

class _TroubleshootPageState extends State<TroubleshootPage> {
  late MariaDBProvider _mariaDBProvider;
  late SettingsProvider _settingsProvider;

  List<dynamic>? _list = [];

  late List<dynamic> _filters;
  String? _selectedFilter;

  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  bool _isLoading = false;
  bool _isSearching = false;
  bool _isFilterSelected = false;

  Future<List<dynamic>?> _getData() async {
    setState(() {
      _isLoading = true;
    });
    await _mariaDBProvider.getAllLogs(
        _isSearching, _textEditingController.text);

    if (_mariaDBProvider.log != null) {
      if (!_isSearching && _selectedFilter != null) {
        for (var element in _mariaDBProvider.log!) {
          if (element['sub_system'].toString() == _selectedFilter) {
            _list!.add(element);
          }
        }
      } else {
        _list = _mariaDBProvider.log!;
      }
    } else {
      _list = null;
    }
    setState(() {
      _isLoading = false;
    });
    return _list;
  }

  @override
  void initState() {
    super.initState();
    _filters = [
      {
        'title': 'homePage5-1'.tr(),
        'flag': 'Powertrain',
        'bool': false,
      },
      {
        'title': 'homePage5-2'.tr(),
        'flag': 'Network',
        'bool': false,
      },
      {
        'title': 'homePage5-3'.tr(),
        'flag': 'Chassis',
        'bool': false,
      },
      {
        'title': 'homePage5-4'.tr(),
        'flag': 'Body',
        'bool': false,
      },
    ];

    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    _getData();
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
      title: MainLogo(subtitle: 'homePage5'.tr()),
    );
  }

  Widget _bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _filterButton(),
        _isFilterSelected ? _searchWidget() : SizedBox(),
        SizedBox(height: 6.0),
        _resultWidget(),
      ],
    );
  }

  Widget _filterButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(Icons.tune, size: 16.0),
              SizedBox(width: 4.0),
              Text('Filters',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        SizedBox(height: 6.0),
        SizedBox(
          height: 24.0,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _isSearching = false;
                    _textEditingController.clear();

                    for (int i = 0; i < _filters.length; i++) {
                      if (i == index) {
                        _filters[i]['bool'] = !_filters[i]['bool'];

                        _filters[i]['bool']
                            ? _selectedFilter = _filters[i]['flag']
                            : _selectedFilter = null;
                        _filters[i]['bool']
                            ? _isFilterSelected = true
                            : _isFilterSelected = false;
                      } else {
                        _filters[i]['bool'] = false;
                      }
                    }
                    FocusScope.of(context).requestFocus(_focusNode);
                  });
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5,
                        color: !_filters[index]['bool']
                            ? Colors.black
                            : Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: !_filters[index]['bool']!
                        ? Colors.transparent
                        : Colors.black,
                  ),
                  child: Text(
                    _filters[index]['title'],
                    style: TextStyle(
                      fontSize: 14.0,
                      color: !_filters[index]['bool']
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 6.0),
          ),
        ),
      ],
    );
  }

  Widget _searchWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Center(
        child: TextField(
          controller: _textEditingController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            suffix: IconButton(
              splashRadius: 24.0,
              icon: Icon(Icons.search),
              onPressed: () {
                if (_textEditingController.text.isNotEmpty) {
                  setState(() {
                    _isSearching = true;
                  });
                }
              },
            ),
          ),
          onSubmitted: (value) {
            _focusNode.unfocus();
            if (_textEditingController.text.isNotEmpty) {
              setState(() {
                _isSearching = true;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _resultWidget() {
    if (!_isLoading && _mariaDBProvider.log == null) {
      return Expanded(child: Center(child: Text('No elements')));
    }
    if (_list == null) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    }
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        shrinkWrap: true,
        itemCount: _list!.length,
        itemBuilder: (context, index) {
          late String description;
          if (_settingsProvider.dtcLocale == DTCLocalization.both) {
            description =
                '${_list![index]['en_description']}\n${_list![index]['kr_description']}';
          } else if (_settingsProvider.dtcLocale == DTCLocalization.enUS) {
            description = '${_list![index]['en_description']}';
          } else {
            description = '${_list![index]['kr_description']}';
          }

          return Card(
            child: InkWell(
              onTap: () {
                _mariaDBProvider.getAllVehicleModels();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DetailPage(result: _list![index]),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50.0,
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
                            '${_list![index]['model']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.0),
                        Container(
                          width: 90.0,
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
                            '${_list![index]['model_code']} ${_list![index]['body_no']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            getDetailDate(_list![index]['date']),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      '${_list![index]['code']}',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      description,
                      maxLines:
                          _settingsProvider.dtcLocale == DTCLocalization.both
                              ? 2
                              : 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      '•  ${_list![index]['writer']}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
