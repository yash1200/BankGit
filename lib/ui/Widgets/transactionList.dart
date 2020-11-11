import 'package:flutter/material.dart';
import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  final String branch;
  final int type;

  TransactionPage(this.branch, this.type);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTransactionList(widget.branch, widget.type),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if ((snapshot.data! as List).length == 0) {
            return Center(
              child: Text('No Transactions done'),
            );
          } else {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: (snapshot.data! as List).length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    (snapshot.data! as List)[index].data()['desc'],
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'Balance: ${(snapshot.data! as List)[index].data()['balance'].toString()}'
                    '(${(snapshot.data! as List)[index].data()['type'] == 1 ? '+' : '-'}'
                    '${(snapshot.data! as List)[index].data()['amount'].toString()})',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        (snapshot.data! as List)[index]
                            .data()['amount']
                            .toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color:
                              (snapshot.data! as List)[index].data()['type'] ==
                                      1
                                  ? Colors.green
                                  : Colors.redAccent,
                        ),
                      ),
                      Text(
                        DateFormat.MMMd()
                            .format(
                              DateTime.fromMillisecondsSinceEpoch(
                                (snapshot.data! as List)[index].data()['time'],
                              ),
                            )
                            .toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
