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

  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  List<Acronym> _acronyms = [];

  bool _isLoading = false;
  bool _isSearching = false;

  _loadData() async {
    setState(() {
      _isLoading = true;
    });
    await _mariaDBProvider
        .getAllAcronyms(_isSearching, _textEditingController.text)
        .then((_) {
      _mariaDBProvider.acronym!
          .toList()
          .map((e) => e)
          .toList()
          .forEach((element) {
        _acronyms.add(Acronym.fromJson(element));
      });
      _handleList(_acronyms);
    }).catchError((e) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message))));
    setState(() {
      _isLoading = false;
    });
  }

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
    if (_settingsProvider.dtcLocale == DTCLocalization.both) {
      description = '${model.descriptionEn}\n${model.descriptionKr}';
    } else if (_settingsProvider.dtcLocale == DTCLocalization.enUS) {
      description = '${model.descriptionEn}';
    } else {
      description = '${model.descriptionKr}';
    }
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
      titleSpacing: 0.0,
      title: MainLogo(subtitle: 'homePage1'.tr()),
    );
  }

  Widget _bodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _searchWidget(),
        SizedBox(height: 6.0),
        _acronymList(),
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
          isDense: true,
          contentPadding: EdgeInsets.zero,
          label: Text('homePage1-1').tr(),
          suffixIcon: IconButton(
            splashRadius: 24.0,
            icon: Icon(Icons.search),
            onPressed: () {
              if (_textEditingController.text.isNotEmpty) {
                setState(() {
                  _isSearching = true;
                  _acronyms.clear();
                  _loadData();
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
              _acronyms.clear();
              _loadData();
            });
          }
        },
      ),
    );
  }

  Widget _acronymList() {
    if (!_isLoading && _mariaDBProvider.acronym == null) {
      return Expanded(child: Center(child: Text('No elements')));
    }
    if (_acronyms.isEmpty) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    } else {
      return Expanded(
        child: AzListView(
          data: _acronyms,
          itemCount: _acronyms.length,
          itemBuilder: (context, index) {
            return _listItem(_acronyms[index]);
          },
          susItemBuilder: (context, index) {
            Acronym acronym = _acronyms[index];
            return getSusItem(context, acronym.getSuspensionTag());
          },
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
