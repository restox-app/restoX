import 'package:flutter/material.dart';

class ErrorDialogV1 extends StatelessWidget {
  const ErrorDialogV1({Key? key, required this.errorString}) : super(key: key);

  final String errorString;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(errorString),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
        ),
      ],
    );
  }
}
