import 'package:asyikaja/controls/chat_item.dart';
import 'package:asyikaja/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessageData {
  String from, content;
  Timestamp timestamp;
  final bool isMe;

  ChatMessageData(this.from, this.content, this.timestamp, this.isMe);

  String getTimeString(){
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
  String ourUserID = "xPnwcsW1kig1ab5Erq3K6AjJ43f2";

  @override
  void initState() {
    super.initState();
    readInitialMessages();
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
      chats.add(ChatMessageData(
          c["from"], c["content"], c["timestamp"], c["from"] == ourUserID));
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
                      child: const TextField(
                          decoration: InputDecoration(
                              hintText: "Pesan", border: InputBorder.none))),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.inversePrimary)),
                  child: const Icon(Icons.send),
                )
              ],
            )));
  }
}
