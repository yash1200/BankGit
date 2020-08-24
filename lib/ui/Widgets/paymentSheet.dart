import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_upi/flutter_upi.dart';

class paymentSheet extends StatefulWidget {
  String amount, phone, description, branch;

  paymentSheet({this.amount, this.phone, this.description, this.branch});

  @override
  _paymentSheetState createState() => _paymentSheetState();
}

class _paymentSheetState extends State<paymentSheet> {
  var imageName = [
    'assets/bhim.png',
    'assets/paytm.png',
    'assets/google-pay.png',
    'assets/amazon-pay.png',
  ];
  var upiVendor = [
    FlutterUpiApps.BHIMUPI,
    FlutterUpiApps.PayTM,
    FlutterUpiApps.GooglePay,
    FlutterUpiApps.AmazonPay,
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            4,
            (index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  makeUpiPayment(
                    widget.amount,
                    widget.phone,
                    upiVendor[index],
                    widget.description,
                    widget.branch,
                  );
                  Navigator.pop(context);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    imageName[index],
                    width: size.width / 7,
                    height: size.width / 7,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
