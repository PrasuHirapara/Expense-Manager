import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Constants/AppColors.dart';

class Analysis extends StatefulWidget {
  const Analysis({Key? key}) : super(key: key);

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {

  Map<String, int> updateCreditItem = {
    'Other': 0,
    'Deposit': 0,
    'Withdraw': 0,
    'Bank': 0,
    'Business': 0,
    'Food': 0,
    'Grocery': 0,
    'Hotel': 0,
    'Stationary': 0,
    'Collage': 0,
    'Festivals': 0,
  };
  Map<String, int> updateDebitItem = {
    'Other': 0,
    'Deposit': 0,
    'Withdraw': 0,
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

  @override
  Widget build(BuildContext context) {

    getMap();

    return Scaffold(
      backgroundColor: appPrimary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          ],
        ),
      ),
    );
  }

  void getMap() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
    await firestore.collection('credit_analysis').doc(FirebaseAuth.instance.currentUser!.uid).get();

    DocumentSnapshot documentSnapshot0 =
    await firestore.collection('credit_analysis').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (documentSnapshot.exists) {
      Map<String, int> map = documentSnapshot.data() as Map<String, int>;
      setState(() {
        updateCreditItem = map;
      });
    }else if(documentSnapshot0.exists){
      Map<String, int> map2 = documentSnapshot0.data() as Map<String, int>;
      setState(() {
        updateDebitItem = map2;
      });
    } else {
      return;
    }
  }
}
