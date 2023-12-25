import 'package:asyikaja/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;

  TextEditingController usernameCtl = TextEditingController(),
      passwordCtl = TextEditingController();

  String errorMessage = "";

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
                "Daftar ke AsyikAja",
                style: TextStyle(fontFamily: 'Alata', fontSize: 18),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Selamat Datang! Masuk menggunakan akun sosial atau email anda untuk melanjutkan",
                style: TextStyle(fontFamily: 'Abel', color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                  controller: usernameCtl,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Email',
                  )),
              TextFormField(
                  controller: passwordCtl,
                  obscuringCharacter: "*",
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Password',
                  )),
              const SizedBox(
                height: 24,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        isLoading = true;
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: usernameCtl.text,
                                  password: passwordCtl.text);
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case "ERROR_INVALID_EMAIL":
                              errorMessage =
                                  "Your email address appears to be malformed.";
                              break;
                            case "ERROR_WRONG_PASSWORD":
                              errorMessage = "Your password is wrong.";
                              break;
                            case "ERROR_USER_NOT_FOUND":
                              errorMessage =
                                  "User with this email doesn't exist.";
                              break;
                            case "ERROR_USER_DISABLED":
                              errorMessage =
                                  "User with this email has been disabled.";
                              break;
                            case "ERROR_TOO_MANY_REQUESTS":
                              errorMessage =
                                  "Too many requests. Try again later.";
                              break;
                            case "ERROR_OPERATION_NOT_ALLOWED":
                              errorMessage =
                                  "Signing in with Email and Password is not enabled.";
                              break;
                            default:
                              errorMessage =
                                  "An undefined Error happened: ${e.message ?? ""}";
                          }
                          isLoading = false;
                        }
                        setState(() {});

                        // Navigator.pushAndRemoveUntil(context,
                        //     MaterialPageRoute(builder: (context) => const HomePage()), (route)=>false);
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(16), child: Text("Login"))),
              Text(errorMessage)
            ]),
          )),
    );
  }
}
