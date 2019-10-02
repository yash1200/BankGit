import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: darkColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: darkColor,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Text(
            provider.getUser.name,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
          ListTile(
            title: Text('Number of branches'),
            trailing: Text(provider.getUser.branches.toString()),
          ),
          ListTile(
            title: Text('Balance'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(FontAwesomeIcons.rupeeSign),
                Text(provider.getUser.balance.toString()),
              ],
            ),
          ),
          ListTile(
            title: Text('Unadded Money'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(FontAwesomeIcons.rupeeSign),
                Text(provider.getUser.addAmount.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
