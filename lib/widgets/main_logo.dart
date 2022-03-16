import 'package:flutter/material.dart';

class MainLogo extends StatelessWidget {
  final String? subtitle;
  const MainLogo({Key? key, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(
            'assets/images/amp.png',
          ),
        ),
        const SizedBox(width: 10.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kia Georgia Tech',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle != null
                ? Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ],
    );
  }
}
