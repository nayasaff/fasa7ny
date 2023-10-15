import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fasa7ny/providers/idProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fasa7ny/reusable_widgets/reusable_widget.dart';
import 'package:flutter/material.dart';
import '../../utils/colors_utils.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  void getImage(String username, String email, String uid) async {
    final coll = FirebaseFirestore.instance.collection("users").doc(uid);
    await coll.set({
      'username': _userNameTextController.text,
      'email': _emailTextController.text,
      'profilePicture': "",
      'favorites': [],
      'posts': []
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerId = Provider.of<IdProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              hexStringToColor("E59400"),
              hexStringToColor("C37F00"),
              hexStringToColor("FFE5B4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter Email", Icons.email, false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    FirebaseAuth.instance.authStateChanges().listen((user) {
                      if (user != null) {
                        getImage(
                          _userNameTextController.text,
                          _emailTextController.text,
                          user.uid,
                        );
                        providerId.setId(value.user!.uid);
                        Navigator.pushNamed(context, '/homePage');
                      }
                    });
                  }).onError((error, stackTrace) {
                    if (error.toString().contains("invalid")) {
                      final snackBar = SnackBar(
                        content: Text("INVALID EMAIL"),
                        backgroundColor: Colors.amber,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (error.toString().contains("6 charcters")) {
                      final snackBar = SnackBar(
                        content: Text("PASSWORD MUST BE AT LEAST 6 CHARACTERS"),
                        backgroundColor: Colors.amber,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (error.toString().contains("exists")) {
                      final snackBar = SnackBar(
                        content: Text("EMAIL ALREADY EXISTS"),
                        backgroundColor: Colors.amber,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      final snackBar = SnackBar(
                        content: Text(
                            "YOU HAVE EXCEEDED NUMBER OF ATTEMPTS TRY AGAIN LATER"),
                        backgroundColor: Colors.amber,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                }),
                TextButton(
                  child: Text(
                    "Enter as a guest",
                    style: TextStyle(color: Colors.white70),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/homePage');
                  },
                )
              ],
            ),
          ))),
    );
  }
}
