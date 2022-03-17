import 'package:dtc_manager/pages/troubleshoot_pages/detail_page.dart';
import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TroubleshootPage extends StatefulWidget {
  TroubleshootPage({Key? key}) : super(key: key);

  @override
  State<TroubleshootPage> createState() => _TroubleshootPageState();
}

class _TroubleshootPageState extends State<TroubleshootPage> {
  late MariaDBProvider _mariaDBProvider;

  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
    _mariaDBProvider.clearDTCCode();
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

  Widget _bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _searchWidget(),
        _resultWidget(),
      ],
    );
  }

  Widget _searchWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Center(
        child: TextField(
          controller: _textEditingController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintText: 'homePage4-1'.tr(),
            suffix: IconButton(
              splashRadius: 24.0,
              icon: Icon(Icons.search),
              onPressed: () {
                if (_textEditingController.text.isNotEmpty) {
                  setState(() {
                    _isSearching = true;
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
              });
            }
          },
        ),
      ),
    );
  }

  Widget _resultWidget() {
    return FutureBuilder(
      future: _mariaDBProvider.getDTCCode(_textEditingController.text),
      builder: (context, snapshot) {
        if (_mariaDBProvider.code == null && _isSearching) {
          return Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Text('No element'));
        }
        if (_mariaDBProvider.code == null && !_isSearching) {
          return SizedBox();
        }
        if (_mariaDBProvider.code!.isNotEmpty && _isSearching) {
          return ListTile(
            onTap: () {
              _mariaDBProvider.getAllVehicleModels();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      DetailPage(result: _mariaDBProvider.code!.first),
                ),
              );
            },
            title: Text('${_mariaDBProvider.code!.first['code']}'),
            subtitle: Text(
              '${_mariaDBProvider.code!.first['en_description']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(Icons.arrow_right),
          );
        }
        if (_mariaDBProvider.code!.isEmpty && _isSearching) {
          return Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Center(child: CircularProgressIndicator()));
        }
        return SizedBox();
      },
    );
  }
}
