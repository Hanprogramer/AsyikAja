import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Register page
/// Creates new user and sets it to the database

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;

  TextEditingController usernameCtl = TextEditingController(),
      passwordCtl = TextEditingController();

  /// In case of errors
  String errorMessage = "";

  /// Convert an email string to display name automatically
  String emailToDisplayName(String email) {
    // Split the email address into parts
    final parts = email.split('@');
    // Handle cases where there's no '@' or only one part
    if (parts.length < 2) {
      return email; // Return the original email if it's not a valid format
    }
    // Extract the local part (before '@')
    String name = parts[0];
    // Handle potential periods in the local part
    if (name.contains('.')) {
      name = name.split('.').map((part) => part.trim()).join(' ');
    }
    // Capitalize the first letter of each word
    name = name.split(' ').map((word) => word.toUpperCase().substring(0, 1) + word.substring(1).toLowerCase()).join(' ');
    return name;
  }

  /// Converts an email string to username
  /// followed with random numbers in case everything is too long
  String emailToUsername(String email) {
    // Get the display name from the email
    String displayName = emailToDisplayName(email);

    // Remove any special characters or spaces
    String username = displayName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');

    // Enforce lowercase letters
    username = username.toLowerCase();

    // Handle cases where the username is too long or empty
    if (username.length > 30) {
      username = username.substring(0, 30); // Truncate to 30 characters
    } else if (username.isEmpty) {
      username = "user${randomNumericString(5)}"; // Generate a unique username
    }

    return username;
  }

  /// Helper function to generate a random string of numbers
  String randomNumericString(int length) {
    final random = Random();
    final codes = Iterable.generate(length, (_) => random.nextInt(10)).map((n) => n.toString());
    return codes.join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Theme for the page
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
                  obscureText: true,
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
                          var credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: usernameCtl.text,
                                  password: passwordCtl.text);

                          // Create the user data
                          var uid = credential.user!.uid;
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .set({
                                "displayName": emailToDisplayName(usernameCtl.text),
                                "id" : uid,
                                "pfpUrl" : "",
                                "username" : emailToUsername(usernameCtl.text),
                                "friends" : [],
                                "email" : usernameCtl.text
                              });

                          // Menyimpan data
                          var pref = (await SharedPreferences.getInstance());
                          pref.setString("email", usernameCtl.text);
                          pref.setString("password", passwordCtl.text);
                          var id = credential.user?.uid ?? "";
                          pref.setString("userID", id);
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
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(16), child: Text("Daftar"))),
              Text(errorMessage)
            ]),
          )),
    );
  }
}
