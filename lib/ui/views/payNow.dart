import 'package:bank_management/ui/Widgets/imageWidget.dart';
import 'package:bank_management/ui/Widgets/paymentSheet.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class payNow extends StatefulWidget {
  final DocumentSnapshot snapshot;

  payNow(this.snapshot);

  @override
  _payNowState createState() => _payNowState();
}

class _payNowState extends State<payNow> {
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var _fkey = GlobalKey<FormState>();

  showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: sheetBorder,
      builder: (context) {
        return paymentSheet(
          amount: amountController.text,
          phone: phoneController.text,
          description: descriptionController.text,
          branch: widget.snapshot.id,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
      body: Center(
        child: Form(
          key: _fkey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height / 40,
                ),
                CustomImage('assets/payment.png'),
                SizedBox(
                  height: size.height / 40,
                ),
                Text(
                  'From: ${widget.snapshot.documentID}',
                  style: TextStyle(
                    color: darkColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: size.height / 40,
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
                    border: outlineInputBorder,
                  ),
                ),
                SizedBox(
                  height: size.height / 40,
                ),
                TextFormField(
                  controller: amountController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Amount can\'t be empty';
                    } else if (double.parse(value) >
                        widget.snapshot.data()['balance']) {
                      return 'Amount is large';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    alignLabelWithHint: true,
                    border: outlineInputBorder,
                  ),
                ),
                SizedBox(
                  height: size.height / 40,
                ),
                TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Payment Description Needed';
                    } else if (value.length > 15) {
                      return 'Payment Description Large';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    border: outlineInputBorder,
                  ),
                ),
                SizedBox(
                  height: size.height / 40,
                ),
                FlatButton(
                  onPressed: () {
                    if (_fkey.currentState.validate()) {
                      showSheet(context);
                    }
                  },
                  color: Colors.white,
                  shape: roundedRectangleBorder,
                  child: Text('Pay Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
