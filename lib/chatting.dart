import 'package:asyikaja/controls/chat_item.dart';
import 'package:flutter/material.dart';

class ChattingPage extends StatefulWidget {
  final String title;

  const ChattingPage({super.key, required this.title});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 198, 189),
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Row(
              children: [
                CircleAvatar(
                  child: Text(widget.title
                      .split(" ")
                      .reduce((value, element) => value[0] + element[0])),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(widget.title)
              ],
            )),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChatItem(message: "Hello!", time: "15:30", isMe: true),
            ChatItem(message: "Hello", time: "15:30", isMe: false),
            ChatItem(message: "How are you today?", time: "15:30", isMe: true),
            ChatItem(
                message:
                    "I'm feeling really well actually! How about you? Are you feeling good?",
                time: "15:30",
                isMe: false),
          ],
        )),
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
