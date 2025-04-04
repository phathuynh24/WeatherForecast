import 'package:flutter/material.dart';

void showCustomSnackbar(BuildContext context, String message,
    {required bool isSuccess}) {
  Color backgroundColor = isSuccess ? Colors.green : Colors.red;
  IconData icon = isSuccess ? Icons.check_circle : Icons.error;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      width: 400,
    ),
  );
}
