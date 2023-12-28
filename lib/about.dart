import 'package:flutter/material.dart';


/// Welcome page
/// Includes menu to choose login or register

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(200)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ]),
                child: Image.asset("assets/logo.png", width: 190),
              ),
              const SizedBox(
                height: 64,
              ),
              const Column(
                children: [
                  Text("Dibuat Oleh:"),
                  Text("Haniel Jonathan"),
                  Text("Christina Febiola Sinaga"),
                  Text("Intan Dewiyanti"),
                  Text("Coky V. Habeahan"),
                ],
              )
            ],
          ),
        ));
  }
}
