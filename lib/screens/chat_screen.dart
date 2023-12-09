import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quantasis_task/screens/login_screen.dart';
import 'chat_page.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await auth.signOut();
              Get.offAll(
                const LoginScreenPage(),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                dynamic map = snapshot.data!.docs[index];
                return map['uid'] != auth.currentUser!.uid
                    ? ListTile(
                        onTap: () => Get.to(
                          () => ChatPage(
                            uid: map['uid'],
                          ),
                        ),
                        title: Text(
                          map['username'],
                        ),
                      )
                    : const SizedBox();
              });
        },
      ),
    );
  }
}
