import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  const ChatBubble({super.key, required this.message, required this.isCurrentUser, required this.messageId, required this.userId});

  //show options
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              // report message button button
              ListTile(
                leading: Icon(Icons.report),
                title: Text("Report Message"),
                onTap: () {
                  //report message
                  Navigator.pop(context);
                  _reportMessage(context, messageId, userId);
                },
              ),
              // block user button
              ListTile(
                  leading: Icon(Icons.block),
                  title: Text("Block User"),
                  onTap: () {
                    //block user
                    Navigator.pop(context);
                    _blockUser(context, userId);
                  }),

              // cancel button
              ListTile(leading: Icon(Icons.cancel), title: Text("Cancel"), onTap: () => Navigator.pop(context))
            ],
          ));
        });
  }

  // report message
  void _reportMessage(BuildContext context, String messageId, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Report Message"),
          content: Text(
            "Are you sure you want to report this message?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                ChatService().reportUser(messageId, userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Message reported")));
              },
              child: Text("Report"),
            ),
          ]),
    );
  }

  // block user
  void _blockUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text("Block User"),
          content: Text(
            "Are you sure you want to block this user?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                ChatService().blockUser(userId);
                //dismiss dialog
                Navigator.pop(context);
                //dismiss page
                Navigator.pop(context);
                // show result by snack bar
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Blocked!")));
              },
              child: Text("Block"),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // light vs dark mode for correct bubble colors
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          //show options
          _showOptions(context, messageId, userId);
        }
      },
      child: Container(
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
      ),
    );
  }
}
