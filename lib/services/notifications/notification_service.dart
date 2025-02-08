import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _messageStreamController = BehaviorSubject<RemoteMessage>();

// REQUEST PERMISSIONS: call this in main on start up
  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("user granted provisional permission");
    } else {
      print("user declined or has not accepted permission");
    }
  }

  //SETUP INTERACTION
  void setupInteractions() {
    //user receives message
    FirebaseMessaging.onMessage.listen((event) {
      print("Got a message whilst in the foreground!");
      print("Message data: ${event.data}");

      _messageStreamController.sink.add(event);
    });

    //user opened message
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Message clicked!");
    });
  }

  void dispose() {
    _messageStreamController.close();
  }

/*
- SETUP TOKEN LISTENERS
- EACH DEVICE HAS ITS OWN TOKEN, WE WILL GET THIS TOKEN SO THAT WE KNOW WHICH DEVICE TO SEND NOTIFICATION TO
* */
  void setupTokenListeners() {
    FirebaseMessaging.instance.getToken().then((token) {
      saveTokenToDatabase(token);
    });

    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

//SAVE DEVICE TOKEN
  void saveTokenToDatabase(String? token) async {
    //get current user id
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    //if the  current user is logged in and it has a token, save it to db
    if (userId != null && token != null) {
      await FirebaseFirestore.instance.collection("Users").doc(userId).set(
        {"fcmToken": token},
        SetOptions(merge: true),
      );
    }
  }

/*
//CLEAR DEVICE TOKEN
- It's important to clear the device token when the user logs out,
- log back in, the new token will be saved
*/
  Future<void> clearTokenOnLogout(String userId) async {
    try {
      await FirebaseFirestore.instance.collection("Users").doc(userId).update({
        "fcmToken": FieldValue.delete(),
      });
      print("Token cleared successfully");
    } catch (e) {
      print("Error clearing token: $e");
    }
  }
}
