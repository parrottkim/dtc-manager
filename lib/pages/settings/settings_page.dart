import 'package:dtc_manager/pages/settings/language_settings_page.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<dynamic> _settingsItems;

  @override
  void initState() {
    super.initState();
    _settingsItems = [
      {
        'leading': const Icon(Icons.format_list_bulleted, color: Colors.black),
        'title': Text('settings1'.tr(), style: TextStyle(fontSize: 18.0)),
        'route': LanguageSettingsPage(),
      },
      {
        'leading': const Icon(Icons.language, color: Colors.black),
        'title': Text('settings2'.tr(), style: TextStyle(fontSize: 18.0)),
        'route': LanguageSettingsPage(),
      },
    ];
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
      title: MainLogo(subtitle: 'settings1'.tr()),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _settingsItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => LanguageSettingsPage()));
                  setState(() {});
                },
                minLeadingWidth: 0.0,
                leading: _settingsItems[index]['leading'],
                title: _settingsItems[index]['title'],
              );
            },
          ),
        ),
      ],
    );
  }
}
