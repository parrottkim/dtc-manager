import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
      title: MainLogo(subtitle: '${'settings1'.tr()} > ${'settings1-1'.tr()}'),
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
                    minLeadingWidth: 60.0,
                    leading: Container(
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

                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('settings1-1-1',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                                .tr(),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _modelController,
                                  decoration: InputDecoration(
                                    label: Text('settings1-1-2').tr(),
                                  ),
                                ),
                                TextField(
                                  controller: _codeController,
                                  decoration: InputDecoration(
                                    label: Text('settings1-1-3').tr(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
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
      onPressed: () {},
      child: Icon(Icons.add),
    );
  }
}
