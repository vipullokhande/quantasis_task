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
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.uid)
      ..getMessages(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FirebaseProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    controller: value.scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: value.messages.length,
                    itemBuilder: (context, index) {
                      return Align(
                        alignment: widget.uid != value.messages[index].senderId
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.uid != value.messages[index].senderId
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius:
                                widget.uid != value.messages[index].senderId
                                    ? const BorderRadius.only(
                                        topRight: Radius.circular(18),
                                        bottomRight: Radius.circular(18),
                                        topLeft: Radius.circular(18),
                                      )
                                    : const BorderRadius.only(
                                        topRight: Radius.circular(18),
                                        bottomLeft: Radius.circular(18),
                                        topLeft: Radius.circular(18),
                                      ),
                          ),
                          margin: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                widget.uid != value.messages[index].senderId
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                            children: [
                              Text(value.messages[index].content,
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
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
                      height: 55,
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
                        // ignore: use_build_context_synchronously
                        FocusScope.of(context).unfocus();
                      }
                      // ignore: use_build_context_synchronously
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.send,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
