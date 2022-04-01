import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtc_manager/constants.dart';
import 'package:dtc_manager/pages/settings_pages/settings_page.dart';
import 'package:dtc_manager/pages/troubleshoot_pages/detail_page.dart';
import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/provider/settings_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CodeListPage extends StatefulWidget {
  CodeListPage({Key? key}) : super(key: key);

  @override
  State<CodeListPage> createState() => _CodeListPageState();
}

class _CodeListPageState extends State<CodeListPage> {
  final firestore = FirebaseFirestore.instance;

  late MariaDBProvider _mariaDBProvider;
  late SettingsProvider _settingsProvider;

  List<dynamic>? _list = [];

  late List<dynamic> _filters;
  String? _selectedFilter;

  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  bool _isLoading = false;
  bool _isSearching = false;

  Future<List<dynamic>?> _getData() async {
    setState(() {
      _isLoading = true;
    });
    await _mariaDBProvider.getAllDTCCodes(
        _isSearching, _textEditingController.text);

    if (_mariaDBProvider.code != null) {
      if (!_isSearching && _selectedFilter != null) {
        for (var element in _mariaDBProvider.code!) {
          if (element['sub_system'].toString() == _selectedFilter) {
            _list!.add(element);
          }
        }
      } else {
        _list = _mariaDBProvider.code!;
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
        'title': 'homePage4-1'.tr(),
        'flag': 'Powertrain',
        'bool': false,
      },
      {
        'title': 'homePage4-2'.tr(),
        'flag': 'Network',
        'bool': false,
      },
      {
        'title': 'homePage4-3'.tr(),
        'flag': 'Chassis',
        'bool': false,
      },
      {
        'title': 'homePage4-4'.tr(),
        'flag': 'Body',
        'bool': false,
      },
      {
        'title': 'homePage4-5'.tr(),
        'flag': 'Multimedia',
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
      title: MainLogo(subtitle: 'homePage4'.tr()),
    );
  }

  List<Widget>? _appBarActions() {
    return [
      PopupMenuButton(
        icon: Icon(Icons.more_vert),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 0,
              child: ListTile(
                minLeadingWidth: 0.0,
                leading: Icon(Icons.settings),
                title: Text('settings'.tr()),
              ),
            ),
          ];
        },
        onSelected: (value) {
          if (value == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => SettingsPage()));
          }
        },
      ),
    ];
  }

  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _filterButton(),
        SizedBox(height: 12.0),
        _searchWidget(),
        SizedBox(height: 6.0),
        _dtcCodeList(),
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
                      } else {
                        _filters[i]['bool'] = false;
                      }
                    }

                    _list!.clear();
                    _getData();
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
      child: TextField(
        controller: _textEditingController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          label: Text('homePage4-6').tr(),
          suffixIcon: IconButton(
            splashRadius: 24.0,
            icon: Icon(Icons.search),
            onPressed: () {
              if (_textEditingController.text.isNotEmpty) {
                setState(() {
                  _isSearching = true;
                  _selectedFilter = null;
                  for (int i = 0; i < _filters.length; i++) {
                    _filters[i]['bool'] = false;
                  }

                  if (_list != null) _list!.clear();
                  _getData();
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
              _selectedFilter = null;
              for (int i = 0; i < _filters.length; i++) {
                _filters[i]['bool'] = false;
              }

              if (_list != null) _list!.clear();
              _getData();
            });
          }
        },
      ),
    );
  }

  Widget _dtcCodeList() {
    if (!_isLoading && _mariaDBProvider.code == null) {
      return Expanded(child: Center(child: Text('No elements')));
    }
    if (_list == null) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    }
    return Expanded(
      child: ListView.builder(
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

          return ListTile(
            onTap: () {
              _mariaDBProvider.getAllVehicleModels();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailPage(result: _list![index]),
                ),
              );
            },
            title: Text('${_list![index]['code']}'),
            subtitle: Text(description,
                maxLines:
                    _settingsProvider.dtcLocale == DTCLocalization.both ? 2 : 1,
                overflow: TextOverflow.ellipsis),
            trailing: Icon(Icons.arrow_right),
          );
        },
      ),
    );
  }
}
