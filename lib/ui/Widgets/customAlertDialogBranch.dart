import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class customAlertDialogBranch extends StatefulWidget {
  final String branch;
  final int money;

  customAlertDialogBranch({this.branch, this.money});

  @override
  _customAlertDialogBranchState createState() =>
      _customAlertDialogBranchState();
}

class _customAlertDialogBranchState extends State<customAlertDialogBranch> {
  TextEditingController amountController = TextEditingController();
  var _fkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return AlertDialog(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Form(
        key: _fkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 1,
                    color: darkColor,
                  ),
                ),
              ),
              validator: (value) {
                print("Mpney "+widget.money.toString());
                if (value.isEmpty) {
                  return 'Amount can\'t be empty';
                } else if (int.parse(value) == 0) {
                  return 'Amount can\'t be zero';
                } else if (double.parse(value) > widget.money) {
                  return 'Amount can\'t be greater than ${widget.money}';
                }
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    provider.setPaymentMode(0);
                  },
                  child: Container(
                    child: Text(
                      'Credit',
                      style: TextStyle(
                        color:
                            provider.paymentMode == 1 ? darkColor : Colors.blue,
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            provider.paymentMode == 1 ? darkColor : Colors.blue,
                        width: 1,
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    provider.setPaymentMode(1);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Text(
                      'Debit',
                      style: TextStyle(
                        color:
                            provider.paymentMode == 0 ? darkColor : Colors.blue,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            provider.paymentMode == 0 ? darkColor : Colors.blue,
                        width: 1,
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            FlatButton(
              onPressed: () {
                if (_fkey.currentState.validate()) {
                  if (provider.paymentMode == 0) {
                    addMoney(
                      widget.branch,
                      int.parse(amountController.text),
                      'Money Credited',
                    );
                  } else {
                    debitMoney(
                      widget.branch,
                      int.parse(amountController.text),
                      'Money Debited',
                    );
                  }
                  Navigator.pop(context);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  width: 1,
                  color: darkColor,
                ),
              ),
              child: Text(
                'Update',
                style: TextStyle(color: darkColor),
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
