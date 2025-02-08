const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnMessage = functions.firestore
.document('ChatRooms/{chatRoomId}/messages/{messageId}')
.onCreate(async (snapshot, context) => {
    const message = snapshot.data();

    try{
        const receiverDoc = await admin.firestore().collection('Users').doc(message.receiverId).get();
        if(!receiverDoc.exists){
            console.log('Receiver not found');
            return null;
        }
        const receiverData receiverDoc.data();
        const token = receiverData.fcmToken;

        if(!token){
            console.log('No token found for receiver, can not send notification!');
            return null;
        }

        // update message payload for 'send' method
        const messagePayload = {
            token: token,
            notification: {
                title: 'New Message',
                body: '${message.senderEmail} says: ${message.message}',
            },
            android:{
                notification:{
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                }
            },
            apns:{
                payload:{
                    aps:{
                        category: 'FLUTTER_NOTIFICATION_CLICK',
                    }
                }
            }
        };

        //send the notification
        const response = await admin.messaging().send(messagePayload);
        console.log('Notification sent successfully: ${response}');
    } catch(error) {
        console.error('Error sending notification: ${error}');
        if(error.code && error.message){
            console.log('Error code: ', error.code);
            console.log('Error message: ', error.message);
        }
        throw new Error('Failed to send notification');
    }
})