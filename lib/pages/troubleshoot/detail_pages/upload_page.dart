import 'dart:io';

import 'package:dtc_manager/model/log.dart';
import 'package:dtc_manager/pages/troubleshoot/detail_page.dart';
import 'package:dtc_manager/provider/bottom_navigation_provider.dart';
import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  final ResultRow result;
  UploadPage({Key? key, required this.result}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late BottomNavigationProvider _bottomNavigationProvider;
  late MariaDBProvider _mariaDBProvider;

  ResultRow? _selectedModel;

  bool _isVehicleSelected = false;

  bool _isBodyNumberEditing = false;
  bool _isWriterEditing = false;
  bool _isDescriptionEditing = false;

  late TextEditingController _vehicleIdController;

  late TextEditingController _vehicleNoController;
  late FocusNode _vehicleNoFocusNode;

  late TextEditingController _writerController;
  late FocusNode _writerFocusNode;

  late TextEditingController _descriptionController;
  late FocusNode _descriptionFocusNode;

  File? _image;
  String? _imageName;
  final _picker = ImagePicker();

  Future<bool> _onWillPop() async {
    if (_selectedModel != null ||
        _validateBodyNumber(_vehicleNoController.text) == null ||
        _validateTextField(_writerController.text) == null ||
        _validateTextField(_descriptionController.text) == null ||
        _image != null) {
      return await showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('uploadPage10'.tr()),
                content: Text('uploadPage11'.tr()),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('ok'.tr()),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('cancel'.tr()),
                  ),
                ],
              );
            },
          ) ??
          false;
    } else
      return true;
  }

  String? _validateBodyNumber(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'Number can\'t be emtpy';
    } else if (!value.contains(RegExp(r'^[0-9]{6}$')) && value.length == 6) {
      return 'This field must be written only as a number';
    } else if (!value.contains(RegExp(r'^[0-9]{6}$')) &&
        (value.length < 6 || value.length > 6)) {
      return 'Length of number should be 6';
    }
    return null;
  }

  String? _validateTextField(String value) {
    value = value.trim();

    if (value.isEmpty) {
      return 'This field can\'t be empty';
    }
    return null;
  }

  Future _getImage() async {
    File image;
    XFile? picker = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 640.0, maxWidth: 640.0);

    if (picker != null) {
      image = File(picker.path);
      setState(() {
        _image = image;
        _imageName = _image!.path.split('image_picker').last;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _image = null;

    _vehicleIdController = TextEditingController();

    _vehicleNoController = TextEditingController();
    _vehicleNoFocusNode = FocusNode();

    _writerController = TextEditingController();
    _writerFocusNode = FocusNode();

    _descriptionController = TextEditingController();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bottomNavigationProvider =
        Provider.of<BottomNavigationProvider>(context, listen: false);
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: _appBar(),
          body: _bodyWidget(),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      titleSpacing: 0.0,
      title:
          MainLogo(subtitle: '${'uploadPage'.tr()} - ${widget.result['code']}'),
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('uploadPage1'.tr(),
                style: TextStyle(fontWeight: FontWeight.w500)),
            DropdownButton<ResultRow>(
              hint: Text('uploadPage1'.tr()),
              value: _selectedModel,
              onChanged: (ResultRow? value) {
                setState(() {
                  if (value != null) {
                    _selectedModel = value;
                    _isVehicleSelected = true;
                    _vehicleIdController.clear();
                    _vehicleNoController.clear();
                    _isBodyNumberEditing = false;
                    _vehicleIdController.text += value['code'].toString();
                  }
                });
                WidgetsBinding.instance!.addPostFrameCallback((_) =>
                    FocusScope.of(context).requestFocus(_vehicleNoFocusNode));
              },
              items: _mariaDBProvider.model!
                  .map((value) => DropdownMenuItem<ResultRow>(
                        value: value,
                        child: Text(value['model'].toString()),
                      ))
                  .toList(),
            ),
            SizedBox(height: 10.0),
            Text('uploadPage2'.tr(),
                style: TextStyle(fontWeight: FontWeight.w500)),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    readOnly: true,
                    controller: _vehicleIdController,
                    enabled: _isVehicleSelected,
                    decoration: InputDecoration(
                      labelText: 'uploadPage3'.tr(),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: _vehicleNoController,
                    focusNode: _vehicleNoFocusNode,
                    enabled: _isVehicleSelected,
                    decoration: InputDecoration(
                      labelText: 'uploadPage4'.tr(),
                      errorText: _isBodyNumberEditing
                          ? _validateBodyNumber(_vehicleNoController.text)
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() => _isBodyNumberEditing = true);
                    },
                    onSubmitted: (value) {
                      _vehicleNoFocusNode.unfocus();
                      WidgetsBinding.instance!.addPostFrameCallback((_) =>
                          FocusScope.of(context)
                              .requestFocus(_writerFocusNode));
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Divider(height: 1.0),
            SizedBox(height: 20.0),
            Text('uploadPage5'.tr(),
                style: TextStyle(fontWeight: FontWeight.w500)),
            TextField(
              controller: _writerController,
              focusNode: _writerFocusNode,
              decoration: InputDecoration(
                labelText: 'uploadPage6'.tr(),
                errorText: _isWriterEditing
                    ? _validateTextField(_writerController.text)
                    : null,
              ),
              onChanged: (value) {
                setState(() => _isWriterEditing = true);
              },
              onSubmitted: (value) {
                _writerFocusNode.unfocus();
                WidgetsBinding.instance!.addPostFrameCallback((_) =>
                    FocusScope.of(context).requestFocus(_descriptionFocusNode));
              },
            ),
            TextField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'uploadPage7'.tr(),
                errorText: _isDescriptionEditing
                    ? _validateTextField(_descriptionController.text)
                    : null,
              ),
              onChanged: (value) {
                setState(() => _isDescriptionEditing = true);
              },
              onSubmitted: (value) {},
            ),
            SizedBox(height: 20.0),
            Divider(height: 1.0),
            SizedBox(height: 20.0),
            Text('uploadPage8'.tr(),
                style: TextStyle(fontWeight: FontWeight.w500)),
            Container(
              width: double.infinity,
              height: 300.0,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: _image == null
                  ? MaterialButton(
                      onPressed: () async {
                        await _getImage();
                      },
                      color: Colors.grey,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 70.0,
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        await _getImage();
                      },
                      child: Image.file(
                        _image!,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
            ),
            MaterialButton(
              onPressed: _validateBodyNumber(_vehicleNoController.text) ==
                          null &&
                      _validateTextField(_writerController.text) == null &&
                      _validateTextField(_descriptionController.text) == null &&
                      _image != null
                  ? () async {
                      await _mariaDBProvider.uploadLog(
                        Log(
                          date: DateTime.now().toUtc(),
                          model: _selectedModel!['model'].toString(),
                          bodyNo:
                              '${_vehicleIdController.text} ${_vehicleNoController.text}',
                          code: widget.result['code'].toString(),
                          description: _descriptionController.text,
                          photo: _image!,
                          photoName: _imageName!,
                          writer: _writerController.text,
                        ),
                      );
                      _bottomNavigationProvider.updatePage(2);
                      Navigator.of(context).pop();
                    }
                  : null,
              minWidth: double.infinity,
              color: Theme.of(context).primaryColor,
              disabledColor: Colors.grey[300],
              child: Text('uploadPage9'.tr()),
            )
          ],
        ),
      ),
    );
  }
}
