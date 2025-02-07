import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    // light vs dark mode for correct bubble colors
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 2),
      decoration: BoxDecoration(
        color:
            isCurrentUser ? (isDarkMode ? Colors.blueGrey.shade500 : Colors.blueGrey.shade200) : (isDarkMode ? Colors.grey[500] : Colors.grey[200]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
      ),
    );
  }
}
