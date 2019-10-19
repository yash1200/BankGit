import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/ui/Widgets/customAlertDialogBranch.dart';
import 'package:bank_management/ui/Widgets/customAlertDialog.dart';
import 'package:bank_management/ui/views/payNow.dart';
import 'package:bank_management/ui/Widgets/customFilterSheet.dart';
import 'package:bank_management/ui/Widgets/transactionList.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class branchDetails extends StatefulWidget {
  DocumentSnapshot snapshot;
  Gradient gradientContainer;

  branchDetails({this.snapshot, this.gradientContainer});

  @override
  _branchDetailsState createState() => _branchDetailsState();
}

class _branchDetailsState extends State<branchDetails>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var choices = ['Delete Branch'];

  showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: sheetBorder,
      builder: (context) {
        return customFilterSheet();
      },
    );
  }

  showAddSheet(BuildContext context) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Getting data'),
        duration: Duration(seconds: 1),
      ),
    );
    getAddAmount().then((value) {
      if (widget.snapshot.documentID == 'master') {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return customAlertDialogMaster(
              branch: widget.snapshot.documentID,
              money: value,
            );
          },
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return customAlertDialogBranch(
              branch: widget.snapshot.documentID,
              money: value,
            );
          },
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final provider = Provider.of<AppProvider>(context);
    return Scaffold(
      key: scaffoldKey,
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
          widget.snapshot.documentID,
          style: TextStyle(
            color: darkColor,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: darkColor,
            ),
            elevation: 2,
            onSelected: (value) {
              switch (value) {
                case 'Delete Branch':
                  deleteBranch(widget.snapshot.documentID);
                  Navigator.pop(context);
                  break;
                default:
                  print('Non selected');
              }
            },
            itemBuilder: (context) {
              return choices.map(
                    (String choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Text(choice),
                  );
                },
              ).toList();
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 10, right: 10),
        children: <Widget>[
          SizedBox(
            height: size.height / 40,
          ),
          Hero(
            tag: widget.snapshot.documentID,
            child: Container(
              height: size.height / 5,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: widget.gradientContainer,
              ),
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.rupeeSign,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      FutureBuilder(
                        future: getBranchBalance(widget.snapshot.documentID),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            );
                          } else {
                            return Text(
                              '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Balance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: size.height / 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return payNow(widget.snapshot);
                    },
                  ),
                );
              },
              color: Colors.white,
              shape: roundedRectangleBorder,
              child: Text(
                'Pay Now',
                style: TextStyle(
                  color: darkColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: FlatButton(
              onPressed: () {
                showAddSheet(context);
              },
              color: Colors.white,
              shape: roundedRectangleBorder,
              child: Text(
                'Update Money',
                style: TextStyle(
                  color: darkColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Recent',
                style: defaultTextStyleLarge,
              ),
              IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  showFilterSheet(context);
                },
              )
            ],
          ),
          SizedBox(
            height: size.height / 80,
          ),
          transactionPage(
            widget.snapshot.documentID,
            provider.transactionIndex,
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
