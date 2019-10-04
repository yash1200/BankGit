import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/ui/Widgets/imageWidget.dart';
import 'package:bank_management/ui/views/branchDetails.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Branches extends StatefulWidget {
  @override
  _BranchesState createState() => _BranchesState();
}

class _BranchesState extends State<Branches> {
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
          'Branches',
          style: TextStyle(
            color: darkColor,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getBranches(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: size.height / 40,
                    ),
                    CustomImage('assets/data.png'),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    Text(
                      'Your Branches',
                      style: TextStyle(
                        color: darkColor,
                        fontSize: size.height / 22,
                      ),
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    GridView.builder(
                      itemCount: snapshot.data.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return branchDetails(
                                    snapshot: snapshot.data[index],
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: size.width / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: grads[index],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/circuit.png',
                                  height: size.height / 10,
                                  width: size.height / 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data[index].documentID,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: SpinKitWave(
                color: darkColor,
                size: 25,
                type: SpinKitWaveType.center,
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
      ),
    );
  }
}
