import 'package:asyikaja/home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
          margin: const EdgeInsets.all(24),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Login ke AsyikAja",
                style: TextStyle(fontFamily: 'Alata', fontSize: 18),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Selamat Datang kembali! Masuk menggunakan akun sosial atau email anda untuk melanjutkan",
                style: TextStyle(fontFamily: 'Abel', color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                  decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Email',
              )),
              TextFormField(
                  decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Password',
              )),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) => const HomePage()), (route)=>false);
                  },
                  child: const Padding(
                      padding: EdgeInsets.all(16), child: Text("Login")))
            ]),
          )),
    );
  }
}
