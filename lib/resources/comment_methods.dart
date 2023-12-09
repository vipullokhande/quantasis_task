import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quantasis_task/models/message.dart';

class CommentMethods extends ChangeNotifier {
  Future<void> postComment({
    required String receiverUid,
    required String text,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    try {
      Message comment = Message(
        senderId: auth.currentUser!.uid,
        receiverId: receiverUid,
        content: text,
        sentTime: DateTime.now(),
      );
      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chat')
          .doc(receiverUid)
          .collection('messages')
          .add(comment.toJson());
      await firebaseFirestore
          .collection('users')
          .doc(receiverUid)
          .collection('chat')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .add(comment.toJson());
      notifyListeners();
    } catch (e) {
      //
    }
  }
}
