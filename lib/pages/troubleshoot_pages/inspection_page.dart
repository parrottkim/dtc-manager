import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class InspectionPage extends StatefulWidget {
  final ResultRow result;
  InspectionPage({Key? key, required this.result}) : super(key: key);

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Inspection Page'));
  }
}
