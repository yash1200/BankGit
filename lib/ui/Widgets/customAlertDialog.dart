import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAlertDialogMaster extends StatefulWidget {
  final String? branch;
  final int? money;

  CustomAlertDialogMaster({this.branch, this.money});

  @override
  _CustomAlertDialogMasterState createState() =>
      _CustomAlertDialogMasterState();
}

class _CustomAlertDialogMasterState extends State<CustomAlertDialogMaster> {
  TextEditingController amountController = TextEditingController();
  var _fkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);
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
                if (value!.isEmpty) {
                  return 'Amount can\'t be empty';
                } else if (int.parse(value) == 0) {
                  return 'Amount can\'t be zero';
                } else if (double.parse(value) > widget.money! &&
                    provider.paymentMode == 1) {
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
            FlatButton(
              onPressed: () {
                print(provider.paymentMode);
                if (_fkey.currentState!.validate()) {
                  addMoney(
                    widget.branch!,
                    int.parse(amountController.text),
                    'Money Added',
                  );
                  updateBalanceInUser(amountController.text);
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
