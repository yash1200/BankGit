import 'package:flutter/material.dart';
import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:intl/intl.dart';

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
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('No Transactions done'),
            );
          } else {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    snapshot.data[index].data()['desc'],
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'Balance: ${snapshot.data[index].data()['balance'].toString()}'
                        '(${snapshot.data[index].data()['type'] == 1 ? '+' : '-'}'
                        '${snapshot.data[index].data()['amount'].toString()})',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        snapshot.data[index].data()['amount'].toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: snapshot.data[index].data()['type'] == 1
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                      ),
                      Text(
                        DateFormat.MMMd()
                            .format(DateTime.fromMillisecondsSinceEpoch(
                            snapshot.data[index].data()['time']))
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
