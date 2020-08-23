import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/ui/views/HomePage.dart';
import 'package:bank_management/ui/Login/Login.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/LoginProvider.dart';
import 'ui/Login/Login.dart';
import 'ui/views/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider<AppProvider>(
          create: (_) => AppProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Bank Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: darkColor,
        ),
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return FirebaseAuth.instance.currentUser == null
                  ? Login()
                  : HomePage();
            } else {
              return Center(
                child: Text("Connect to the Internet!"),
              );
            }
          },
        ),
      ),
    );
  }
}
