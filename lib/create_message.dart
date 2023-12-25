import 'package:flutter/material.dart';

class CreateMessagePage extends StatefulWidget {
  const CreateMessagePage({super.key});

  @override
  State<CreateMessagePage> createState() => _CreateMessagePageState();
}

class _CreateMessagePageState extends State<CreateMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tulis Pesan"),),
      body: ListView(children: const [

      ],),
    );
  }
}
