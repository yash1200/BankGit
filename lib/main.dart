import 'package:bank_management/ui/HomePage.dart';
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
    return ChangeNotifierProvider<LoginProvider>(
      builder: (_) => LoginProvider(),
      child: MaterialApp(
        title: 'Bank Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: darkColor,
        ),
        home: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
            if (snapshot.data!=null) {
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
