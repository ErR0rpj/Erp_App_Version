import 'package:flutter/material.dart';

//TODO: Implement denyAction conditional deny button
Future<void> showDialogWrapper(
    {required BuildContext context,
    required Function affirmAction,
    Function? denyAction,
    required String dialogMessage,
    required bool barrierDismissible,
    required String title}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(dialogMessage),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              affirmAction();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              if (denyAction != null) denyAction();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
