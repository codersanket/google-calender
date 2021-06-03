import 'package:calender/core/model/failure_model.dart';
import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({
    Key? key,
    required this.failure,
    required this.context,
  }) : super(key: key);

  final Failure failure;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Error"),
      content: Text(failure.message),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Ok"))
      ],
    );
  }
}
