import 'package:fight_app2/Utils/vertical_rotated.dart';
import 'package:flutter/material.dart';

class Tategaki extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double space;

  Tategaki({
    Key? key,
    required this.text,
    this.style,
    this.space = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: text.split("\n").map((line) => _buildVerticalText(line)).toList(),
    );
  }

  Widget _buildVerticalText(String line) {
    return Column(
      children: line.runes.map((rune) {
        String char = String.fromCharCode(rune);
        return Padding(
          padding: EdgeInsets.only(bottom: space),
          child: Text(VerticalRotated.rotate(char), style: style),
        );
      }).toList(),
    );
  }
}