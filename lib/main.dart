import 'package:fasa7ny/providers/homeProvider.dart';
import 'package:fasa7ny/providers/postProvider.dart';
import 'package:fasa7ny/screens/profile.dart';
import 'package:fasa7ny/providers/idProvider.dart';
import 'package:fasa7ny/screens/users/signin_screen.dart';
import 'package:fasa7ny/screens/users/signup_screen.dart';
import 'package:fasa7ny/screens/tabsControllerScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyBBtbqkNpJqCRDOuZo20iwNUhs-krhpYq0", // Your apiKey
    appId: "1:906431667902:android:24dc1179d38bf8767d08ef", // Your appId
    messagingSenderId: "906431667902", // Your messagingSenderId
    projectId: "fasa7ny-61e40",
  ));
  //
  runApp(const MyApp());
  void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.subscribeToTopic("classChat");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => IdProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PostProvider(),
        ),
        ChangeNotifierProvider(create: (ctx) => HomeProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryTextTheme: Typography().white,
          textTheme: Typography().white,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctxDummy) => SignInScreen(),
          '/signup': (context) => SignUpScreen(),
          '/homePage': (ctxDummy) => TabsControllerScreen(),
          '/profile': (dummyCtx) => Profile(),
        },
      ),
    );
  }
}
