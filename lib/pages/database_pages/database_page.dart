import 'package:dtc_manager/pages/database_pages/dtc_code_page.dart';
import 'package:dtc_manager/pages/database_pages/vehicle_model_page.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DatabasePage extends StatefulWidget {
  DatabasePage({Key? key}) : super(key: key);

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  late List<dynamic> _settingsItems;

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
    _settingsItems = [
      {
        'leading': const Icon(Icons.text_format, color: Colors.black),
        'title': Text('settings1-1').tr(),
        'route': null,
      },
      {
        'leading':
            const Icon(Icons.content_paste_outlined, color: Colors.black),
        'title': Text('settings1-2').tr(),
        'route': DTCCodePage(),
      },
      {
        'leading': const Icon(Icons.time_to_leave, color: Colors.black),
        'title': Text('settings1-3').tr(),
        'route': VehicleModelPage(),
      },
    ];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _settingsItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => _settingsItems[index]['route']));
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
