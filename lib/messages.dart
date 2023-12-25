import 'package:asyikaja/chatting.dart';
import 'package:asyikaja/create_message.dart';
import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
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
        body: ListView(
          children: [
            ListTile(
                title: const Text("Haniel Jonathan"),
                subtitle: const Text("Halo!"),
                leading: const CircleAvatar(child: Text("H")),
                trailing: const Text("15 menit yang lalu"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const ChattingPage(title: "Haniel Jonathan")));
                }),
            const ListTile(
              title: Text("Haniel Jonathan"),
              subtitle: Text("Halo!"),
              leading: CircleAvatar(child: Text("H")),
              trailing: Text("15 menit yang lalu"),
            ),
            const ListTile(
              title: Text("Haniel Jonathan"),
              subtitle: Text("Halo!"),
              leading: CircleAvatar(child: Text("H")),
              trailing: Text("15 menit yang lalu"),
            ),
            const ListTile(
              title: Text("Haniel Jonathan"),
              subtitle: Text("Halo!"),
              leading: CircleAvatar(child: Text("H")),
              trailing: Text("15 menit yang lalu"),
            ),
          ],
        ));
  }
}
