import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
// get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// get all users stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

// get all users except blocked user
  Stream<List<Map<String, dynamic>>> getUsersStreamExceptBlocked() {
    final currentUser = _auth.currentUser;
    return _firestore.collection('Users').doc(currentUser!.uid).collection("BlockedUsers").snapshots().asyncMap((snapshot) async {
      //get blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      //get all users except blocked user
      final usersSnapshot = await _firestore.collection('Users').get();
      //return as stream list, excluding current user and blocked users
      final usersData = await Future.wait(
        //get all docs
        usersSnapshot.docs
            // excluding current user and blocked users
            .where((doc) => doc.data()['email'] != currentUser.email && !blockedUserIds.contains(doc.id))
            .map((doc) async {
          //look at each user
          final userData = doc.data();
          //end their chat rooms
          final chatRoomId = [currentUser.uid, doc.id]..sort();
          //count the number of unread messages
          final unreadMessagesSnapshot = await _firestore
              .collection("ChatRooms")
              .doc(chatRoomId.join("_"))
              .collection("messages")
              .where("receiverID", isEqualTo: currentUser.uid)
              .where("isRead", isEqualTo: false)
              .get();
          userData["unreadCount"] = unreadMessagesSnapshot.docs.length;
          return userData;
        }).toList(),
      );
      return usersData;
    });
  }

// send mess
  Future<void> sendMessage(String receiverID, String message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
      isRead: false,
    );
    //construct chat room ID for two users
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");

    //add message to firestore
    await _firestore.collection("ChatRooms").doc(chatRoomID).collection("messages").add(newMessage.toMap());
  }

// get mess
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firestore.collection("ChatRooms").doc(chatRoomID).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }

//mark messages as read
  Future<void> markMessagesAsRead(String receiverID) async {
    // get current user id
    final currentUserID = _auth.currentUser!.uid;
    //get chat room
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");
    //get unread messages
    final unreadMessagesQuery =   _firestore
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("messages")
        .where("receiverID", isEqualTo: currentUserID)
        .where("isRead", isEqualTo: false);
    final unreadMessagesSnapshot = await unreadMessagesQuery.get();

    //go through each messages and mark them as read
    for (final doc in unreadMessagesSnapshot.docs) {
      await doc.reference.update({"isRead": true});
    }
  }

//report user
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('Reports').add(report);
  }

//block user
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore.collection('Users').doc(currentUser!.uid).collection("BlockedUsers").doc(userId).set({});
    notifyListeners();
  }

//unblock user
  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser;
    await _firestore.collection('Users').doc(currentUser!.uid).collection("BlockedUsers").doc(blockedUserId).delete();
    notifyListeners();
  }

// get blocked users stream
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore.collection('Users').doc(userId).collection("BlockedUsers").snapshots().asyncMap((snapshot) async {
      //get blocked user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      //get user data for each blocked user
      final userDocs = await Future.wait(blockedUserIds.map((id) => _firestore.collection('Users').doc(id).get()));
      //return as a list
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
