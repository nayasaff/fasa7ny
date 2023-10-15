import 'package:fasa7ny/screens/home/categories_screen.dart';
import 'package:fasa7ny/screens/home/postGrid_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen({Key? key, this.uid: ""}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> isFavoriteList = [];

  List<String> strs = [
    "activities",
    "religious",
    "historical",
    "beaches",
    "cafes",
    'museums',
    'art galleries'
  ];
  List<String> favoritePosts = [];

  late String userId;

  void initializeUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  final CollectionReference _posts =
      FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //nash
      stream: _posts.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Categories_Screen(),
                PostGrid_screen(
                  snapshot: snapshot,
                  height: 300,
                ),
                const SizedBox(height: 50),
                Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Text(
                      'Explore',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    )),
                PostGrid_screen(snapshot: snapshot, height: 700)
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}


//profile page
//add dark mode to post info
//better ui/ux
//better pop up ui
//test post a photo

