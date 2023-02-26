import 'package:flutter/material.dart';
import 'package:iplus_guest/src/model/user.dart';

class UserConfirmDialog {
  final BuildContext context;
  final String title;
  final User user;
  final String text1;
  final String text2;
  final String cancelText;
  final String confirmText;

  final dynamic onConfirm;

  UserConfirmDialog(
      {required this.context,
      required this.title,
      required this.cancelText,
      required this.confirmText,
      required this.user,
      required this.onConfirm,
      required this.text1,
      required this.text2}) {
    initAlertDialog();
  }

  void initAlertDialog() {
    Widget cancelButton = TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(cancelText),
    );

    Widget confirmButton = TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: onConfirm,
      child: Text(confirmText),
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16.0, color: Colors.black),
          children: [
            TextSpan(text: text1),
            TextSpan(
              text: user.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: text2),
          ],
        ),
      ),
      actions: [cancelButton, confirmButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
}
