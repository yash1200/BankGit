import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/ui/Widgets/customBottomSheet.dart';
import 'package:bank_management/ui/Widgets/transactionList.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class branchDetails extends StatefulWidget {
  DocumentSnapshot snapshot;

  branchDetails({this.snapshot});

  @override
  _branchDetailsState createState() => _branchDetailsState();
}

class _branchDetailsState extends State<branchDetails>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var pageController = PageController(
    initialPage: 0,
  );
  var tabName = ['All', 'Recieved', 'Done'];
  var typeOfTransaction = [1, 1, 2];

  showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return customBottomSheet();
      },
    );
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
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 10, right: 10),
        children: <Widget>[
          SizedBox(
            height: size.height / 40,
          ),
          Container(
            height: size.height / 5,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: darkColor,
              borderRadius: BorderRadius.circular(10),
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
                    Text(
                      widget.snapshot['balance'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Available Balance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height / 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: FlatButton(
              onPressed: () {
                showSheet(context);
              },
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: darkColor,
                  width: 1,
                ),
              ),
              child: Text(
                'Pay Now',
                style: TextStyle(
                  color: darkColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 40,
          ),
          Text(
            'Recent Transactions',
            style: defaultTextStyleLarge,
          ),
          SizedBox(
            height: size.height / 40,
          ),
          Row(
            children: List<Widget>.generate(
              3,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: () {
                      provider.setTransactionIndex(index);
                      pageController.jumpToPage(provider.transactionIndex);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: index == provider.transactionIndex
                            ? darkColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          width: 1,
                          color: darkColor,
                        ),
                      ),
                      child: Text(
                        tabName[index],
                        style: TextStyle(
                          color: index == provider.transactionIndex
                              ? Colors.white
                              : darkColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.width / 2,
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.width,
            ),
            child: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              onPageChanged: (index) {
                provider.setTransactionIndex(index);
              },
              itemBuilder: (context, index) {
                return transactionPage(
                  widget.snapshot.documentID,
                  typeOfTransaction[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
