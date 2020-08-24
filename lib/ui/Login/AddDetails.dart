import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/model/user.dart';
import 'package:bank_management/ui/Widgets/CustomPaint.dart';
import 'package:flutter/material.dart';

import '../../FirebaseFunctions/FirebaseFun.dart';
import '../views/HomePage.dart';
import 'loginWidget.dart';

class AddDetails extends StatefulWidget {
  final String phoneNumber;

  AddDetails(this.phoneNumber);

  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  var fkey = GlobalKey<FormState>();
  bool isLoading = false;
  String uid;
  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))'
      r'@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+'
      r'\.)+[a-zA-Z]{2,}))$';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  register(BuildContext context) {
    MyUser user = MyUser(
      nameController.text,
      uid,
      widget.phoneNumber,
      emailController.text,
      1,
      0,
      0,
    );
    registerUser(user);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = getUid();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: fkey,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Custompaint(),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: LoginWidget(
                    title: 'Add\nDetails',
                    subtitle: 'Trust-Us',
                    isLoading: isLoading,
                    textField: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                          ),
                          textCapitalization: TextCapitalization.words,
                          controller: nameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Name can\'be empty';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Your Email',
                            hintText: 'xyz@example.com',
                          ),
                          controller: emailController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email can\'be empty';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      if (fkey.currentState.validate()) {
                        register(context);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
