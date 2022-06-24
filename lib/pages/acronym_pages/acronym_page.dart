import 'package:azlistview/azlistview.dart';
import 'package:dtc_manager/constants.dart';
import 'package:dtc_manager/model/acronym.dart';
import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/provider/settings_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AcronymPage extends StatefulWidget {
  AcronymPage({Key? key}) : super(key: key);

  @override
  State<AcronymPage> createState() => _AcronymPageState();
}

class _AcronymPageState extends State<AcronymPage> {
  late MariaDBProvider _mariaDBProvider;
  late SettingsProvider _settingsProvider;

  // TextField를 사용하기 위한 controller
  late TextEditingController _textEditingController;
  // 키보드 포커스를 위한 오브젝트
  late FocusNode _focusNode;

  // 약어 목록 List 초기화
  List<Acronym> _acronyms = [];

  // 약어 목록 로딩 중인지 여부
  bool _isLoading = false;
  // 약어 목록 검색 중인지 여부
  bool _isSearching = false;

  _loadData() async {
    setState(() {
      // 약어 목록 로딩 여부 true
      _isLoading = true;
    });

    // MariaDBProvider에 약어 목록 요청
    await _mariaDBProvider
        .getAllAcronyms(_isSearching, _textEditingController.text)
        // 성공 시
        .then((_) {
      // json 형식으로 파싱
      _mariaDBProvider.acronym!
          .toList()
          .map((e) => e.fields)
          .toList()
          .forEach((element) {
        _acronyms.add(Acronym.fromJson(element));
      });
      // 알파벳 순 정렬 (AzListView 패키지 https://pub.dev/packages/azlistview)
      _handleList(_acronyms);
    })
        // 에러 발생 시
        .catchError((e) =>
            // 스낵바 (토스트) 출력
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.message))));

    setState(() {
      // 약어 목록 로딩 여부 falseㄴ
      _isLoading = false;
    });
  }

  // 알파벳 순 정렬 (AzListView 패키지 https://pub.dev/packages/azlistview)
  _handleList(List<Acronym> list) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String tag = list[i].name.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // // A-Z sort.
    // SuspensionUtil.sortListBySuspensionTag(_acronyms);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(_acronyms);

    // // add header.
    // _acronyms.insert(0, Acronym(name: 'header', tagIndex: '↑'));
    setState(() {});
  }

  // 알파벳 순 정렬 (AzListView 패키지 https://pub.dev/packages/azlistview)
  Widget getSusItem(BuildContext context, String tag, {double susHeight = 40}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  Widget _listItem(Acronym model) {
    String susTag = model.getSuspensionTag();
    late String description;

    // SettingsProvider에 현재 설명 언어(한/영) 값 요청 후
    // both이면 description = 한/영 모두
    // enUs이면 description = 영어
    // 아니면 description = 한글
    if (_settingsProvider.dtcLocale == DTCLocalization.both) {
      description = '${model.descriptionEn}\n${model.descriptionKr}';
    } else if (_settingsProvider.dtcLocale == DTCLocalization.enUS) {
      description = '${model.descriptionEn}';
    } else {
      description = '${model.descriptionKr}';
    }

    // 변환한 description을 포함한 Widget 리턴
    return Column(
      children: <Widget>[
        // Offstage(
        //   offstage: model.isShowSuspension != true,
        //   child: _buildSusWidget(susTag),
        // ),
        ListTile(
          title: Text(model.name),
          subtitle: Text(description),
        )
      ],
    );
  }

  // 이 페이지가 처음 호출될 때 호출
  @override
  void initState() {
    super.initState();
    // 초기화
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    _loadData();
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
      title: MainLogo(subtitle: 'homePage1'.tr()),
    );
  }

  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _searchWidget(), // 검색 Widget
        SizedBox(height: 6.0),
        _acronymList(), // 리스트 Widget
      ],
    );
  }

  Widget _searchWidget() {
    return Container(
      // 바깥 영역 여백
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: TextField(
        controller:
            _textEditingController, // TextField 값이 업데이트 될 때마다 해당 controller로 알림
        focusNode: _focusNode, // 키보드 및 TextField 포커스 관리
        decoration: // TextField 장식
            InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          label: Text('homePage1-1').tr(),
          suffixIcon: // TextField 끝에 붙는 아이콘
              IconButton(
            splashRadius: 24.0,
            icon: Icon(Icons.search),
            // 버튼 클릭 시
            onPressed: () {
              if (_textEditingController.text.isNotEmpty) {
                setState(() {
                  // 약어 목록 검색 여부 true
                  _isSearching = true;
                  // 기존 약어 목록 삭제
                  _acronyms.clear();
                  // 검색어로 다시 약어 목록 로딩
                  _loadData();
                });
              }
            },
          ),
        ),
        // 키보드에서 '확인' 버튼 클릭 시
        onSubmitted: (value) {
          // 현재 TextField 포커스 해제
          _focusNode.unfocus();
          // controller에게 TextField의 text가 null인지 확인
          if (_textEditingController.text.isNotEmpty) {
            setState(() {
              // 약어 목록 검색 여부 true
              _isSearching = true;
              // 기존 약어 목록 삭제
              _acronyms.clear();
              // 검색어로 다시 약어 목록 로딩
              _loadData();
            });
          }
        },
      ),
    );
  }

  Widget _acronymList() {
    // 약어 목록 로딩 중이 아닐 때, 약어 목록이 없으면
    if (!_isLoading && _mariaDBProvider.acronym == null) {
      return Expanded(child: Center(child: Text('No elements')));
    }
    // 약어 목록 List가 비었으면
    if (_acronyms.isEmpty) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    } else {
      return Expanded(
        // 알파벳 정렬 리스트 (AzListView 패키지 https://pub.dev/packages/azlistview)
        child: AzListView(
          data: _acronyms,
          itemCount: _acronyms.length,
          // 리스트에 그려질 child Widget을 반복해서 그림
          itemBuilder: (context, index) {
            return _listItem(_acronyms[index]);
          },
          // 알파벳 헤더를 반복해서 그림
          susItemBuilder: (context, index) {
            Acronym acronym = _acronyms[index];
            return getSusItem(context, acronym.getSuspensionTag());
          },
          // 리스트 오른쪽 알파벳 리스트
          indexBarData: SuspensionUtil.getTagIndexList(_acronyms),
          indexBarOptions: IndexBarOptions(
            needRebuild: true,
            ignoreDragCancel: true,
            downTextStyle: TextStyle(fontSize: 12, color: Colors.white),
            downItemDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
            ),
            indexHintWidth: 120 / 2,
            indexHintHeight: 100 / 2,
            indexHintAlignment: Alignment.centerRight,
            indexHintChildAlignment: Alignment(-0.25, 0.0),
            indexHintOffset: Offset(-10, 0),
          ),
          // 리스트 오른쪽 알파벳 리스트 클릭 및 드래그시 나타나는 Widget
          indexHintBuilder: (context, hint) {
            return Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Text(hint,
                      style: TextStyle(color: Colors.white, fontSize: 30.0)),
                ),
              ],
            );
          },
          // indexBarMargin: EdgeInsets.all(10),
          // indexBarOptions: IndexBarOptions(
          //   needRebuild: true,
          //   decoration: getIndexBarDecoration(Colors.grey[50]!),
          //   downDecoration: getIndexBarDecoration(Colors.grey[200]!),
          // ),
        ),
      );
    }
  }

  Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300]!, width: .5));
  }
}
