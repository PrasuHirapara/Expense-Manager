import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pie_chart/pie_chart.dart';

class Analysis extends StatefulWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {

  int credited = 0;
  int debited = 0;

  // var arr = {'Other','Deposit','Withdraw','Bank','Business','Food','Grocery','Hotel','Stationary','Collage','Festivals'};

  Map<String, dynamic> updateCreditItem = {
    'Other': 0,
    'Deposit': 0,
    'Withdraw': 0,
    'Investment': 0,
    'Bank': 0,
    'Business': 0,
    'Food': 0,
    'Grocery': 0,
    'Hotel': 0,
    'Stationary': 0,
    'Collage': 0,
    'Festivals': 0,
  };
  Map<String, dynamic> updateDebitItem = {
    'Other': 0,
    'Deposit': 0,
    'Withdraw': 0,
    'Investment': 0,
    'Bank': 0,
    'Business': 0,
    'Food': 0,
    'Grocery': 0,
    'Hotel': 0,
    'Stationary': 0,
    'Collage': 0,
    'Festivals': 0,
  };

  final List<Color> colorList = [
    Colors.lightBlue ,
    Colors.red,
    Colors.grey,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.brown,
    Colors.indigo,
    Colors.pink,
    Colors.purple
  ];

  // @override
  // void initState(){
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {

    getMap();

    final Map<String, double> credit = updateCreditItem.map(
          (key, value) => MapEntry(key, value.toDouble()),
    );
    final Map<String, double> debit = updateDebitItem.map(
          (key, value) => MapEntry(key, value.toDouble()),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  child: Container(
                    color: Colors.black,
                    child: PieChart(
                      dataMap: credit,
                      animationDuration: const Duration(milliseconds: 1000),
                      chartLegendSpacing: 48.0,
                      chartRadius: MediaQuery.of(context).size.width / 2.7,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32.0,
                      centerText: "Credited",
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: true,
                      ),
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendTextStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    color: Colors.black,
                    child: PieChart(
                      dataMap: debit,
                      animationDuration: const Duration(milliseconds: 1000),
                      chartLegendSpacing: 48.0,
                      chartRadius: MediaQuery.of(context).size.width / 2.7,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32.0,
                      centerText: "Debited",
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: true,
                      ),
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendTextStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getMap() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
    await firestore.collection('credit_analysis').doc(FirebaseAuth.instance.currentUser!.uid).get();

    DocumentSnapshot documentSnapshot0 =
    await firestore.collection('debit_analysis').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        updateCreditItem = map;
      });
    }
    if(documentSnapshot0.exists){
      Map<String, dynamic> map2 = documentSnapshot0.data() as Map<String, dynamic>;

      setState(() {
        updateDebitItem = map2;
      });
    }

    else {
      return;
    }
  }
}
