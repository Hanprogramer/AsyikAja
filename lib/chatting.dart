import 'dart:async';

import 'package:asyikaja/controls/chat_item.dart';
import 'package:asyikaja/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatMessageData {
  String id;
  String from, content;
  Timestamp timestamp;
  final bool isMe;

  ChatMessageData(this.id, this.from, this.content, this.timestamp, this.isMe);

  String getTimeString() {
    return DateTime.parse(timestamp.toDate().toString()).toString();
  }
}

class ChattingPage extends StatefulWidget {
  final ChatUser user;
  final String chatID;

  const ChattingPage({super.key, required this.user, required this.chatID});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  List<ChatMessageData> chats = [];
  String ourUserID = "";

  var chatFieldController = TextEditingController();
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    () async {
      ourUserID =
          (await SharedPreferences.getInstance()).getString("userID") ?? "";
      FirebaseFirestore.instance
          .collection("messages")
          .doc(widget.chatID)
          .collection("messages")
          .orderBy("timestamp", descending: false)
          .limitToLast(100)
          .snapshots()
          .listen((event) {
        for (var i in event.docs) {
          var found = false;
          for (var c in chats) {
            if (c.id == i.id) {
              found = true;
              break;
            }
          }
          if (!found) {
            chats.add(ChatMessageData(i.id, i["from"], i["content"],
                i["timestamp"], i["from"] == ourUserID));
          }
          // print(i["content"]);
        }

        if (mounted) {
          setState(() {
            Future.delayed(const Duration(milliseconds: 100), () {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _scrollDown());
            });
          });
        }
      });
    }();
  }

// This is what you're looking for!
  void _scrollDown() {
    setState(() {
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
      );
    });
  }

  void sendMessage(String message) {
    FirebaseFirestore.instance
        .collection("messages")
        .doc(widget.chatID)
        .collection("messages")
        .add({
      "content": message,
      "from": ourUserID,
      "timestamp": Timestamp.now()
    });
  }

  void readInitialMessages() async {
    var cht = await FirebaseFirestore.instance
        .collection("messages")
        .doc(widget.chatID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .limitToLast(100)
        .get();
    for (var c in cht.docs) {
      chats.add(ChatMessageData(c.id, c["from"], c["content"], c["timestamp"],
          c["from"] == ourUserID));
    }
    // Update UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 201, 198, 189),
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Row(
              children: [
                ChatUserAvatar(user: widget.user),
                const SizedBox(
                  width: 12,
                ),
                Text(widget.user.displayName)
              ],
            )),
        body: Container(
            child: ListView.builder(
                controller: scrollController,
                itemCount: chats.length,
                itemBuilder: (c, i) {
                  return ChatItem(
                      message: chats[i].content,
                      time: chats[i].getTimeString(),
                      isMe: chats[i].isMe);
                })),
        bottomNavigationBar: Container(
            padding: const EdgeInsets.all(8),
            height: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                      margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      // height: 56,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(32))),
                      child: TextField(
                          controller: chatFieldController,
                          decoration: const InputDecoration(
                              hintText: "Pesan", border: InputBorder.none))),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendMessage(chatFieldController.text);
                    chatFieldController.clear();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.inversePrimary)),
                  child: const Icon(Icons.send),
                )
              ],
            )));
  }
}
