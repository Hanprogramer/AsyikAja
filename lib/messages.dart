import 'package:asyikaja/chatting.dart';
import 'package:asyikaja/create_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Messages Page
/// Place to find your friend's messages

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

/// ChatMessage
/// base object for all chats
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

/// ChatUser
/// base class for all users in the app
class ChatUser {
  String id, username, displayName;
  String profilePicUrl;

  bool? isFriend;

  ChatUser(this.id, this.username, this.displayName, this.profilePicUrl, {this.isFriend});
}

/// Helper class for Circle Avatar using custom user class
class ChatUserAvatar extends StatelessWidget {
  final ChatUser user;

  const ChatUserAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    var initial = getInitials(user.displayName);
    return CircleAvatar(
      child: Text(user.profilePicUrl.isEmpty
          ? initial
          : user.profilePicUrl),
    );
  }

  String getInitials(String name) {
    if (name.isEmpty) {
      return ""; // Handle empty name case
    }

    List<String> words = name.split(" ");
    String initials = "";

    for (int i = 0; i < words.length; i++) {
      initials += words[i][0].toUpperCase();
    }

    return initials;
  }
}

/// Message Page state
class _MessagesPageState extends State<MessagesPage>
    with AutomaticKeepAliveClientMixin<MessagesPage> {
  String ourUserID = "";
  List<ChatMessage> messages = [];

  /// Get user from their user ID only
  Future<ChatUser?> getChatUser(String id) async {
    var userData = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: id)
        .limit(1)
        .get();

    if (userData.docs.isNotEmpty) {
      var user = ChatUser(userData.docs[0]["id"], userData.docs[0]["username"],
          userData.docs[0]["displayName"], userData.docs[0]["pfpUrl"]);
      return user;
    }

    return null;
  }

  /// Get messages for our current user
  void getMessages() async {
    ourUserID = (await SharedPreferences.getInstance()).getString("userID") ?? "";
    var msgDocs = await FirebaseFirestore.instance
        .collection("messages")
        .where("users", arrayContains: ourUserID)
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
      if(mounted) {
        setState(() {});
      }
    }
  }

  /// Get last message in a message collection from firebase
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

  /// Load initial messages in the beginning of the app
  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        /// Floating action button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Move to the create message page
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const CreateMessagePage()));
          },
          child: const Icon(Icons.add),
        ),
        /// Creates a list view from our custom data helper
        body: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(messages[index].displayName),
                  subtitle: Text(messages[index].lastMessage),
                  leading: ChatUserAvatar(user: messages[index].from),
                  trailing: Text(messages[index].lastMessageTimeStamp),
                  onTap: () {
                    /// Move to the chat screen with specific user and userID
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => ChattingPage(
                                  user: messages[index].from,
                                  chatID: messages[index].chatID,
                                )));
                  });
            }));
  }

  /// So that the pages wont reload when switching tabs
  @override
  bool get wantKeepAlive => true;
}
