import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'messages.dart';

/// Add Friend page
/// Allows user to search and add friends

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  List<ChatUser> result = [];
  bool isLoading = false;
  late String ourUserID;
  TextEditingController queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    () async {
      ourUserID =
          (await SharedPreferences.getInstance()).getString("userID") ?? "";
    }();
  }

  /// Search for users in the database based on the username.
  void search(String query) async {
    setState(() {
      isLoading = true;
      result.clear();
    });
    var r =
        await FirebaseFirestore.instance.collection("users").limit(100).get();
    // TODO: query search username correctly
    for (var userData in r.docs) {
      if(userData["id"] == ourUserID) continue;
      var username = userData["username"] as String;
      if (username.contains(query)) {
        result.add(ChatUser(userData.id, userData["username"],
            userData["displayName"], userData["pfpUrl"],
            isFriend: await isFriend(userData["id"])));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<bool> isFriend(String uid) async {
    var result = await FirebaseFirestore.instance
        .collection("users")
        .doc(ourUserID)
        .get();
    var friends = result["friends"] as List<dynamic>;
    return friends.contains(uid);
  }

  void addFriend(String uid) async {
    var userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(ourUserID)
        .get();

    var friends = userData["friends"] as List<dynamic>;

    if (!friends.contains(uid)) {
      friends.add(uid);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(ourUserID)
          .update({"friends": friends});
    }
    setState(() {
      search(queryController.text);
    });
  }


  void removeFriend(String uid) async {
    var userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(ourUserID)
        .get();

    var friends = userData["friends"] as List<dynamic>;

    if (friends.contains(uid)) {
      friends.remove(uid);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(ourUserID)
          .update({"friends": friends});
    }
    setState(() {
      search(queryController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                    // height: 56,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                    child: TextField(
                        controller: queryController,
                        decoration: const InputDecoration(
                            hintText: "Cari Teman", border: InputBorder.none))),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primaryContainer),
                  ),
                  onPressed: () {
                    search(queryController.text);
                  },
                  child: const SizedBox(
                    height: 56,
                    child: Icon(Icons.search),
                  ))
            ],
          ),
          const Text("Hasil Pencarian: "),
          isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                      itemCount: result.length,
                      itemBuilder: (c, i) {
                        return ListTile(
                          leading: ChatUserAvatar(user: result[i]),
                          title: Text(result[i].displayName),
                          subtitle: Text(result[i].username),
                          trailing: ElevatedButton(
                            onPressed: () {
                              if(result[i].isFriend!) {
                                removeFriend(result[i].id);
                              }else{
                                addFriend(result[i].id);
                              }
                            },
                            child: Text(result[i].isFriend! ? "Unfriend" : "Add Friend"),
                          ),
                        );
                      }),
                )
        ],
      ),
    );
  }
}
