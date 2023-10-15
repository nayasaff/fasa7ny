import 'package:fasa7ny/screens/info/PostInfo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:fasa7ny/providers/postProvider.dart';

class PostCard_screen extends StatefulWidget {
  final bool isVertical;
  final double rating;
  final bool showName;
  final DocumentSnapshot documentSnapshot;
  PostCard_screen(
      {required this.isVertical,
      required this.rating,
      required this.documentSnapshot,
      this.showName = false});

  @override
  State<PostCard_screen> createState() => _PostCard_screenState();
}

class _PostCard_screenState extends State<PostCard_screen> {
  late List<dynamic> lists_likes;
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

  void addToFavorites() async {
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.documentSnapshot.id);
    if (widget.documentSnapshot["liked_users"].contains(currentUserID)) {
      documentRef.update({
        'liked_users': FieldValue.arrayRemove([currentUserID])
      });
      setState(() {
        widget.documentSnapshot["liked_users"].remove(currentUserID);
      });
    } else {
      documentRef.update({
        'liked_users': FieldValue.arrayUnion([currentUserID])
      });
      setState(() {
        widget.documentSnapshot["liked_users"].add(currentUserID);
      });
    }
  }

  void goToPageInfo(final providerPost) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PostInfo(),
    ));

    providerPost.setId(widget.documentSnapshot.id);
    providerPost.setName(widget.documentSnapshot['name']);
    providerPost.setDescription(widget.documentSnapshot['description']);
    providerPost.setLikedUsers(widget.documentSnapshot['liked_users']);
    providerPost.setImage(widget.documentSnapshot['image']);
    providerPost.setRatings(widget.documentSnapshot['rating']);
    providerPost.setComments(widget.documentSnapshot['comments']);
  }

  Widget build(BuildContext context) {
    final providerPost = Provider.of<PostProvider>(context);
    return GestureDetector(
      onTap: () => goToPageInfo(providerPost),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: widget.isVertical
              ? EdgeInsets.only(right: 20, top: 10)
              : EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width *
              (widget.isVertical ? 0.5 : 0.8),
          height: MediaQuery.of(context).size.width *
              (widget.isVertical ? 0.65 : 0.9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            image: DecorationImage(
              image: NetworkImage(
                widget.documentSnapshot['image'],
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
                    onTap: () => addToFavorites(),
                    child: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Icon(
                            widget.documentSnapshot["liked_users"]
                                    .contains(currentUserID)
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
                          (widget.rating).toStringAsFixed(1),
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
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      widget.showName
                          ? widget.documentSnapshot['name']
                          : (widget.isVertical
                              ? widget.documentSnapshot['name']
                              : widget.documentSnapshot['description']),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
