import 'package:dtc_manager/constants.dart';
import 'package:dtc_manager/pages/dtc_list/dtc_list_page.dart';
import 'package:dtc_manager/pages/settings/settings_page.dart';
import 'package:dtc_manager/pages/troubleshoot/troubleshoot_page.dart';
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
  late SettingsProvider _settingsProvider;

  late Map<String, Widget?> _pages;
  late List<dynamic> _drawerItems;

  _checkSettings() async {
    final prefs = await SharedPreferences.getInstance();
    var locale = EnumToString.fromString(
        DTCLocalization.values, prefs.getString('dtcLocale')!)!;
    setState(() {
      _settingsProvider.changeDTCLocalization(locale);
    });
  }

  _drawerNavigate(BuildContext context, Widget page) async {
    Navigator.of(context).pop();
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _checkSettings();
  }

  @override
  void initState() {
    super.initState();
    _pages = {
      'homePage1'.tr(): null,
      'homePage2'.tr(): null,
      'homePage3'.tr(): DTCListPage(),
      'homePage4'.tr(): TroubleshootPage(),
    };
    _drawerItems = [
      {
        'leading': const Icon(Icons.settings, color: Colors.black),
        'title': Text(
          'settings'.tr(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        'route': SettingsPage(),
      },
      {
        'leading': const Icon(Icons.format_list_bulleted, color: Colors.black),
        'title': Text(
          'settings'.tr(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        'route': SettingsPage(),
      },
    ];
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

  Widget _bodyWidget() {
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
                title: Text(_pages.keys.elementAt(index)),
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
            onTap: () {},
            leading: Icon(Icons.logout, color: Colors.black),
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

  AppBar _appBar() {
    return AppBar(
      titleSpacing: 0.0,
      title: MainLogo(),
    );
  }
}
