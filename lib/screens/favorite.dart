import 'package:fasa7ny/screens/home/postCard_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoriteScreen> {
  User? userCred;

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  String? currentUserID;
  Future<void> initializeUser() async {
    String userID = await FirebaseAuth.instance.currentUser?.uid ?? "";
    setState(() {
      currentUserID = userID;
    });
  }

  final CollectionReference _posts =
      FirebaseFirestore.instance.collection('posts');

  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(),
        child: SafeArea(
          child: Theme(
            data: ThemeData.dark(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'FASA7NY',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.account_circle),
                        onPressed: () {
                          // TODO: Implement profile icon functionality
                        },
                      ),
                    ],
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Favourite Destinations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: _posts.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                            child: Center(
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    snapshot.data!.docs[index];
                                num avgRating = 0;
                                for (num i = 0;
                                    i < documentSnapshot['rating'].length;
                                    i++) {
                                  avgRating +=
                                      documentSnapshot['rating'][i]['number'];
                                }
                                double rating = avgRating /
                                    documentSnapshot['rating'].length;
                                return documentSnapshot["liked_users"]
                                        .contains(currentUserID)
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 30),
                                        child: PostCard_screen(
                                          isVertical: false,
                                          showName: true,
                                          rating: rating,
                                          documentSnapshot: documentSnapshot,
                                        ),
                                      )
                                    : Container();
                              }),
                        ));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
