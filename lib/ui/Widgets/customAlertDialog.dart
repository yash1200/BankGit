import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';

class customAlertDialog extends StatefulWidget {
  String branch;
  int money;

  customAlertDialog({this.branch, this.money});

  @override
  _customAlertDialogState createState() => _customAlertDialogState();
}

class _customAlertDialogState extends State<customAlertDialog> {
  TextEditingController amountController = TextEditingController();
  var _fkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
            FlatButton(
              onPressed: () {
                if (_fkey.currentState.validate()) {
                  addMoney(
                    widget.branch,
                    int.parse(amountController.text),
                    'Money Added',
                  );
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
                'Add',
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
