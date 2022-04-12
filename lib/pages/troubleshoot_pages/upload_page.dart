import 'dart:io';

import 'package:dtc_manager/model/log.dart';
import 'package:dtc_manager/pages/troubleshoot_pages/detail_page.dart';
import 'package:dtc_manager/provider/bottom_navigation_provider.dart';
import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  final Map<String, dynamic> result;
  UploadPage({Key? key, required this.result}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late BottomNavigationProvider _bottomNavigationProvider;
  late MariaDBProvider _mariaDBProvider;

  dynamic _selectedModel;

  bool _isVehicleSelected = false;

  bool _isBodyNumberEditing = false;
  bool _isWriterEditing = false;
  bool _isDescriptionEditing = false;

  bool _isUploading = false;

  late TextEditingController _vehicleIdController;

  late TextEditingController _vehicleNoController;
  late FocusNode _vehicleNoFocusNode;

  late TextEditingController _writerController;
  late FocusNode _writerFocusNode;

  late TextEditingController _descriptionController;
  late FocusNode _descriptionFocusNode;

  List<XFile> _images = [];

  Future<bool> _onWillPop() async {
    if (_selectedModel != null ||
        _validateBodyNumber(_vehicleNoController.text) == null ||
        _validateTextField(_writerController.text) == null ||
        _validateTextField(_descriptionController.text) == null ||
        _images.isNotEmpty) {
      return await showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('uploadPage10').tr(),
                content: Text('uploadPage11').tr(),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('ok').tr(),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('cancel').tr(),
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
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        actions: [
          MaterialButton(
            onPressed: () async {
              Navigator.of(context).pop();

              XFile? picker = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  maxHeight: 640.0,
                  maxWidth: 640.0);

              if (picker != null) {
                setState(() {
                  _images.add(picker);
                });
              }
            },
            minWidth: double.infinity,
            child: Text('uploadPage12').tr(),
          ),
          MaterialButton(
            onPressed: () async {
              Navigator.of(context).pop();

              List<XFile>? picker = await ImagePicker()
                  .pickMultiImage(maxHeight: 640.0, maxWidth: 640.0);

              if (_images.length + picker!.length > 6) {
                await _imageDialog();
                return;
              }

              if (picker != null) {
                setState(() {
                  _images = _images..addAll(picker);
                });
              }
            },
            minWidth: double.infinity,
            child: Text('uploadPage13').tr(),
          ),
        ],
      ),
    );
  }

  _imageDialog() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('uploadPage14').tr(),
        content: Text('uploadPage15').tr(),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('ok').tr(),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
          bottomSheet: _bottomButton(),
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
    return AbsorbPointer(
      absorbing: _isUploading,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('uploadPage1'.tr(),
                  style: TextStyle(fontWeight: FontWeight.w500)),
              _mariaDBProvider.model != null
                  ? DropdownButton(
                      hint: Text('uploadPage1'.tr()),
                      value: _selectedModel,
                      onChanged: (dynamic value) {
                        setState(() {
                          if (value != null) {
                            _selectedModel = value;
                            _isVehicleSelected = true;
                            _vehicleIdController.clear();
                            _vehicleNoController.clear();
                            _isBodyNumberEditing = false;
                            _vehicleIdController.text +=
                                value['model_code'].toString();
                          }
                        });
                        WidgetsBinding.instance!.addPostFrameCallback((_) =>
                            FocusScope.of(context)
                                .requestFocus(_vehicleNoFocusNode));
                      },
                      items: _mariaDBProvider.model!
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value['model'].toString()),
                              ))
                          .toList(),
                    )
                  : Container(
                      margin: EdgeInsets.all(4.0),
                      width: 30.0,
                      height: 30.0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
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
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode));
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
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: _images.isEmpty
                    ? MaterialButton(
                        onPressed: () async {
                          await _getImage();
                        },
                        minWidth: double.infinity,
                        height: 300.0,
                        color: Theme.of(context).colorScheme.secondary,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 70.0,
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _images.length < 6
                            ? _images.length + 1
                            : _images.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 3.0,
                          crossAxisSpacing: 3.0,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (context, index) {
                          if (index == 0 && _images.length < 6) {
                            return MaterialButton(
                              onPressed: () async {
                                await _getImage();
                              },
                              minWidth: double.infinity,
                              height: 300.0,
                              color: Theme.of(context).colorScheme.secondary,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            );
                          }
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                  File(_images[_images.length < 6
                                          ? index - 1
                                          : index]
                                      .path),
                                  fit: BoxFit.cover),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(4.0),
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.white.withOpacity(0.7)),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _images.removeAt(index - 1);
                                      });
                                    },
                                    shape: CircleBorder(),
                                    child: Icon(
                                      Icons.close,
                                      size: 12.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomButton() {
    return Visibility(
      visible: _validateBodyNumber(_vehicleNoController.text) == null &&
          _validateTextField(_writerController.text) == null &&
          _validateTextField(_descriptionController.text) == null &&
          _images.isNotEmpty,
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        child: InkWell(
          onTap: !_isUploading
              ? () async {
                  setState(() {
                    _isUploading = true;
                  });
                  Log log = Log(
                    date: DateFormat("yyyy-MM-dd HH:mm:ss.ms")
                        .format(DateTime.now().toUtc()),
                    codeId: widget.result['code_id'],
                    modelId: _selectedModel!['model_id'],
                    bodyNumber: _vehicleNoController.text,
                    writer: _writerController.text,
                    description: _descriptionController.text,
                  );
                  await _mariaDBProvider
                      .uploadLog(log, _images)
                      .then((_) =>
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('settings1-3-12').tr(),
                          )))
                      .catchError((e) => ScaffoldMessenger.of(context)
                          .showSnackBar(
                              SnackBar(content: Text('settings1-3-13').tr())));

                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailPage(result: widget.result, index: 2),
                    ),
                  );
                }
              : null,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 50.0,
            child: !_isUploading
                ? Text(
                    'uploadPage9'.tr(),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
