import 'package:fasa7ny/providers/postProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:fasa7ny/providers/idProvider.dart';

//ignore: must_be_immutable
class Reviews extends StatefulWidget {
  bool showTextBox;

  Reviews({required this.showTextBox});
  @override
  State<Reviews> createState() => _Reviews();
}

class _Reviews extends State<Reviews> {
  void initState() {
    super.initState();
  }

  Future<String> getUsername(dynamic userRef) async {
    try {
      final DocumentReference _posts =
          FirebaseFirestore.instance.collection('users').doc(userRef);
      DocumentSnapshot snapshot = await _posts.get();
      return snapshot['username'];
    } catch (err) {
      print(err);
      return err.toString();
    }
  }

  addReview(dynamic comment, String id, Function addComment) async {
    setState(() {
      widget.showTextBox = false;
    });

    final DocumentReference _posts =
        FirebaseFirestore.instance.collection('posts').doc(id);
    DocumentSnapshot snapshot = await _posts.get();
    List<dynamic> myList = snapshot['comments'];

    List<dynamic> updatedList = [...myList, comment];
    _posts.update({'comments': updatedList});
    addComment(comment);
  }

  void showTextBox(dynamic id) {
    if (id == null) {
      return;
    }
    setState(() {
      widget.showTextBox = true;
    });
  }

  TextEditingController _textEditingController = TextEditingController();
  Widget build(BuildContext context) {
    final providerId = Provider.of<IdProvider>(context);
    final providerPost = Provider.of<PostProvider>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "Reviews",
            style: TextStyle(letterSpacing: 1),
          ),
          IconButton(
              onPressed: () => showTextBox(providerId.userId),
              icon: Icon(
                Icons.add,
                color: Colors.white70,
              ))
        ]),
        SizedBox(
          height: 50 * providerPost.getComments().length.toDouble(),
          child: ListView.builder(
              itemCount: providerPost.getComments().length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future:
                        getUsername(providerPost.getComments()[index]['user']),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: ProfilePicture(
                                name: snapshot.data!,
                                radius: 23,
                                fontsize: 21,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(snapshot.data!,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white70))),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: Text(
                                        providerPost.getComments()[index]
                                            ['text'],
                                        style: TextStyle(letterSpacing: 1),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
              }),
        ),
        widget.showTextBox
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  autofocus: true,
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    fillColor: Colors.white70,
                    hintStyle: TextStyle(color: Colors.white70),
                    suffixIcon: IconButton(
                      onPressed: () => addReview({
                        "text": _textEditingController.text,
                        "user": providerId.userId
                      }, providerPost.getId(), providerPost.addComment),
                      icon: Icon(
                        Icons.send,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ))
            : Container(),
      ],
    );
  }
}
