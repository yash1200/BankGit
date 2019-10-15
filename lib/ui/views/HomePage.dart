import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Drawer/CustomDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setUser(context);
  }

  setUser(BuildContext context) async {
    final provider = Provider.of<AppProvider>(context);
    provider.setUser(await getUserDetails());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Bank Git',
            style: TextStyle(
              color: darkColor,
            ),
          ),
          iconTheme: IconThemeData(
            color: darkColor,
          ),
        ),
        drawer: Drawer(
          elevation: 2,
          child: CustomDrawer(),
        ),
      ),
    );
  }
}
