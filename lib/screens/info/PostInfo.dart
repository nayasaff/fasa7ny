import 'package:flutter/material.dart';
import 'rating.dart';
import 'reviews.dart';
import 'descriptions.dart';
import 'package:fasa7ny/providers/idProvider.dart';
import 'package:provider/provider.dart';
import 'package:fasa7ny/utils/colors_utils.dart';

class PostInfo extends StatefulWidget {
  const PostInfo();

  @override
  State<PostInfo> createState() => _PostInfo();
}

class _PostInfo extends State<PostInfo> {
  bool _showTextBox = false;
  Widget build(BuildContext context) {
    final providerId = Provider.of<IdProvider>(context);

    return Scaffold(
      appBar: AppBar(backgroundColor: hexStringToColor("E59400")),
      backgroundColor: hexStringToColor("E59400"),
      body: GestureDetector(
          onTap: () {
            setState(() {
              _showTextBox = false;
            });
          },
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 10, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Description(),
                      providerId.userId != ""
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Rating()],
                            )
                          : Container(),
                      SizedBox(
                        height: 7,
                      ),
                      Reviews(
                        showTextBox: _showTextBox,
                      )
                    ],
                  )))),
    );
  }
}
