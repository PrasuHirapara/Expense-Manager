import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Constants/AppColors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool credit = true;
  bool debit = false;

  final String userUID = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController numberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int credited = 2;
  int debited = 0;

  late Map<String, dynamic> balance;

  @override
  void initState(){
    super.initState();
    getBalance();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: appPrimary,
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[800],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('${getCurrentDateTime() } ', style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text('credited :'.toUpperCase(), style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),),
                            Text('$credited', style: const TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),)
                          ],
                        ),

                        Column(
                          children: [
                            Text('debited'.toUpperCase(), style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),),
                            Text('${debited}', style: const TextStyle(fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),)
                          ],
                        )
                      ],
                    ),
                    Text('balance : ${credited - debited}'.toUpperCase(),
                      style: const TextStyle(fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20,),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('history')
                    .doc(userUID)
                    .collection(userUID)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<DocumentSnapshot> docs = snapshot.data!.docs;
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No transaction history',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: false,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[800],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(docs[index]['date'], style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                      ),

                                      const SizedBox(width: 10,),

                                      docs[index]['credited'] != 0
                                          ? Text('credited'.toUpperCase(), style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green),)
                                          :  Text('debited'.toUpperCase(), style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red),)
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Amount : ${docs[index]['credited'] != 0 ? docs[index]['credited'] : docs[index]['debited'] }',
                                        style: const TextStyle(fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 5,),
                                      docs[index]['description'] != ""
                                          ? Text('Description : ${docs[index]['description']}',
                                        style: const TextStyle(fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                      )
                                          : const Text(''),
                                      docs[index]['description'] != "" ? const SizedBox(height: 15,) : const SizedBox(height: 1,)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,)
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
            _scaffoldKey
            .currentState
            ?.showBottomSheet((context) => _buildBottomSheet(context));
        },
        child: const Icon(Icons.add),
      ),

    );
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();
    String formattedDateTime = '$day-$month-$year';
    return formattedDateTime;
  }

  void getBalance() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
    await firestore.collection('balance').doc(userUID).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> map = documentSnapshot.data() as Map<String, dynamic>;
      print("data ava");
      setState(() {
        balance = map;
        print('set state');
        credited = map['credited']!;
        debited = map['debited']!;
        print(balance);
      });
    } else {
      return;
    }
  }

  Container _buildBottomSheet(BuildContext context){
    return Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Credit',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
                  Switch.adaptive(
                      value: credit,
                      onChanged: (bool val){
                        credit == true && debit == false
                            ? null
                            : setState(() {
                          debit = false;
                          credit = val;
                          _scaffoldKey
                              .currentState
                              ?.showBottomSheet((context) => _buildBottomSheet(context));
                        });
                      }
                  ),
                  const SizedBox(width: 20,),
                  const Text('Debit',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
                  Switch.adaptive(
                      value: debit,
                      onChanged: (bool val){
                        debit == true && credit == false
                            ? null
                            : setState(() {
                          credit = false;
                          debit = val;
                          _scaffoldKey
                              .currentState
                              ?.showBottomSheet((context) => _buildBottomSheet(context));
                        });
                      }
                  )
                ],
              ),

              TextFormField(
                controller: numberController,
                obscureText: false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                cursorColor: Colors.red,
                validator: (value){
                  if(value!.isEmpty){
                    return "Enter a Number";
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Amount".toUpperCase(),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
                  prefixIcon: const Icon(Icons.account_balance_outlined),
                  prefixIconColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.purpleAccent),
                  ),
                  fillColor: Colors.grey[700],
                  filled: true,
                ),
              ),

              const SizedBox(height: 20,),

              TextFormField(
                controller: descriptionController,
                obscureText: false,
                textInputAction: TextInputAction.next,
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                cursorColor: Colors.red,
                decoration: InputDecoration(
                  labelText: "Description".toUpperCase(),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
                  prefixIcon: const Icon(Icons.description_outlined),
                  prefixIconColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.purpleAccent),
                  ),
                  fillColor: Colors.grey[700],
                  filled: true,
                ),
              ),

              const SizedBox(height: 20,),

              Container(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  onPressed: () async {

                    int ammCredit = credit ? int.parse(numberController.text) : 0;
                    int ammDebit = debit ? int.parse(numberController.text) : 0;
                    String date = getCurrentDateTime();
                    String decription = descriptionController.text;

                    if(numberController.toString().isNotEmpty){
                      if(credit){
                        balance = {
                          'credited': credited + ammCredit,
                          'debited': debited
                        };
                      }else{
                        balance = {
                          'credited': credited ,
                          'debited': debited + ammDebit
                        };
                      }

                      await FirebaseFirestore.instance.collection('balance').doc(userUID).set(balance)
                          .then((value){
                            setState(() {
                              credited = balance['credited'];
                              debited = balance['debited'];
                            });
                            numberController.clear();
                            descriptionController.clear();
                      });

                      credit
                          ? FirebaseFirestore.instance
                          .collection('history')
                          .doc(userUID)
                          .collection(userUID)
                          .add({
                        'description': decription,
                        'credited': ammCredit,
                        'debited': 0,
                        'date': date,
                        'timestamp': Timestamp.now(),
                      })
                          : FirebaseFirestore.instance
                          .collection('history')
                          .doc(userUID)
                          .collection(userUID)
                          .add({
                        'credited': 0,
                        'debited': ammDebit,
                        'description': descriptionController.text.toString(),
                        'date': date,
                        'timestamp': Timestamp.now(),
                      });
                    }
                  }
                ),
              )
            ]
        )
    );
  }
}
