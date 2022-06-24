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
  late MariaDBProvider _mariaDBProvider;
  late SettingsProvider _settingsProvider;

  List<dynamic> _list = [];

  // 필터 리스트
  late List<dynamic> _filters;
  // 선택한 필터
  String? _selectedFilter;

  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  bool _isLoading = false;
  bool _isSearching = false;

  Future<List<dynamic>?> _getData() async {
    setState(() {
      _isLoading = true;
    });
    // MariaDBProvider에 DTC 목록 요청
    await _mariaDBProvider
        .getAllDTCCodes(_isSearching, _textEditingController.text)
        // 성공 시
        .then((_) {
      if (_mariaDBProvider.code != null) {
        // 검색 중이 아니고, 필터가 선택된 상태이면
        if (!_isSearching && _selectedFilter != null) {
          // foreach 문으로 DTC 목록 하나씩 반복
          for (var element in _mariaDBProvider.code!) {
            // 선택된 필터와 같은 DTC 코드면
            if (element['sub_system'].toString() == _selectedFilter) {
              // 리스트에 추가
              _list.add(element);
            }
          }
        } else {
          // 그 외인 경우, 모든 DTC 코드를 리스트에 추가
          _list = _mariaDBProvider.code!;
        }
      }
    }).catchError((e) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message))));
    setState(() {
      _isLoading = false;
    });
    return _list;
  }

  @override
  void initState() {
    super.initState();
    // 필터 리스트 초기화
    _filters = [
      {
        'title': 'homePage4-1'.tr(), // 필터 명
        'flag': 'Powertrain', // 필터 변수
        'bool': false, // 필터 선택 여부
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
      centerTitle: false,
      titleSpacing: 0.0,
      title: MainLogo(subtitle: 'homePage4'.tr()),
    );
  }

  // AppBar 버튼 클릭 시, 설정 화면으로 이동 하기 위한 부분
  // List<Widget>? _appBarActions() {
  //   return [
  //     PopupMenuButton(
  //       icon: Icon(Icons.more_vert),
  //       itemBuilder: (context) {
  //         return [
  //           PopupMenuItem(
  //             value: 0,
  //             child: ListTile(
  //               minLeadingWidth: 0.0,
  //               leading: Icon(Icons.settings),
  //               title: Text('settings'.tr()),
  //             ),
  //           ),
  //         ];
  //       },
  //       onSelected: (value) {
  //         if (value == 0) {
  //           Navigator.of(context)
  //               .push(MaterialPageRoute(builder: (_) => SettingsPage()));
  //         }
  //       },
  //     ),
  //   ];
  // }

  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _filterButton(), // 필터 버튼 Widget
        SizedBox(height: 12.0),
        _searchWidget(), // 검색 Widget
        SizedBox(height: 6.0),
        _dtcCodeList(), // DTC 리스트 Widget
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
                // 필터 버튼 클릭 시
                onTap: () {
                  setState(() {
                    _isSearching = false;
                    _textEditingController.clear();

                    for (int i = 0; i < _filters.length; i++) {
                      if (i == index) {
                        // 필터 리스트의 필터 선택 여부 reverse
                        _filters[i]['bool'] = !_filters[i]['bool'];

                        // 필터 선택 여부가 true이면 selectedFilter 변수에 필터 변수 저장 / false이면 selectedFilter 변수에 null 저장
                        _filters[i]['bool']
                            ? _selectedFilter = _filters[i]['flag']
                            : _selectedFilter = null;
                      } else {
                        // 나머지 필터는 false로 변경
                        _filters[i]['bool'] = false;
                      }
                    }

                    // DTC 리스트 삭제 후
                    _list.clear();
                    // 선택한 조건으로 DTC 리스트 로드
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
                        // 필터 선택 여부가 false이면 테두리 black / true이면 테두리 투명
                        color: !_filters[index]['bool']
                            ? Colors.black
                            : Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    // 필터 선택 여부가 false이면 배경색 투명 / true이면 배경색 black
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

                  // 모든 필터 선택 여부 false (필터 초기화)
                  for (int i = 0; i < _filters.length; i++) {
                    _filters[i]['bool'] = false;
                  }

                  _list.clear();
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

              // 모든 필터 선택 여부 false (필터 초기화)
              for (int i = 0; i < _filters.length; i++) {
                _filters[i]['bool'] = false;
              }

              _list.clear();
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
    if (_list.isEmpty) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    }
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _list.length,
        itemBuilder: (context, index) {
          late String description;
          if (_settingsProvider.dtcLocale == DTCLocalization.both) {
            description =
                '${_list[index]['en_description']}\n${_list[index]['kr_description']}';
          } else if (_settingsProvider.dtcLocale == DTCLocalization.enUS) {
            description = '${_list[index]['en_description']}';
          } else {
            description = '${_list[index]['kr_description']}';
          }

          return ListTile(
            onTap: () {
              _mariaDBProvider.getAllVehicleModels();
              // 리스트 클릭 시, DetailPage로 이동
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailPage(result: _list[index]),
                ),
              );
            },
            title: Text('${_list[index]['dtc_code']}'),
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
