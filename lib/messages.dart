import 'package:asyikaja/chatting.dart';
import 'package:asyikaja/create_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class ChatMessage {
  String chatID;
  String displayName;
  String pfpUrl;
  ChatUser from;
  String lastMessage;
  String lastMessageTimeStamp;

  ChatMessage(
      this.chatID, this.displayName, this.pfpUrl, this.from, this.lastMessage, this.lastMessageTimeStamp);
}

class ChatUser {
  String id, username, displayName;
  String profilePicUrl;

  ChatUser(this.id, this.username, this.displayName, this.profilePicUrl);
}

class ChatUserAvatar extends StatelessWidget {
  final ChatUser user;

  const ChatUserAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text(user.profilePicUrl.isEmpty
          ? user.displayName
              .split(" ")
              .reduce((value, element) => value[0] + element[0])
          : user.profilePicUrl),
    );
  }
}

class _MessagesPageState extends State<MessagesPage>
    with AutomaticKeepAliveClientMixin<MessagesPage> {
  String ourUserID = "xPnwcsW1kig1ab5Erq3K6AjJ43f2";
  List<ChatMessage> messages = [];

  Future<ChatUser?> getChatUser(String id) async {
    var userData = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: id)
        .get();

    if (userData.docs.isNotEmpty) {
      var user = ChatUser(userData.docs[0]["id"], userData.docs[0]["username"],
          userData.docs[0]["displayName"], userData.docs[0]["pfpUrl"]);
      return user;
    }

    return null;
  }

  void getMessages() async {
    var msgDocs = await FirebaseFirestore.instance
        .collection("messages")
        .where("users", arrayContains: "xPnwcsW1kig1ab5Erq3K6AjJ43f2")
        .get();
    for (var m in msgDocs.docs) {
      var fromUserID =
          m["users"][0] == ourUserID ? m["users"][1] : m["users"][0];
      var fromUser = await getChatUser(fromUserID);
      if (fromUser != null) {
        var lastMsg = await getLastMessage(m.id);
        messages.add(ChatMessage(m.id, fromUser.displayName,
            fromUser.profilePicUrl, fromUser, lastMsg[0], lastMsg[1]));
      }
    }
    if(mounted) {
      setState(() {});
    }
  }

  Future<List<dynamic>> getLastMessage(String chatID) async {
    var msgDocs = await FirebaseFirestore.instance
        .collection("messages")
        .doc(chatID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .limitToLast(1)
        .get();

    if (msgDocs.size > 0) {
      var lastMsg = msgDocs.docs[0];
      return [
        lastMsg["content"],
        DateTime.parse((lastMsg["timestamp"] as Timestamp).toDate().toString()).toString()
    ];
    }
    return ["No chat messages", ""];
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const CreateMessagePage()));
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
            child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(messages[index].displayName),
                      subtitle: Text(messages[index].lastMessage),
                      leading: ChatUserAvatar(user: messages[index].from),
                      trailing: Text(messages[index].lastMessageTimeStamp),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => ChattingPage(
                                      user: messages[index].from,
                                      chatID: messages[index].chatID,
                                    )));
                      });
                })));
  }

  @override
  bool get wantKeepAlive => true;
}
