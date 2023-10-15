import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:fasa7ny/providers/postProvider.dart';

// ignore: must_be_immutable
class Rating extends StatefulWidget {
  Rating();

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  var userrating = 0.0;

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
    List ratings =
        Provider.of<PostProvider>(context, listen: false).getRatings();
    for (int i = 0; i < ratings.length; i++) {
      if (ratings[i]['user'] == userID) {
        setState(() {
          tcVisibility = true;
          userrating = ratings[i]['number'];
        });
        return;
      }
      print(ratings[i]['user']);
    }

    setState(() {
      tcVisibility = false;
    });
  }

  bool? tcVisibility;

  void getRating() {
    setState(() {
      tcVisibility = false;
    });
  }

  Future<void> addRatings(double rating, String id, List<dynamic> ratings,
      Function setRating) async {
    setState(() {
      if (userrating == rating) {
        userrating = 0;
        tcVisibility = false;
      } else {
        userrating = rating;
        tcVisibility = true;
      }
    });

    DocumentReference documentRef =
        FirebaseFirestore.instance.collection("posts").doc(id);
    DocumentSnapshot snapshot = await documentRef.get();
    List<dynamic> myList = snapshot['rating'];
    bool ratingExists = false;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i]['user'] == currentUserID) {
        if (myList[i]['number'] == rating) {
          myList.removeAt(i);
        } else {
          myList[i]['number'] = rating;
        }
        ratingExists = true;
      }
    }

    List<dynamic> updatedList = [
      ...myList,
      {"user": currentUserID, "number": rating}
    ];

    if (ratingExists) {
      documentRef.update({'rating': myList});
      setRating(myList);
    } else {
      documentRef.update({'rating': updatedList});
      setRating(updatedList);
    }
  }

  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: true);
    return Column(children: [
      RatingBar.builder(
        initialRating: userrating,
        minRating: 0,
        allowHalfRating: false,
        itemCount: 10,
        itemSize: 30,
        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) => addRatings(rating, postProvider.getId(),
            postProvider.getRatings(), postProvider.setRatings),
      ),
      SizedBox(
        height: 5,
      ),
      Visibility(
          visible: tcVisibility ?? true,
          child: SizedBox(
            height: 20,
            child: Text(
                "Thank you for your rating, you gave it a ${userrating.toInt()}/10"),
          ))
    ]);
  }
}
