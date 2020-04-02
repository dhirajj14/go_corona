import 'package:flutter/material.dart';




class CountriesWidget extends StatelessWidget {
  final Color color;

  CountriesWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: new Text("Coming Soon...",
        style: new TextStyle(
          color: Colors.red[800],
          fontSize: 35.0,
        ),
        ),
      ),
    );
  }
}