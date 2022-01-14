import 'package:flutter/material.dart';
import 'package:inventory_app/utils/consts.dart';

class BigWideButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  BigWideButton({required this.onPressed, required this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
            onPressed: onPressed,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  AppConstants().width * 0.3,
                  AppConstants().height * 0.03,
                  AppConstants().width * 0.3,
                  AppConstants().height * 0.03),
              child: Text(
                text,
                style: TextStyle(fontWeight: BOLD_WEIGHT),
              ),
            )));
  }
}
