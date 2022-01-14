import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextSpanWithLink extends StatelessWidget {
  final String? normalText;
  final String? linkText;
  final Function()? onLinkTap;
  const TextSpanWithLink({this.normalText, this.linkText, this.onLinkTap});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: normalText,
                style: const TextStyle(color: Colors.black),
              ),
              TextSpan(
                  text: linkText,
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()..onTap = onLinkTap)
            ])));
  }
}
