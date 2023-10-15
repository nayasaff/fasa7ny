import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fasa7ny/utils/colors_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController name = new TextEditingController();

  TextEditingController description = new TextEditingController();

  XFile? image;
  String dropdownValue = 'Activities';

  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
    print(image);
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: hexStringToColor("E59400"), // Background color

            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 250, 174, 120), // Background color
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text(' Gallery'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void uploadImage() async {
    var uuid = Uuid().v4();
    Reference storageReference =
        await FirebaseStorage.instance.ref().child('images/${uuid}');
    UploadTask uploadTask = storageReference.putFile(File(uuid));
    await uploadTask.whenComplete(() => print("Image Uploaded Succesfully"));
    String imageUrl = await storageReference.getDownloadURL();
    Map<String, dynamic> data = {
      "name": name.text,
      "description": description.text,
      "category": dropdownValue,
      "image": imageUrl,
      "rating": [],
      "comments": [],
      'liked_users': [],
    };

    await FirebaseFirestore.instance.collection('posts').add(data);
    Navigator.pushReplacementNamed(context, '/homePage');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            image == null
                ? SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: hexStringToColor("E59400")
                              .withOpacity(0.6), //background color of button
                          side: BorderSide(
                            width: 3,
                            color: Color.fromARGB(255, 180, 109, 58),
                          ), //border width and color
                          elevation: 10, //elevation of button
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(
                              20) //content padding inside button
                          ),
                      onPressed: () {
                        myAlert();
                      },
                      child: Text('+',
                          style: TextStyle(
                              fontSize: 70,
                              color: Colors.white.withOpacity(0.6))),
                    ))
                : Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        //to show image, you type like this.
                        File(image!.path),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                      ),
                    ),
                  ),
            TextField(
              //              keyboardType: TextInputType.
              //  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly]
              cursorColor: Colors.white,
              controller: name,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: description,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "Description",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              alignment: Alignment.bottomLeft,
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(12),

                dropdownColor: Color.fromARGB(253, 227, 191, 141),
                // Step 3.
                value: dropdownValue,
                // Step 4.
                items: <String>[
                  'Activities',
                  'Religious',
                  'Historical',
                  'Beaches',
                  'Cafes',
                  'Museums',
                  'Art Galleries'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                // Step 5.
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () => uploadImage(),
                child: Text('Upload'),
                style: ElevatedButton.styleFrom(
                  // primary: Color.fromARGB(255, 180, 109, 58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
