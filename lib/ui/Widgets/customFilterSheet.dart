import 'package:bank_management/provider/AppProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class customFilterSheet extends StatefulWidget {
  @override
  _customFilterSheetState createState() => _customFilterSheetState();
}

class _customFilterSheetState extends State<customFilterSheet> {
  var titleType = ['All', 'Recieved', 'Done'];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    return ListView(
      shrinkWrap: true,
      children: List<Widget>.generate(
        3,
        (index) {
          return RadioListTile(
            value: index,
            groupValue: provider.transactionIndex,
            onChanged: (index) {
              provider.setTransactionIndex(index);
            },
            title: Text(
              titleType[index],
              style: TextStyle(
                fontWeight: index == provider.transactionIndex
                    ? FontWeight.w400
                    : FontWeight.w300,
              ),
            ),
          );
        },
      ),
    );
  }
}
