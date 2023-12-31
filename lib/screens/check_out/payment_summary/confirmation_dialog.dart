import 'package:flutter/material.dart';
class ConfirmationDialog extends StatelessWidget {
  final Function() onConfirm;

  ConfirmationDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm Order"),
      content: Text("Are you sure you want to place the order?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            onConfirm(); // Call the onConfirm function
          },
          child: Text("Confirm"),
        ),
      ],
    );
  }
}
