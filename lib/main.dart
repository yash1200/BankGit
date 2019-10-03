import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/ui/views/HomePage.dart';
import 'package:bank_management/ui/Login/Login.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/LoginProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(
          builder: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider<AppProvider>(
          builder: (_) => AppProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Bank Management',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          primaryColor: darkColor,
        ),
        home: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return HomePage();
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}
