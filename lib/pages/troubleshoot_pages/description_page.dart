import 'package:dtc_manager/constants.dart';
import 'package:dtc_manager/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

class DescriptionPage extends StatefulWidget {
  final ResultRow result;
  DescriptionPage({Key? key, required this.result}) : super(key: key);

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  late SettingsProvider _settingsProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    late String description;
    if (_settingsProvider.dtcLocale == DTCLocalization.both) {
      description =
          '${widget.result['en_description']}\n${widget.result['kr_description']}';
    } else if (_settingsProvider.dtcLocale == DTCLocalization.enUS) {
      description = '${widget.result['en_description']}';
    } else {
      description = '${widget.result['kr_description']}';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Card(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.result['code']}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black,
                          ),
                        ),
                        child: Text(
                          '${widget.result['sub_system']}',
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(description),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
