import 'package:flutter/material.dart';
import 'package:snack/snack.dart';

void showSnackBar(BuildContext context, String message) {
  SnackBar(
    content: Text(
      message,
      style:const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    
    backgroundColor: Colors.red,
    elevation: 2,
  ).show(context);
}
