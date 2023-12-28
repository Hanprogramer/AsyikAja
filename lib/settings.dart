import 'package:asyikaja/main.dart';
import 'package:asyikaja/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String displayName = "", email = "", userID = "";
  ChatUser? user;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    var pref = await SharedPreferences.getInstance();
    email = pref.getString("email") ?? "Unknown email";
    userID = pref.getString("userID") ?? "";

    var userData =
        await FirebaseFirestore.instance.collection("users").doc(userID).get();
    displayName = userData["displayName"] ?? "Unknown";

    user = (await getChatUser(userID))!;
    setState(() {});
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: user == null
                ? const CircleAvatar()
                : ChatUserAvatar(user: user!),
            title: Text(displayName),
            subtitle: Text(email),
          ),
          const SizedBox(
            height: 30,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.camera),
            ),
            title: Text("Ganti Foto Profil"),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.security),
            ),
            title: Text("Ganti Password"),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.info),
            ),
            title: Text("Tentang Aplikasi"),
          ),
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
            leading: CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.logout),
            ),
            title: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
