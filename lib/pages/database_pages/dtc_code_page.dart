import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DTCCodePage extends StatefulWidget {
  DTCCodePage({Key? key}) : super(key: key);

  @override
  State<DTCCodePage> createState() => _DTCCodePageState();
}

class _DTCCodePageState extends State<DTCCodePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: _bodyWidget(),
        floatingActionButton: _floatingActionButton(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      titleSpacing: 0.0,
      title: MainLogo(subtitle: '${'settings1'.tr()} > ${'settings1-2'.tr()}'),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [],
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.add),
    );
  }
}
