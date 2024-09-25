import 'package:flutter/material.dart';

const Color scaffoldColor = Colors.red;

PreferredSizeWidget appBar(BuildContext context) {
  return AppBar(
    title: const Text(
      "MyNews",
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        color: Color(0xFF0C54BE),
      ),
    ),
    backgroundColor: Theme.of(context).primaryColor,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
  );
}
