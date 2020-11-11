import 'package:bank_management/model/user.dart';
import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/ui/Widgets/customLogOutDialog.dart';
import 'package:bank_management/ui/views/CreateBranch.dart';
import 'package:bank_management/ui/views/UserProfile.dart';
import 'package:bank_management/ui/views/help.dart';
import 'package:bank_management/ui/views/transfer.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/Branches.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  MyUser user;

  _showSignOutDialog(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return LogOutDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    var size = MediaQuery.of(context).size;
    user = provider.getUser;
    if (user != null) {
      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserProfile();
                  },
                ),
              );
            },
            child: UserAccountsDrawerHeader(
              accountName: Text(user.name),
              accountEmail: Text(user.email),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlueAccent,
                ),
                alignment: Alignment.center,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: defaultTextStyle,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Create New Branch',
              style: defaultTextStyle,
            ),
            leading: Image.asset(
              'assets/rupees.png',
              height: size.height / 22,
              width: size.height / 22,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CreateBranch();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Branches',
              style: defaultTextStyle,
            ),
            leading: Image.asset(
              'assets/circuit.png',
              height: size.height / 22,
              width: size.height / 22,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Branches();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Transfer',
              style: defaultTextStyle,
            ),
            leading: Image.asset(
              'assets/transfer.png',
              height: size.height / 22,
              width: size.height / 22,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Transfer();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Help',
              style: defaultTextStyle,
            ),
            leading: Image.asset(
              'assets/question.png',
              height: size.height / 22,
              width: size.height / 22,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Help();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Log Out',
              style: defaultTextStyle,
            ),
            leading: Image.asset(
              'assets/exit.png',
              height: size.height / 22,
              width: size.height / 22,
            ),
            onTap: () {
              _showSignOutDialog(context);
            },
          ),
        ],
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
