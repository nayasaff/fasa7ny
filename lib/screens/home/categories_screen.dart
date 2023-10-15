import 'package:fasa7ny/providers/homeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categories_Screen extends StatefulWidget {
  @override
  State<Categories_Screen> createState() => _Categories_ScreenState();
}

class _Categories_ScreenState extends State<Categories_Screen> {
  List<String> strs = [
    "activities",
    "religious",
    "historical",
    "beaches",
    "cafes",
    'museums',
    'art galleries'
  ];

  Widget build(BuildContext context) {
    final myProvider = Provider.of<HomeProvider>(context);
    return Column(children: [
      const SizedBox(
        height: 30,
      ),
      Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            Text(
              'See all',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 10),
      Container(
        height: 60,
        width: double.maxFinite,
        margin: const EdgeInsets.only(left: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: strs
                  .map((category) => FilterChip(
                      selected: myProvider.getActiveChips().contains(category),
                      label: Text(category),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            myProvider.addItem(category);
                          } else {
                            myProvider.removeItem(category);
                          }
                        });
                      }))
                  .toList()),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Destinations',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            Text(
              'See all',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
    ]);
  }
}
