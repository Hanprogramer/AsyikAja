import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
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
                    padding: const EdgeInsets.fromLTRB(16,2,16,2),
                    // height: 56,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: const BorderRadius.all(Radius.circular(16))),
                    child: const TextField(
                        decoration: InputDecoration(
                            hintText: "Cari Teman", border: InputBorder.none))),
              ),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primaryContainer),),
                  onPressed: () {}, 
                  child: const SizedBox(height: 56,child: Icon(Icons.search),)
              )
            ],
          ),
          const Text("Hasil Pencarian: "),
          Expanded(
            child: ListView(),
          )
        ],
      ),
    );
  }
}
