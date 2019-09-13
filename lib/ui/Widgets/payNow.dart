import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class payNow extends StatefulWidget {
  DocumentSnapshot snapshot;

  payNow(this.snapshot);

  @override
  _payNowState createState() => _payNowState();
}

class _payNowState extends State<payNow> {
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var _fkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Pay',
          style: TextStyle(
            color: darkColor,
          ),
        ),
      ),
      body: Form(
        key: _fkey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 10, right: 10),
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Text(
              'From: ${widget.snapshot.documentID}',
              style: TextStyle(
                color: darkColor,
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
            TextFormField(
              controller: amountController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Amount can\'t be empty';
                } else if (double.parse(value) >
                    widget.snapshot.data['balance']) {
                  return 'Amount is large';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: darkColor,
                    width: 1,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: phoneController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Number can\'t be empty';
                } else if (value.length != 10) {
                  return 'Number is invalid';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: darkColor,
                    width: 1,
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                if (_fkey.currentState.validate()) {
                  makeUpiPayment(
                    amountController.text,
                    phoneController.text,
                  );
                }
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
