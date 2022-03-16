import 'package:dtc_manager/constants.dart';
import 'package:dtc_manager/provider/settings_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enum_to_string/enum_to_string.dart';

class LanguageSettingsPage extends StatefulWidget {
  LanguageSettingsPage({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  late SettingsProvider _settingsProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
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
      title: MainLogo(subtitle: '${'settings'.tr()} > ${'settings1'.tr()}'),
    );
  }

  Widget _bodyWidget() {
    final List<dynamic> _settingsItems = [
      {
        'title': Text(
          'language1'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        'items': [
          {
            'title': 'language1-1'.tr(),
            'locale': Locale('en', 'US'),
          },
          {
            'title': 'language1-2'.tr(),
            'locale': Locale('ko', 'KR'),
          },
        ],
      },
      {
        'title': Text(
          'language2'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        'items': [
          {
            'title': 'language2-1'.tr(),
            'locale': DTCLocalization.enUS,
          },
          {
            'title': 'language2-2'.tr(),
            'locale': DTCLocalization.koKR,
          },
          {
            'title': 'language2-3'.tr(),
            'locale': DTCLocalization.both,
          },
        ],
      }
    ];

    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              ExpansionTile(
                title: _settingsItems[0]['title'],
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _settingsItems[0]['items'].length,
                    itemBuilder: (context, index) {
                      var item = _settingsItems[0]['items'].elementAt(index);
                      return ListTile(
                        onTap: () async {
                          setState(() {
                            EasyLocalization.of(context)!
                                .setLocale(item['locale']);
                          });
                        },
                        minLeadingWidth: 0.0,
                        leading: context.locale == item['locale']
                            ? Icon(
                                Icons.check,
                                color: Colors.redAccent,
                              )
                            : null,
                        title: Text(
                          item['title'],
                          style: TextStyle(
                            color: context.locale == item['locale']
                                ? Colors.redAccent
                                : Colors.black.withOpacity(0.7),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: _settingsItems[1]['title'],
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _settingsItems[1]['items'].length,
                    itemBuilder: (context, index) {
                      var item = _settingsItems[1]['items'].elementAt(index);
                      return ListTile(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          setState(() {
                            _settingsProvider
                                .changeDTCLocalization(item['locale']);
                            prefs.setString(
                                'dtcLocale',
                                EnumToString.convertToString(
                                  item['locale'],
                                ));
                          });
                        },
                        minLeadingWidth: 0.0,
                        leading: _settingsProvider.dtcLocale == item['locale']
                            ? Icon(
                                Icons.check,
                                color: Colors.redAccent,
                              )
                            : null,
                        title: Text(
                          item['title'],
                          style: TextStyle(
                            color: _settingsProvider.dtcLocale == item['locale']
                                ? Colors.redAccent
                                : Colors.black.withOpacity(0.7),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
