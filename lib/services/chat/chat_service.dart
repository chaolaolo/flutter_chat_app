import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
// get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
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
}
