import 'package:dtc_manager/pages/decoder_pages/description_page.dart';
import 'package:dtc_manager/pages/decoder_pages/scanner_page.dart';
import 'package:dtc_manager/provider/bottom_navigation_provider.dart';
import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_material_icon/community_material_icon.dart';

class DecoderPage extends StatefulWidget {
  final int? index;
  DecoderPage({Key? key, this.index}) : super(key: key);

  @override
  State<DecoderPage> createState() => _DecoderPageState();
}

class _DecoderPageState extends State<DecoderPage> {
  late BottomNavigationProvider _bottomNavigationProvider;

  // 페이지 컨트롤을 위한 controller
  late PageController _pageController;
  // 현재 페이지 index
  late int _currentIndex;

  // BottomNavigationBar 클릭시 애니메이션
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: _bodyWidget(),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      title: MainLogo(subtitle: 'homePage3'.tr()),
    );
  }

  Widget _bodyWidget() {
    return PageView(
      controller: _pageController,
      // 페이지가 변하면 Proivder에 값 변경 알림
      onPageChanged: (index) {
        setState(() => _bottomNavigationProvider.updatePage(index));
      },
      children: [
        DescriptionPage(),
        ScannerPage(),
      ],
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.description_sharp), label: 'decoderPage1'.tr()),
        BottomNavigationBarItem(
            icon: Icon(CommunityMaterialIcons.barcode_scan),
            label: 'decoderPage2'.tr()),
      ],
      currentIndex: _bottomNavigationProvider.currentIndex,
      onTap: (index) => onTabNav(index),
    );
  }
}
