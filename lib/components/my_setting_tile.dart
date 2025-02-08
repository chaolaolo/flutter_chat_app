import 'package:flutter/material.dart';

class MySettingTile extends StatelessWidget {
  final String title;
  final Widget action;
  final Color color;
  final Color textColor;

  const MySettingTile({super.key, required this.title, required this.action, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(left: 25, right: 25, top: 10),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // title
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          //action
          action
        ],
      ),
    );
  }
}
