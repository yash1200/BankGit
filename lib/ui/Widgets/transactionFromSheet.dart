import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/provider/AppProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionFrom extends StatefulWidget {
  @override
  _TransactionFromState createState() => _TransactionFromState();
}

class _TransactionFromState extends State<TransactionFrom> {
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
              if (snapshot.data[index].documentID != 'master') {
                return RadioListTile(
                  value: index,
                  groupValue: provider.transactionFromIndex,
                  onChanged: (index) async {
                    provider.setTransactionFromIndex(index);
                    provider
                        .setTransactionFrom(snapshot.data[index].documentID);
                    provider.setTransactionFromBalance(
                      await getBranchBalance(snapshot.data[index].documentID),
                    );
                    Navigator.pop(context);
                  },
                  title: Text(
                    snapshot.data[index].documentID,
                    style: TextStyle(
                      fontWeight: index == provider.transactionFromIndex
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
