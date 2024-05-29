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

  /*@override
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
  }*/

@override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildVerticalText(text, constraints.maxHeight),
        );
      },
    );
  }

  Widget _buildVerticalText(String text, double maxHeight) {
    List<Widget> columns = [];
    double currentHeight = 0;
    List<String> currentColumn = [];

    double charHeight = (style?.fontSize ?? 14) + space;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (char == '\n' || currentHeight + charHeight > maxHeight) {
        // Add current column as a widget
        columns.add(_buildColumn(currentColumn));
        currentColumn = [];
        currentHeight = 0;
        if (char == '\n') {
          // Skip adding newline character
          continue;
        }
      }
      currentColumn.add(char);
      currentHeight += charHeight;
    }

    // Add the last column
    if (currentColumn.isNotEmpty) {
      columns.add(_buildColumn(currentColumn));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl, // Right to Left
      children:  columns,
    );
  }

  Widget _buildColumn(List<String> chars) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: chars.map((char) {
        return Padding(
          padding: EdgeInsets.only(bottom: space),
          child: Text(VerticalRotated.rotate(char), style: style),
        );
      }).toList(),
    );
  }
}