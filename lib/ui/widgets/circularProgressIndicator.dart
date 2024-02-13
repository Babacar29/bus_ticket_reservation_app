// ignore_for_file: file_names
import 'package:flutter/material.dart';

Widget showCircularProgress(bool isProgress, Color color) {
  if (isProgress) {
    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(color)));
  }
  return const SizedBox.shrink();
}

 showCustomSnackBar({required BuildContext context, required String message, bool isError = true}) {
  final snackBar = SnackBar(
    content: Text(message, textScaler: const TextScaler.linear(1.2),),
    backgroundColor: Colors.green,
  );

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
