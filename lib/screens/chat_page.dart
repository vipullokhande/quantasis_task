import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantasis_task/providers/firebase_provider.dart';
import 'package:quantasis_task/resources/comment_methods.dart';

class ChatPage extends StatefulWidget {
  final String uid;
  const ChatPage({
    super.key,
    required this.uid,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final auth = FirebaseAuth.instance;
  var chatController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.uid)
      ..getMessages(widget.uid);
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 239, 239, 239),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 239, 239, 239),
            toolbarHeight: 10,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    controller: value.scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: value.messages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: widget.uid == value.messages[index].senderId
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: Column(
                          crossAxisAlignment:
                              widget.uid == value.messages[index].senderId
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                value.messages[index].content,
                                maxLines: 20,
                                textAlign:
                                    widget.uid == value.messages[index].senderId
                                        ? TextAlign.start
                                        : TextAlign.end,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: widget.uid ==
                                          value.messages[index].senderId
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: chatController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter message',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (chatController.text.isNotEmpty) {
                        await CommentMethods().postComment(
                          receiverUid: widget.uid,
                          text: chatController.text,
                        );
                        chatController.clear();
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
