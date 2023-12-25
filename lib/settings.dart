import 'package:asyikaja/main.dart';
import 'package:flutter/material.dart';

import 'welcome.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text("H"),
            ),
            title: Text("Haniel Jonathan"),
            subtitle: Text("hanjohnisthebest@gmail.com"),
          ),
          SizedBox(
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
            onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const WelcomePage()));
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