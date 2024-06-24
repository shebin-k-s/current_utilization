import 'package:flutter/material.dart';

void snackbarMessage(BuildContext ctx, String message) {
  ScaffoldMessenger.of(ctx).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(32),
      content: Text(
        message,
        style: const TextStyle(fontSize: 18),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    ),
  );
}
