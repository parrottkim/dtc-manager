import 'package:dtc_manager/constants.dart';
import 'package:dtc_manager/pages/acronym_pages/acronym_page.dart';
import 'package:dtc_manager/pages/airbag_pages/airbag_page.dart';
import 'package:dtc_manager/pages/code_list_pages/code_list_page.dart';
import 'package:dtc_manager/pages/decoder_pages/decoder_page.dart';
import 'package:dtc_manager/pages/login_pages/sign_in_page.dart';
import 'package:dtc_manager/pages/settings_pages/settings_page.dart';
import 'package:dtc_manager/pages/troubleshoot_pages/troubleshoot_page.dart';
import 'package:dtc_manager/provider/authentication_provider.dart';
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
  late AuthenticationProvider _authenticationProvider;
  late SettingsProvider _settingsProvider;

  late Map<Widget, Widget?> _pages;
  late List<dynamic> _drawerItems;

  _checkSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('dtcLocale') != null) {
      var locale = EnumToString.fromString(
          DTCLocalization.values, prefs.getString('dtcLocale')!)!;
      setState(() {
        _settingsProvider.changeDTCLocalization(locale);
      });
    }
  }

  _drawerNavigate(BuildContext context, Widget page) async {
    Navigator.of(context).pop();
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _checkSettings();
  }

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
      titleSpacing: 0.0,
      title: MainLogo(),
    );
  }

  Widget _bodyWidget() {
    _pages = {
      Text('homePage1').tr(): AcronymPage(),
      Text('homePage2').tr(): AirbagPage(),
      Text('homePage3').tr(): DecoderPage(),
      Text('homePage4').tr(): CodeListPage(),
      Text('homePage5').tr(): TroubleshootPage(),
    };
    _drawerItems = [
      // {
      //   'leading': const Icon(Icons.table_rows, color: Colors.black),
      //   'title': Text(
      //     'settings1'.tr(),
      //     style: TextStyle(
      //       fontSize: 16.0,
      //       fontWeight: FontWeight.w400,
      //     ),
      //   ),
      //   'route': DatabasePage(),
      // },
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

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  if (_pages[_pages.keys.elementAt(index)] != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => _pages[_pages.keys.elementAt(index)]!));
                  }
                },
                title: _pages.keys.elementAt(index),
                trailing: Icon(Icons.arrow_right),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _drawerWidget() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DrawerHeader(
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.1,
              child: MainLogo(),
            ),
          ),
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
          ListTile(
            onTap: () {
              _authenticationProvider.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => SignInPage(),
                ),
                (_) => false,
              );
            },
            leading: Icon(Icons.logout_sharp, color: Colors.black),
            title: Text(
              'Sign out',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
