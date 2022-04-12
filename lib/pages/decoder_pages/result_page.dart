import 'package:dtc_manager/provider/maria_db_provider.dart';
import 'package:dtc_manager/widgets/main_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatefulWidget {
  final String result;
  ResultPage({Key? key, required this.result}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late MariaDBProvider _mariaDBProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mariaDBProvider = Provider.of<MariaDBProvider>(context, listen: false);
  }

  List<String> _decoded = List.filled(12, '');

  // _decode() {
  //   List<String> _words = widget.result.trim().split("");

  //   switch (_words[0]) {
  //     case '5':
  //       _decoded[0] = 'USA';
  //       break;
  //     default:
  //       _decoded[0] = 'NO DATA';
  //   }
  //   switch (_words[1]) {
  //     case 'X':
  //       _decoded[1] = 'KIA MOTORS';
  //       break;
  //     default:
  //       _decoded[1] = 'NO DATA';
  //       break;
  //   }
  //   switch (_words[9]) {
  //     case 'M':
  //       _decoded[9] = '21MY';
  //       break;
  //     case 'N':
  //       _decoded[9] = '22MY';
  //       break;
  //     case 'P':
  //       _decoded[9] = '23MY';
  //       break;
  //     default:
  //       _decoded[9] = 'NO DATA';
  //   }
  //   switch (_words[10]) {
  //     case 'G':
  //       _decoded[10] = 'Georgia KMMG';
  //       break;
  //     default:
  //       _decoded[10] = 'NO DATA';
  //       break;
  //   }

  //   switch (_words[3]) {
  //     // MQ4a
  //     case 'R':
  //       _decoded[3] = 'MQ4a';
  //       switch (_words[2]) {
  //         case 'Y':
  //           _decoded[2] = 'MPV (multi-purpose vehicle)';
  //           break;
  //         default:
  //           _decoded[2] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[4]) {
  //         case 'G':
  //           _decoded[4] = 'LX';
  //           break;
  //         case 'L':
  //           _decoded[4] = 'S Trim';
  //           break;
  //         case 'H':
  //           _decoded[4] = 'EX';
  //           break;
  //         case 'K':
  //           _decoded[4] = 'SX';
  //           break;
  //         default:
  //           _decoded[4] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[5]) {
  //         case '4':
  //           _decoded[5] = '2WD';
  //           break;
  //         case 'D':
  //           _decoded[5] = '4WD';
  //           break;
  //         default:
  //           _decoded[5] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[6]) {
  //         case 'L':
  //           _decoded[6] =
  //               '1st Row Side Airbag\n1st & 2nd Row Curtain Airbag\nKnee Airbag';
  //           break;
  //         default:
  //           _decoded[6] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[7]) {
  //         case 'C':
  //           _decoded[7] = '2.5 GDI';
  //           break;
  //         case 'F':
  //           _decoded[7] = '2.5 T-GDI';
  //           break;
  //         default:
  //           _decoded[7] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[8]) {
  //         default:
  //           _decoded[8] = _words[8];
  //       }
  //       break;
  //     // Telluride
  //     case 'P':
  //       _decoded[3] = 'Telluride';
  //       switch (_words[2]) {
  //         case 'X':
  //           _decoded[2] = 'X Passenger Car (A2/A3) Non - North America';
  //           break;
  //         case 'Y':
  //           _decoded[2] =
  //               'MPV (multi-purpose vehicle) (A4/A6/A7) North America';
  //           break;
  //         default:
  //           _decoded[2] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[4]) {
  //         case '2':
  //           _decoded[4] = 'GL = LX';
  //           break;
  //         case '3':
  //           _decoded[4] = 'GLS = EX';
  //           break;
  //         case '5':
  //           _decoded[4] = 'TOP = SX';
  //           break;
  //         case '6':
  //           _decoded[4] = 'PGL = S Trim';
  //           break;
  //         default:
  //           _decoded[4] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[5]) {
  //         case '4':
  //           _decoded[5] = '2WD - NA (A4/A6/A7) Class D';
  //           break;
  //         case 'D':
  //           _decoded[5] = 'AWD - NA (A4/A6A7) Class D';
  //           break;
  //         case '8':
  //           _decoded[5] = 'Wagon = All Non NA (A2/A3)';
  //           break;
  //         default:
  //           _decoded[5] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[6]) {
  //         case 'H':
  //           _decoded[6] =
  //               'DAB/PAB/1st Row Side Airbag\n1st/2nd/3rd Row Curtain Airbag\nDriver Knee Airbag - NA Only (A4/A6/A7)';
  //           break;
  //         case 'I':
  //           _decoded[6] = 'All Non NA (A2/A3)';
  //           break;
  //         default:
  //           _decoded[6] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[7]) {
  //         case 'C':
  //           _decoded[7] = '3.8 GDI';
  //           break;
  //         default:
  //           _decoded[7] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[8]) {
  //         case 'B':
  //           _decoded[8] = 'LHD + AT (Non - GCC + Kurdistan)';
  //           break;
  //         case 'D':
  //           _decoded[8] = 'LHD + AT + Transfer (Non - GCC + Kurdistan)';
  //           break;
  //         default:
  //           _decoded[8] = _words[8] + ' - A4/A6/A7 and GCC + Kurdistan';
  //           break;
  //       }
  //       break;
  //     // Optima
  //     case 'G':
  //       _decoded[3] = 'Optima';
  //       switch (_words[2]) {
  //         case 'X':
  //           _decoded[2] = 'Passenger Car';
  //           break;
  //         default:
  //           _decoded[2] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[4]) {
  //         case '2':
  //           _decoded[4] = 'LX';
  //           break;
  //         case 'I':
  //           _decoded[4] = 'LXS';
  //           break;
  //         case '6':
  //           _decoded[4] = 'GT Line';
  //           break;
  //         case '3':
  //           _decoded[4] = 'EX';
  //           break;
  //         case '4':
  //           _decoded[4] = 'GT';
  //           break;
  //         default:
  //           _decoded[4] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[5]) {
  //         case '4':
  //           _decoded[5] = '2WD';
  //           break;
  //         default:
  //           _decoded[5] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[6]) {
  //         case 'J':
  //           _decoded[6] =
  //               '1st & 2nd Row Side Airbag\n1st & 2nd Row Curtain Airbag\nKnee Airbag';
  //           break;
  //         default:
  //           _decoded[6] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[7]) {
  //         case '2':
  //           _decoded[7] = '1.6 T-GDI';
  //           break;
  //         case '8':
  //           _decoded[7] = '2.5 T-GDI';
  //           break;
  //         default:
  //           _decoded[7] = 'NO DATA';
  //           break;
  //       }
  //       switch (_words[8]) {
  //         default:
  //           _decoded[8] = _words[8];
  //       }
  //       break;
  //     default:
  //       _decoded[3] = 'NO DATA';
  //       break;
  //   }

  //   _decoded[11] = widget.result.substring(11, 17);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: _bodyWidget(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      titleSpacing: 0.0,
      title: MainLogo(subtitle: 'homePage3'.tr()),
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _number(),
          _items('Country Assembled', _decoded[0]),
          SizedBox(height: 12.0),
          _items('Manufacturer', _decoded[1]),
          SizedBox(height: 12.0),
          _items('Vehicle Type', _decoded[2]),
          SizedBox(height: 12.0),
          _items('Model', _decoded[3]),
          SizedBox(height: 12.0),
          _items('Grade', _decoded[4]),
          SizedBox(height: 12.0),
          _items('Weight', _decoded[5]),
          SizedBox(height: 12.0),
          _items('Airbag/Restraint', _decoded[6]),
          SizedBox(height: 12.0),
          _items('Engine Type', _decoded[7]),
          SizedBox(height: 12.0),
          _items(
              'Check Digit - Must be 0-9 or X Or Drive Type (ON)', _decoded[8]),
          SizedBox(height: 12.0),
          _items('Model Year', _decoded[9]),
          SizedBox(height: 12.0),
          _items('Assembly Plant', _decoded[10]),
          SizedBox(height: 12.0),
          _items('Production (frame) Sequence Number', _decoded[11]),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget _number() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 26.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VIN',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            widget.result,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _items(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 20.0),
          width: double.maxFinite,
          color: Colors.grey[300],
          child: Text(
            title,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
