import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chatting.dart';
import 'messages.dart';

/// CreateMessage page
/// Allows user to create a new message for a specific user ID

class CreateMessagePage extends StatefulWidget {
  const CreateMessagePage({super.key});

  @override
  State<CreateMessagePage> createState() => _CreateMessagePageState();
}

class _CreateMessagePageState extends State<CreateMessagePage> {
  List<ChatUser> friends = [];
  String ourUserID = "";

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

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  /// Load friends from the database
  void getFriends() async {
    ourUserID =
        (await SharedPreferences.getInstance()).getString("userID") ?? "";
    var userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(ourUserID)
        .get();

    var friendIDs = userData["friends"] as List<dynamic>;

    /// Iterate through every single data and adds it to our app
    for (var f in friendIDs) {
      var friend = await getChatUser(f);
      if (friend == null) continue;
      friends.add(friend);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tulis Pesan"),
        ),
        body: ListView.builder(
            itemCount: friends.length,
            itemBuilder: (c, i) {
              return ListTile(
                leading: ChatUserAvatar(
                  user: friends[i],
                ),
                title: Text(friends[i].displayName),
                onTap: () => createChat(context, friends[i]),
              );
            }));
  }

  /// Check if a person has chat with the other person
  Future<String?> checkHasChat(String uid) async {
    var result = await FirebaseFirestore.instance
        .collection("messages")
        .where("users", arrayContains: uid)
        .get();
    if (result.docs.isEmpty) {
      return null;
    }
    return result.docs[0].id;
  }

  /// Create a new chat in the database
  /// Use existing if already exist
  createChat(BuildContext context, ChatUser user) async {
    var existingChat = await checkHasChat(user.id);
    if (existingChat != null) {
      await Future.delayed(const Duration(microseconds: 100), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ChattingPage(
                      user: user,
                      chatID: existingChat,
                    )));
      });
    } else {
      var chat = FirebaseFirestore.instance.collection("messages").doc();
      // Set the participants
      await chat.set({
        "users": [ourUserID, user.id]
      });
      await chat.update({"id": chat.id});
      await Future.delayed(const Duration(microseconds: 100), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ChattingPage(
                      user: user,
                      chatID: chat.id,
                    )));
      });
    }
  }
}
