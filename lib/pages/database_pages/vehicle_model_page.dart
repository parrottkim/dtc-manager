import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

class VehicleModelPage extends StatefulWidget {
  VehicleModelPage({Key? key}) : super(key: key);

  @override
  State<VehicleModelPage> createState() => _VehicleModelPageState();
}

class _VehicleModelPageState extends State<VehicleModelPage> {
  late MariaDBProvider _mariaDBProvider;

  late TextEditingController _modelController;
  late TextEditingController _codeController;

  late FocusNode _modelFocusNode;
  late FocusNode _codeFocusNode;

  bool _isModelEditable = false;
  bool _isModelCodeEditable = false;

  String? _checkModelExists() {
    var count = _mariaDBProvider.modelCount;
    if (count != null && count[0]['count(*)'] == 1) {
      return 'settings1-3-4'.tr();
    } else {
      return null;
    }
  }

  String? _checkModelCodeExists() {
    var count = _mariaDBProvider.modelCodeCount;
    if (count != null && count[0]['count(*)'] == 1) {
      return 'settings1-3-5'.tr();
    } else {
      return null;
    }
  }

  Future<bool> _onWillPop() async {
    if (_isModelEditable || _isModelCodeEditable) {
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

  _showEditingDialog(ResultRow row) async {
    setState(() {
      _isModelEditable = false;
      _isModelCodeEditable = false;
    });
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: _onWillPop,
        child: AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('settings1-3-1',
                      style: TextStyle(fontWeight: FontWeight.bold))
                  .tr(),
              IconButton(
                onPressed: () async {
                  if (await _onWillPop()) Navigator.of(context).pop();
                },
                icon: Icon(Icons.close),
                iconSize: 16.0,
                splashRadius: 20.0,
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _modelController,
                  decoration: InputDecoration(
                    label: Text('settings1-3-2').tr(),
                    errorText: _isModelEditable ? _checkModelExists() : null,
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  onChanged: (value) async {
                    await _mariaDBProvider
                        .getVehicleModel(_modelController.text);
                    setState(() => _isModelEditable = true);
                  },
                ),
                MaterialButton(
                  onPressed: _isModelEditable && _checkModelExists() == null
                      ? () async {
                          await _mariaDBProvider
                              .editVehicleModel(row, _modelController.text)
                              .then((_) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('settings1-3-12').tr(),
                                  )))
                              .catchError((e) => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text('settings1-3-13').tr())));
                          ;
                          Navigator.of(context).pop();
                        }
                      : null,
                  minWidth: double.infinity,
                  child: Text('settings1-3-6').tr(),
                ),
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    label: Text('settings1-3-3').tr(),
                    errorText:
                        _isModelCodeEditable ? _checkModelCodeExists() : null,
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  onChanged: (value) async {
                    await _mariaDBProvider
                        .getVehicleModelCode(_codeController.text);
                    setState(() => _isModelCodeEditable = true);
                  },
                ),
                MaterialButton(
                  onPressed: _isModelCodeEditable &&
                          _checkModelCodeExists() == null
                      ? () async {
                          await _mariaDBProvider
                              .editVehicleModelCode(row, _codeController.text)
                              .then((_) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('settings1-3-12').tr(),
                                  )))
                              .catchError((e) => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text('settings1-3-13').tr())));
                          ;
                          Navigator.of(context).pop();
                        }
                      : null,
                  minWidth: double.infinity,
                  child: Text('settings1-3-6').tr(),
                ),
                SizedBox(height: 20.0),
                SizedBox(height: 4.0),
                Divider(height: 1.0),
                SizedBox(height: 4.0),
                MaterialButton(
                  onPressed: () async {
                    await _showAlertDialog(row);
                  },
                  minWidth: double.infinity,
                  child:
                      Text('settings1-3-7', style: TextStyle(color: Colors.red))
                          .tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showAddDialog() async {
    setState(() {
      _modelController.clear();
      _codeController.clear();
      _isModelEditable = false;
      _isModelCodeEditable = false;
    });
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: _onWillPop,
        child: AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('settings1-3-10',
                      style: TextStyle(fontWeight: FontWeight.bold))
                  .tr(),
              IconButton(
                onPressed: () async {
                  if (await _onWillPop()) Navigator.of(context).pop();
                },
                icon: Icon(Icons.close),
                iconSize: 16.0,
                splashRadius: 20.0,
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _modelController,
                  focusNode: _modelFocusNode,
                  decoration: InputDecoration(
                    label: Text('settings1-3-2').tr(),
                    errorText: _isModelEditable ? _checkModelExists() : null,
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  onChanged: (value) async {
                    await _mariaDBProvider
                        .getVehicleModel(_modelController.text);
                    setState(() => _isModelEditable = true);
                  },
                  onSubmitted: (value) {
                    _modelFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_codeFocusNode);
                  },
                ),
                TextField(
                  controller: _codeController,
                  focusNode: _codeFocusNode,
                  decoration: InputDecoration(
                    label: Text('settings1-3-3').tr(),
                    errorText:
                        _isModelCodeEditable ? _checkModelCodeExists() : null,
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  onChanged: (value) async {
                    await _mariaDBProvider
                        .getVehicleModelCode(_codeController.text);
                    setState(() => _isModelCodeEditable = true);
                  },
                  onSubmitted: _isModelEditable &&
                          _isModelCodeEditable &&
                          _checkModelExists() == null &&
                          _checkModelCodeExists() == null
                      ? (value) async {
                          await _mariaDBProvider
                              .addVehicleModel(
                                  [_modelController.text, _codeController.text])
                              .then((_) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('settings1-3-12').tr(),
                                  )))
                              .catchError((e) => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text('settings1-3-13').tr())));
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
                SizedBox(height: 20.0),
                MaterialButton(
                  onPressed: _isModelEditable &&
                          _isModelCodeEditable &&
                          _checkModelExists() == null &&
                          _checkModelCodeExists() == null
                      ? () async {
                          await _mariaDBProvider
                              .addVehicleModel(
                                  [_modelController.text, _codeController.text])
                              .then((_) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('settings1-3-12').tr(),
                                  )))
                              .catchError((e) => ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      content: Text('settings1-3-13').tr())));
                          Navigator.of(context).pop();
                        }
                      : null,
                  minWidth: double.infinity,
                  color: Theme.of(context).colorScheme.secondary,
                  disabledColor: Colors.grey[300],
                  child: Text('settings1-3-11',
                          style: TextStyle(color: Colors.white))
                      .tr(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showAlertDialog(ResultRow row) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            Text('settings1-3-8', style: TextStyle(fontWeight: FontWeight.bold))
                .tr(),
        content: Text('settings1-3-9').tr(),
        actions: [
          MaterialButton(
            onPressed: () async {
              await _mariaDBProvider
                  .deleteVehicleModel(row)
                  .then((_) =>
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('settings1-3-12').tr(),
                      )))
                  .catchError((e) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('settings1-3-13').tr())));
              ;
              _mariaDBProvider.getAllVehicleModels();
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
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController();
    _codeController = TextEditingController();

    _modelFocusNode = FocusNode();
    _codeFocusNode = FocusNode();
  }

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
      title: MainLogo(subtitle: '${'settings1'.tr()} > ${'settings1-3'.tr()}'),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: _mariaDBProvider.getAllVehicleModels(),
            builder: (context, snapshot) {
              if (_mariaDBProvider.model == null) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: _mariaDBProvider.model!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      width: 60.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 6.0),
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
                        '${_mariaDBProvider.model![index]['model']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    title: Text(
                      '${_mariaDBProvider.model![index]['model_code']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        _modelController.text =
                            '${_mariaDBProvider.model![index]['model']}';
                        _codeController.text =
                            '${_mariaDBProvider.model![index]['model_code']}';

                        await _showEditingDialog(
                            _mariaDBProvider.model![index]);
                        setState(() {});
                      },
                      icon: Icon(Icons.edit),
                      splashRadius: 24.0,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await _showAddDialog();
        setState(() {});
      },
      child: Icon(Icons.add),
    );
  }
}
