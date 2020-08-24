import 'package:bank_management/FirebaseFunctions/FirebaseFun.dart';
import 'package:bank_management/provider/AppProvider.dart';
import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';
import '../Drawer/CustomDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, double> dataMap = Map();
  var textStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: darkColor,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setMap();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setUser(context);
  }

  void setMap() {
    getBalanceMap().then((value) {
      setState(() {
        dataMap = value;
      });
    });
  }

  setUser(BuildContext context) async {
    final provider = Provider.of<AppProvider>(context);
    provider.setUser(await getUserDetails());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Container(
      color: darkColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Bank Git',
              style: TextStyle(
                color: darkColor,
              ),
            ),
            iconTheme: IconThemeData(
              color: darkColor,
            ),
          ),
          drawer: Drawer(
            elevation: 2,
            child: CustomDrawer(),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Chart Pictorial',
                    style: textStyle,
                  ),
                ),
//                FutureBuilder(
//                  future: getBalanceMap(),
//                  builder: (context, snapshot) {
//                    if (snapshot.hasData) {
//                      print(snapshot.data);
//                      return PieChart(
//                        dataMap: snapshot.data,
//                        legendStyle: TextStyle(
//                          fontSize: 16,
//                          fontWeight: FontWeight.w400,
//                          color: darkColor
//                        ),
//                        chartRadius: size.width / 2.3,
//                        colorList: [darkColor],
//                      );
//                    } else {
//                      return Center(
//                        child: CircularProgressIndicator(),
//                      );
//                    }
//                  },
//                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
