import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/provider/AppProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionTo extends StatefulWidget {
  @override
  _TransactionToState createState() => _TransactionToState();
}

class _TransactionToState extends State<TransactionTo> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return FutureBuilder(
      future: getBranches(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: (snapshot.data! as List).length,
            itemBuilder: (context, index) {
              if ((snapshot.data! as List)[index].documentID != 'master') {
                return RadioListTile(
                  value: index,
                  groupValue: provider.transactionToIndex,
                  onChanged: (index) {
                    provider.setTransactionToIndex(index);
                    provider.setTransactionTo(
                        (snapshot.data! as List)[index as int].documentID);
                    Navigator.pop(context);
                  },
                  title: Text(
                    (snapshot.data! as List)[index].documentID,
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
