import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isDarkMode ? Colors.grey.shade300 : Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
