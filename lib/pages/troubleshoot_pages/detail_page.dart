import 'package:dtc_manager/pages/troubleshoot_pages/description_page.dart';
import 'package:dtc_manager/pages/troubleshoot_pages/inspection_page.dart';
import 'package:dtc_manager/pages/troubleshoot_pages/log_list_page.dart';
import 'package:dtc_manager/pages/troubleshoot_pages/upload_page.dart';
import 'package:dtc_manager/provider/bottom_navigation_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final int? index;
  final ResultRow result;
  DetailPage({Key? key, this.index, required this.result}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late BottomNavigationProvider _bottomNavigationProvider;
  late PageController _pageController;
  late int _currentIndex;

  void onTabNav(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.ease);
    _bottomNavigationProvider.updatePage(index);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: true);
    _bottomNavigationProvider.updatePage(_currentIndex);
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _bottomNavigationProvider.updatePage(0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _bottomNavigationProvider.updatePage(index));
          },
          children: [
            DescriptionPage(result: widget.result),
            InspectionPage(result: widget.result),
            LogListPage(result: widget.result),
            UploadPage(result: widget.result),
          ],
        ),
        floatingActionButton: _floatingActionButton(),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      title: MainLogo(
          subtitle: '${widget.result['dtc_code']} ${'troubleshootPage'.tr()}'),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => UploadPage(result: widget.result),
          ),
        );
        setState(() {});
      },
      child: Icon(Icons.upload),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.description), label: 'troubleshootPage1'.tr()),
        BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), label: 'troubleshootPage2'.tr()),
        BottomNavigationBarItem(
            icon: Icon(Icons.list), label: 'troubleshootPage3'.tr()),
      ],
      currentIndex: _bottomNavigationProvider.currentIndex,
      onTap: (index) => onTabNav(index),
    );
  }
}
