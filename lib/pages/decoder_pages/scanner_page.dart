import 'package:dtc_manager/pages/decoder_pages/result_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:community_material_icon/community_material_icon.dart';

class ScannerPage extends StatefulWidget {
  ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  bool _isEditing = false;

  _validateNumber(String value) {
    if (value.isEmpty) {
      return 'decoderPage2-2'.tr();
    } else if (!RegExp('^5X+[A-Z0-9]{15}').hasMatch(value)) {
      return 'decoderPage2-3'.tr();
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchWidget(),
        _scannerButton(),
      ],
    );
  }

  Widget _searchWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: TextField(
        controller: _textEditingController,
        focusNode: _focusNode,
        inputFormatters: [
          UpperCaseTextFormatter(),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          label: Text('decoderPage2-1').tr(),
          suffixIcon: IconButton(
            splashRadius: 24.0,
            icon: Icon(Icons.search),
            onPressed: _validateNumber(_textEditingController.text) == null &&
                    _textEditingController.text.isNotEmpty
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ResultPage(result: _textEditingController.text),
                      ),
                    );
                  }
                : null,
          ),
          errorText:
              _isEditing ? _validateNumber(_textEditingController.text) : null,
        ),
        onChanged: (value) {
          setState(() {
            _isEditing = true;
          });
        },
        onSubmitted: _validateNumber(_textEditingController.text) == null &&
                _textEditingController.text.isNotEmpty
            ? (value) {
                _focusNode.unfocus();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ResultPage(result: _textEditingController.text),
                  ),
                );
              }
            : null,
      ),
    );
  }

  Widget _scannerButton() {
    return Expanded(
      child: Center(
        child: MaterialButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CameraControlPage(),
              ),
            );
          },
          child: Icon(CommunityMaterialIcons.barcode_scan, size: 120.0),
        ),
      ),
    );
  }
}

class CameraControlPage extends StatefulWidget {
  CameraControlPage({Key? key}) : super(key: key);

  @override
  State<CameraControlPage> createState() => _CameraControlPageState();
}

class _CameraControlPageState extends State<CameraControlPage> {
  late MobileScannerController _controller;

  String? _barcode;

  bool _isMatched = false;

  _validateBarcode(String? value) async {
    if (value != null &&
        RegExp('^5X+[A-Z0-9]{15}').hasMatch(value) &&
        !_isMatched) {
      // await _controller.stop();
      setState(() => _isMatched = true);
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('decoderPage3').tr(),
          content: Text(value),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ResultPage(result: value),
                  ),
                );
              },
              child: Text('ok').tr(),
            ),
            MaterialButton(
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() => _isMatched = false);
                // await _controller.start();
              },
              child: Text('cancel').tr(),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(torchEnabled: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.4),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: _controller.torchState,
                builder: (context, state, child) {
                  switch (state as TorchState) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              onPressed: () => _controller.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: _controller.cameraFacingState,
                builder: (context, state, child) {
                  switch (state as CameraFacing) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              onPressed: () => _controller.switchCamera(),
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.image),
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                // Pick an image
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  if (await _controller.analyzeImage(image.path)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Barcode found!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    var value = await _controller.barcodes.single;
                    await _validateBarcode(value.rawValue);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No barcode found!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            return Stack(
              alignment: Alignment.center,
              children: [
                MobileScanner(
                  allowDuplicates: true,
                  controller: _controller,
                  onDetect: (barcode, args) async {
                    if (_barcode != barcode.rawValue) {
                      _barcode = barcode.rawValue;
                      await _validateBarcode(_barcode);
                    }
                  },
                ),
                Container(
                  child: Center(
                    child: CustomPaint(
                      painter: RoundedBorderPainter(),
                      child: SizedBox(
                        width: 250.0,
                        height: 150.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 260.0, left: 20.0, right: 20.0),
                  child: MaterialButton(
                    onPressed: () {
                      _controller.stop();
                      _controller.start();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        border: Border.all(
                          width: 0.5,
                          color: Colors.white,
                        ),
                      ),
                      child: Text(
                        'decoderPage4',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          decoration: null,
                        ),
                      ).tr(),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class RoundedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = 3.0;
    final radius = 10.0;
    final tRadius = 2 * radius;
    final rect = Rect.fromLTWH(
      width,
      width,
      size.width - 2 * width,
      size.height - 2 * width,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final clippingRect0 = Rect.fromLTWH(
      0,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = width,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
