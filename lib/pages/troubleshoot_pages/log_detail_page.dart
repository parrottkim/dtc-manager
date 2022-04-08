import 'dart:io';
import 'dart:typed_data';

import 'package:dtc_manager/provider/bottom_navigation_provider.dart';
import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

class LogDetailPage extends StatefulWidget {
  final dynamic result;
  LogDetailPage({Key? key, required this.result}) : super(key: key);

  @override
  State<LogDetailPage> createState() => _LogDetailPageState();
}

class _LogDetailPageState extends State<LogDetailPage> {
  late PageController _pageController;
  final Duration _animationDuration = const Duration(milliseconds: 500);
  final Cubic _curve = Curves.ease;
  late double _pageOffset;

  late MariaDBProvider _mariaDBProvider;
  late BottomNavigationProvider _bottomNavigationProvider;

  List<Map<String, Uint8List>> _list = [];

  bool _isLoading = false;

  Future<List?> _getData() async {
    setState(() {
      _isLoading = true;
    });
    await _mariaDBProvider
        .getLogImages(widget.result['log_id'] as int)
        .then((_) {
      if (_mariaDBProvider.image != null) {
        for (var element in _mariaDBProvider.image!) {
          _list.add({
            '${element['photo_name']}':
                Uint8List.fromList(element['photo']['data'].cast<int>()),
          });
        }
      }
    }).catchError((e) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message))));
    setState(() {
      _isLoading = false;
    });
    return _list;
  }

  _openPhoto(BuildContext context, final int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GalleryPhotoViewWrapper(
          items: _list,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
    _bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);

    if (mounted) _getData();
    _bottomNavigationProvider.updatePage(2);
  }

  @override
  void initState() {
    super.initState();
    _pageOffset = 0;
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(
        () => setState(() => _pageOffset = _pageController.page ?? 0));
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: _bodyWidget(context),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 50.0,
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  border: Border.all(
                    width: 0.5,
                    color: Colors.black,
                  ),
                ),
                child: Text(
                  '${widget.result['model']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.result['model_code']} ${widget.result['body_no']}',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('yyyy.MM.dd HH:mm')
                        .format(DateTime.parse(widget.result['date'])),
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Text('troubleshootPage3-1'.tr(),
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300)),
          Text('${widget.result['writer']}',
              style: TextStyle(color: Colors.black, fontSize: 16.0)),
          SizedBox(height: 10.0),
          Divider(height: 1.0),
          SizedBox(height: 10.0),
          Text('troubleshootPage3-2'.tr(),
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300)),
          Text('${widget.result['description']}',
              style: TextStyle(color: Colors.black, fontSize: 16.0)),
          SizedBox(height: 10.0),
          Divider(height: 1.0),
          SizedBox(height: 10.0),
          Text('troubleshootPage3-3'.tr(),
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300)),
          SizedBox(height: 4.0),
          SizedBox(
            height: 300.0,
            child: _imageWidget(),
          ),
        ],
      ),
    );
  }

  Widget _imageWidget() {
    if (!_isLoading && _mariaDBProvider.image == null) {
      return Center(child: Text('No elements'));
    }
    if (_list.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  _openPhoto(context, index);
                },
                child: Image.memory(_list[index].values.elementAt(0),
                    fit: BoxFit.cover));
          },
        ),
        Visibility(
          visible: _pageOffset >= 0.9,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
              onPressed: () => _pageController.previousPage(
                  duration: _animationDuration, curve: _curve),
            ),
          ),
        ),
        Visibility(
          visible: _pageOffset <= _list.length - 1.1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_right, color: Colors.white),
              onPressed: () => _pageController.nextPage(
                  duration: _animationDuration, curve: _curve),
            ),
          ),
        ),
      ],
    );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List items;
  final Axis scrollDirection;

  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.items,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  @override
  State<GalleryPhotoViewWrapper> createState() =>
      _GalleryPhotoViewWrapperState();
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  _getCacheImage(dynamic log) async {
    Uint8List image = log.values.elementAt(0);
    final dir = await getTemporaryDirectory();
    File file = await File('${dir.path}/${log.keys.elementAt(0)}').create();
    file.writeAsBytesSync(image);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            splashRadius: 22.0,
            icon: Icon(Icons.share),
            onPressed: () async {
              File file = await _getCacheImage(widget.items[currentIndex]);
              Share.shareFiles([file.path], text: 'Share image');
            },
          ),
        ],
      ),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.items.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                border: Border.all(
                  width: 0.5,
                  color: Colors.white,
                ),
              ),
              child: Text(
                '${currentIndex + 1} / ${widget.items.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final item = widget.items[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: MemoryImage(item.values.elementAt(0)),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}
