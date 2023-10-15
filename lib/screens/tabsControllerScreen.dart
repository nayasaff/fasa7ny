import 'package:fasa7ny/providers/idProvider.dart';
import 'package:fasa7ny/screens/postScreen.dart';
import 'package:fasa7ny/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorite.dart';
import 'home/home_Screen.dart';
import 'profile.dart';

class TabsControllerScreen extends StatefulWidget {
  @override
  _TabsControllerScreenState createState() => _TabsControllerScreenState();
}

class _TabsControllerScreenState extends State<TabsControllerScreen> {
  final List<Widget> myPages = [
    HomeScreen(),
    FavoriteScreen(),
    PostScreen(),
    Profile()
  ];
  var selectedTabIndex = 0;
  bool isDarkMode = false;
  void switchPage(String? userId, int index) {
    print(userId);
    setState(() {
      selectedTabIndex = index;
    });
    // if (userId == null) {
    //   showDialog(
    //       context: context, builder: (BuildContext context) => SignInPop());
    // } else {
    //   setState(() {
    //     selectedTabIndex = index;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final provierId = Provider.of<IdProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDarkMode ? Colors.grey[900] : hexStringToColor("E59400"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                },
                icon:
                    Icon(isDarkMode ? Icons.brightness_7 : Icons.brightness_4))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0.0,
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.red,
          selectedItemColor: isDarkMode ? Colors.black : Colors.red,
          unselectedItemColor: isDarkMode ? Colors.grey : Colors.grey[600],
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'Add Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: selectedTabIndex,
          onTap: (index) => switchPage(provierId.userId, index),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor:
            isDarkMode ? Colors.grey[900] : hexStringToColor("E59400"),
        body: Theme(
            data: ThemeData(
                brightness: isDarkMode ? Brightness.dark : Brightness.light),
            child: myPages[selectedTabIndex]));
  }
}
