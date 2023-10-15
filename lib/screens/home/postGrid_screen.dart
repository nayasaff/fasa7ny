import 'package:flutter/material.dart';
import 'package:fasa7ny/screens/home/postCard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:fasa7ny/providers/homeProvider.dart';

class PostGrid_screen extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final double height;
  PostGrid_screen({required this.snapshot, required this.height});

  @override
  State<PostGrid_screen> createState() => _PostGrid_screenState();
}

class _PostGrid_screenState extends State<PostGrid_screen> {
  bool isSubarray(List<dynamic> array1, List<dynamic> array2) {
    //array 1 is subarray of array2
    if (array1.length > array2.length) {
      return false; // Array 1 is longer, cannot be a subarray
    }

    if (array1.length == 0) {
      return true;
    }

    int currentIndex = 0;
    for (int i = 0; i < array2.length; i++) {
      if (array2[i] == array1[currentIndex]) {
        currentIndex++;

        if (currentIndex == array1.length) {
          print(currentIndex == array1.length);
          return true; // Found all elements of Array 1 consecutively
        }
      }
    }

    return false; // Array 1 is not a subarray of Array 2
  }

  Widget build(BuildContext context) {
    final myProvider = Provider.of<HomeProvider>(context);
    List<String> categories = myProvider.getActiveChips();

    return Container(
      height: widget.height,
      width: double.maxFinite,
      child: Center(
        child: ListView.builder(
          itemCount: widget.snapshot.data!.docs.length,
          scrollDirection:
              widget.height == 300 ? Axis.horizontal : Axis.vertical,
          itemBuilder: (context, index) {
            final DocumentSnapshot documentSnapshot =
                widget.snapshot.data!.docs[index];

            double avgRating = 0;
            for (num i = 0; i < documentSnapshot['rating'].length; i++) {
              avgRating += documentSnapshot['rating'][i]['number'];
            }
            // if (isFavoriteList.length <= index) {
            //   isFavoriteList.add(false);
            // }
            double rating = documentSnapshot['rating'].length != 0
                ? avgRating / documentSnapshot['rating'].length
                : avgRating;
            return Container(
              child: widget.height == 300
                  ? Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          PostCard_screen(
                            isVertical: true,
                            rating: rating,
                            documentSnapshot: documentSnapshot,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        isSubarray(categories, documentSnapshot['category'])
                            ? PostCard_screen(
                                isVertical: false,
                                rating: rating,
                                documentSnapshot: documentSnapshot,
                              )
                            : Container(),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
