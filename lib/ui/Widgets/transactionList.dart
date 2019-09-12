import 'package:flutter/material.dart';
import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';

class transactionPage extends StatefulWidget {
  String branch;
  int type;

  transactionPage(this.branch, this.type);

  @override
  _transactionPageState createState() => _transactionPageState();
}

class _transactionPageState extends State<transactionPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTransactionList(widget.branch, widget.type),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data[index]['amount'].toString()),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
