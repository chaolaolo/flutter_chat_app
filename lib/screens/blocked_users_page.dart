import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  //chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

//show dialog confirm unblock
  void _showUnblockDialog(BuildContext context, userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Unblock User"),
              content: Text("Are you sure you want to unblock this user?"),
              actions: [
                //cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                //unblock button
                TextButton(
                  onPressed: () {
                    _chatService.unblockUser(userId);
                    // dismiss dialog
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User unblocked!")));
                  },
                  child: const Text("Unblock"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    //get current user id
    String userId = _authService.getCurrentUser()!.uid;

    // UI
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade300,
        title: Text("Blocked User"),
        actions: [],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatService.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading.."),
            );
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final blockedUsers = snapshot.data ?? [];

          //no users
          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text("No blocked users"),
            );
          }

          //loading complete
          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(text: user['email'], onTap: () => _showUnblockDialog(context, user['uid']));
            },
          );
        },
      ),
    );
  }
}
