import 'package:dtc_manager/constants.dart';
import 'package:dtc_manager/pages/acronym_pages/acronym_page.dart';
import 'package:dtc_manager/pages/airbag_pages/airbag_page.dart';
import 'package:dtc_manager/pages/code_list_pages/code_list_page.dart';
import 'package:dtc_manager/pages/decoder_pages/decoder_page.dart';
import 'package:dtc_manager/pages/settings_pages/settings_page.dart';
import 'package:dtc_manager/pages/troubleshoot_pages/troubleshoot_page.dart';
import 'package:dtc_manager/provider/settings_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Provider 선언 (didChangeDependencies 에서 초기화 필수)
  late SettingsProvider _settingsProvider;

  // ListView에 사용할 Map<페이지 타이틀, 페이지 Widget> 선언
  late Map<Widget, Widget?> _pages;
  // Drawer에 사용할 List<아이콘, 타이틀, 페이지 Widget> 선언
  late List<dynamic> _drawerItems;

  // 앱 실행 시 초기 세팅 값 확인
  _checkSettings() async {
    // SharedPreference (앱 내부에 단순 데이터 저장/불러오기 패키지, ini처럼 활용 https://pub.dev/packages/shared_preferences) 초기화
    final prefs = await SharedPreferences.getInstance();
    // dtcLocale(앱 기본 언어)이란 값이 null이 아니면
    if (prefs.getString('dtcLocale') != null) {
      var locale = EnumToString.fromString(
          DTCLocalization.values, prefs.getString('dtcLocale')!)!;

      setState(() {
        // SettingsProivder에서 언어 변경 요청
        _settingsProvider.changeDTCLocalization(locale);
      }); // 내부 상태 변경 알림 (build를 다시 호출하여 앱 다시 그리기)
    }
  }

  // 열린 Drawer에서 리스트 클릭
  _drawerNavigate(BuildContext context, Widget page) async {
    // 최상위 화면 닫기 (Drawer 닫기)
    Navigator.of(context).pop();
    // parameter로 받은 page로 이동
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Provider 초기화
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    // 앱 실행 시 초기 세팅 값 확인
    _checkSettings();
  }

  // UI 부분
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: _bodyWidget(),
        drawer: _drawerWidget(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: false, // 타이틀 가운데 정렬 false
      titleSpacing: 0.0, // 타이틀 여백 0.0
      title: MainLogo(), // 타이틀
    );
  }

  Widget _bodyWidget() {
    // ListView에 사용할 Map<페이지 타이틀, 페이지 Widget> 초기화
    _pages = {
      Text('homePage1').tr(): AcronymPage(),
      Text('homePage2').tr(): AirbagPage(),
      Text('homePage3').tr(): DecoderPage(),
      Text('homePage4').tr(): CodeListPage(),
      Text('homePage5').tr(): TroubleshootPage(),
    };

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            // 리스트에 그려칠 총 child Widget 개수
            itemCount: _pages.length,
            // 리스트에 그려질 child Widget을 반복해서 그림
            itemBuilder: (context, index) {
              return ListTile(
                // ListTile 클릭 시
                onTap: () {
                  // 페이지 Widget 값이 null이 아니면
                  if (_pages[_pages.keys.elementAt(index)] != null) {
                    // 페이지 Widget으로 이동
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => _pages[_pages.keys.elementAt(index)]!));
                  }
                },
                title: _pages.keys.elementAt(index), // 타이틀
                trailing: Icon(Icons.arrow_right), // 꼬리 부분
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _drawerWidget() {
    // Drawer에 사용할 List<아이콘, 타이틀, 페이지 Widget> 초기화
    _drawerItems = [
      {
        'leading': const Icon(Icons.settings, color: Colors.black),
        'title': Text(
          'settings2'.tr(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        'route': SettingsPage(),
      },
    ];

    return Drawer(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // child Widget 사이 여유 공간을 고르게 배치
        children: [
          // Drawer의 맨 위 영역
          DrawerHeader(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.1,
              child: MainLogo(),
            ),
          ),
          // 나머지 영역
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _drawerItems.length,
              itemBuilder: (context, index) {
                Map _item = _drawerItems[index];
                return ListTile(
                  onTap: () async =>
                      await _drawerNavigate(context, _item['route']),
                  minLeadingWidth: 0.0,
                  leading: _item['leading'],
                  title: _item['title'],
                );
              },
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     _authenticationProvider.signOut();
          //     Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => SignInPage(),
          //       ),
          //       (_) => false,
          //     );
          //   },
          //   leading: Icon(Icons.logout_sharp, color: Colors.black),
          //   title: Text(
          //     'Sign out',
          //     style: TextStyle(
          //       fontSize: 16.0,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
