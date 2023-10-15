import 'package:fasa7ny/providers/postProvider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Description extends StatefulWidget {
  Description();

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
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

  void addToFavorites(List<dynamic> liked_users, String id) async {
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("posts").doc(id);
    if (liked_users.contains(currentUserID)) {
      documentRef.update({
        'liked_users': FieldValue.arrayRemove([currentUserID])
      });
      setState(() {
        liked_users.remove(currentUserID);
      });
    } else {
      documentRef.update({
        'liked_users': FieldValue.arrayUnion([currentUserID])
      });
      setState(() {
        liked_users.add(currentUserID);
      });
    }
  }

  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(
                  postProvider.image,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => addToFavorites(
                          postProvider.getLikedUsers(), postProvider.getId()),
                      child: Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                              postProvider.liked_users.contains(currentUserID)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.redAccent),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (postProvider.getAvgRating()).toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 1),
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(postProvider.getName(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(
          height: 7,
        ),
        Text(
          postProvider.getDescription(),
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Divider(
          color: Colors.white70, // Customize the color of the line
          height: 50, // Adjust the height of the line
          thickness: 2, // Specify the thickness of the line
          indent: 20, // Set the indent (space) before the line starts
          endIndent: 20, // Set the indent (space) after the line ends
        ),
      ],
    );
  }
}
