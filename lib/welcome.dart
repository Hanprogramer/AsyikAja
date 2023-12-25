import 'package:asyikaja/home.dart';
import 'package:asyikaja/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text("Masuk"))),
                        const SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage()));
                            },
                            child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text("Daftar")))
                      ],
                    )
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        if (user == null) {
          setState(() {
            isLoading = false;
          });
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (c) => const HomePage()),
              (route) => false);
        }
      }
    });
  }
}
