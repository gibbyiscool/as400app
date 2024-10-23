
import 'package:flutter/material.dart';


class InactiveMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'This menu is not active.',
        style: TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: 16),
        ),
      ),
    );
  }
}