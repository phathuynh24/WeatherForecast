import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Divider()), // Creates the left line
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'or',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(child: Divider()), // Creates the right line
        ],
      ),
    );
  }
}
