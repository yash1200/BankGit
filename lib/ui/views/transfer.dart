import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/ui/Widgets/imageWidget.dart';
import 'package:bank_management/ui/Widgets/transactionFromSheet.dart';
import 'package:bank_management/ui/Widgets/transactionToSheet.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Transfer extends StatefulWidget {
  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var _fkey = GlobalKey<FormState>();
  Duration _duration = Duration(milliseconds: 1500);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  showTransactionFrom(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: sheetBorder,
      builder: (context) {
        return TransactionFrom();
      },
    );
  }

  showTransactionTo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: sheetBorder,
      builder: (context) {
        return TransactionTo();
      },
    );
  }

  void _showSnackBarLocal(String text, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: _duration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
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
          'Transfer',
          style: TextStyle(
            color: darkColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.replay_outlined,
              color: darkColor,
            ),
            onPressed: () {
              provider.setTransactionTo("Not Selected");
              provider.setTransactionToIndex(0);
              provider.setTransactionFrom("Not Selected");
              provider.setTransactionFromIndex(0);
            },
          ),
        ],
      ),
      body: Form(
        key: _fkey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: size.height / 40,
            ),
            CustomImage('assets/money.png'),
            SizedBox(
              height: size.height / 40,
            ),
            Text(
              'Transfer your money from one branch to other branch',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkColor,
                fontSize: 25,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: size.height / 40,
            ),
            Text(
              'From',
              style: TextStyle(
                color: darkColor,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: size.height / 60,
            ),
            GestureDetector(
              onTap: () {
                showTransactionFrom(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    provider.transactionFrom,
                    style: TextStyle(
                      color: darkColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 60,
            ),
            Text(
              'To',
              style: TextStyle(
                color: darkColor,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: size.height / 80,
            ),
            GestureDetector(
              onTap: () {
                showTransactionTo(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    provider.transactionTo,
                    style: TextStyle(
                      color: darkColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 40,
            ),
            TextFormField(
              controller: amountController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Some amount';
                } else if (int.parse(value) > provider.transactionFromBalance) {
                  print(provider.transactionFromBalance);
                  return 'Amount is large';
                }
                return null;
              },
              onTap: () {
                _fkey.currentState.reset();
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount*',
                alignLabelWithHint: true,
                border: outlineInputBorder,
              ),
            ),
            SizedBox(
              height: size.height / 80,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: outlineInputBorder,
              ),
            ),
            SizedBox(
              height: size.height / 80,
            ),
            FlatButton(
              onPressed: () {
                if (_fkey.currentState.validate() &&
                    provider.transactionFrom != provider.transactionTo &&
                    provider.transactionFrom != 'Not Selected' &&
                    provider.transactionTo != 'Not Selected') {
                  addMoney(
                    provider.transactionTo,
                    int.parse(amountController.text),
                    'From ${provider.transactionFrom}',
                  );
                  debitMoney(
                    provider.transactionFrom,
                    int.parse(amountController.text),
                    'To ${provider.transactionTo}',
                  );
                  Navigator.pop(context);
                } else {
                  if (provider.transactionTo == provider.transactionFrom &&
                      provider.transactionTo != 'Not Selected') {
                    _showSnackBarLocal(
                      "Transaction from and to fields are same",
                      context,
                    );
                  } else if (provider.transactionTo == 'Not Selected') {
                    _showSnackBarLocal(
                      "Transaction to field is not selected",
                      context,
                    );
                  } else if (provider.transactionFrom == 'Not Selected') {
                    _showSnackBarLocal(
                      "Transaction from field is not selected",
                      context,
                    );
                  }
                }
              },
              shape: roundedRectangleBorder,
              child: Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }
}
