import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat & auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //for text field focus
  FocusNode _myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    _myFocusNode.addListener(() {
      if (_myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    //wait a bit for listview to be built, then scroll to bottom
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    _myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //send message method
  void _sendMessage() async {
    String message = _messageController.text;
    if (message.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, message);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.blueGrey.shade300,
      ),
      body: Column(
        children: [
          //display messages
          Expanded(
            child: _buildMessageList(),
          ),
          //user input
          _buildMessageInput(),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          // errors
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }
          // loading..
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // display messages
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: ListView(
              controller: _scrollController,
              children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
            ),
          );
        });
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // is current user
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;
    //align message right if sender is the current user, otherwise left
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
            messageId: doc.id,
            userId: data["senderID"],
          ),
        ],
      ),
    );
  }

//build message input
  Widget _buildMessageInput() {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      color: isDarkMode ? Colors.grey.shade600: Colors.grey.shade50,
      padding: const EdgeInsets.only(top: 4.0, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              hintText: "Type a message..",
              obscureText: false,
              controller: _messageController,
              focusNode: _myFocusNode,
            ),
          ),
          // send icon
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.blueGrey.shade300 : Colors.blueGrey.shade200,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: _sendMessage,
              icon: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
