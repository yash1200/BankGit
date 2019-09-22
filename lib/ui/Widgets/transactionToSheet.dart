import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/provider/AppProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class transactionTo extends StatefulWidget {
  @override
  _transactionToState createState() => _transactionToState();
}

class _transactionToState extends State<transactionTo> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return FutureBuilder(
      future: getBranches(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              if (snapshot.data[index].documentID != 'master' &&
                  snapshot.data[index].documentID != provider.transactionFrom) {
                return RadioListTile(
                  value: index,
                  groupValue: provider.transactionToIndex,
                  onChanged: (index) {
                    provider.setTransactionToIndex(index);
                    provider.setTransactionTo(snapshot.data[index].documentID);
                    Navigator.pop(context);
                  },
                  title: Text(
                    snapshot.data[index].documentID,
                    style: TextStyle(
                      fontWeight: index == provider.transactionToIndex
                          ? FontWeight.w400
                          : FontWeight.w300,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
