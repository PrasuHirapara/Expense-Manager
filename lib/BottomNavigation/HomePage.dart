import 'package:expenses_manager/BottomNavigation/SpecificHistory.dart';
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
  int selectedIndex = 0;

  late Map<String, dynamic> balance;
  Map<int, String> item = {
    0: 'Other',
    1: 'Deposit',
    2: 'Withdraw',
    3: 'Bank',
    4: 'Business',
    5: 'Food',
    6: 'Grocery',
    7: 'Hotel',
    8: 'Stationary',
    9: 'Collage',
    10: 'Festivals',
  };
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

  @override
  void initState(){
    super.initState();
    getBalance();
    getMap();
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
              child: Card(
                elevation: 10,
                color: Colors.grey[800],
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('${getCurrentDateTime() } ', style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      ),

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
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'deposit')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color:selectedContainer,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: selectedIndex == 1 ? Colors.white : Colors.black,
                              width: 2
                          )
                      ),
                      child: Center(child: Text(item[1]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'withdraw')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedContainer,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(item[2]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'bank')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedContainer,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(item[3]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'business')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedContainer,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(item[4]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'food')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedContainer,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(item[5]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'grocery')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedContainer,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(item[6]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'hotel')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedContainer,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(item[7]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'stationary')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedContainer,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(item[8]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'collage')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedContainer,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(item[9]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'festival')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: selectedContainer,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(item[10]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SpecificHistory(title: 'other')));
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: selectedContainer,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(item[0]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20,),

            _buildTransactionHistory()
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
      setState(() {
        balance = map;
        credited = map['credited']!;
        debited = map['debited']!;
      });
    } else {
      return;
    }
  }

  void getMap() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
    await firestore.collection('credit_analysis').doc(userUID).get();

    DocumentSnapshot documentSnapshot0 =
    await firestore.collection('credit_analysis').doc(userUID).get();

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

  Expanded _buildTransactionHistory(){
    return  Expanded(
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
                                  ? Text('credited - ${docs[index]['item']}'.toUpperCase(), style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green),
                              )
                                  :  Text('debited - ${docs[index]['item']}'.toUpperCase(), style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                              )
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
    );
  }

  Container _buildBottomSheet(BuildContext context){
    return Container(
        height: 380,
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

              const SizedBox(height: 10),

             SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 0;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 0 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[0]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 1;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 1 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[1]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 2;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 2 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[2]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 3;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 3 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[3]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 4;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 4 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[4]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 5;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 5 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[5]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 6;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 6 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[6]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 7;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 7 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[7]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 8;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 8 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[8]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 9;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 9 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[9]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         selectedIndex = 10;
                         _scaffoldKey
                             .currentState
                             ?.showBottomSheet((context) => _buildBottomSheet(context));
                       });
                     },
                     child: Container(
                       width: 100,
                       height: 50,
                       decoration: BoxDecoration(
                           color: Colors.black,
                           borderRadius: BorderRadius.circular(15),
                           border: Border.all(
                               color: selectedIndex == 10 ? Colors.white : Colors.black,
                               width: 2
                           )
                       ),
                       child: Center(child: Text(item[10]!,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
                     ),
                   ),
                   const SizedBox(width: 5,),
                 ],
               ),
             ),

              const SizedBox(height: 15),

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

                    credit ? updateCreditItem[item[selectedIndex]!] = (updateCreditItem[item[selectedIndex]]! + ammCredit) : null;

                    debit ? updateDebitItem[item[selectedIndex]!] = (updateDebitItem[item[selectedIndex]]! + ammDebit) : null;

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

                      await FirebaseFirestore.instance.collection('credit_analysis').doc(userUID).set(updateCreditItem);

                      await FirebaseFirestore.instance.collection('debit_analysis').doc(userUID).set(updateDebitItem);

                      credit
                          ? await FirebaseFirestore.instance
                          .collection('history')
                          .doc(userUID)
                          .collection(userUID)
                          .add({
                        'credited': ammCredit,
                        'item': item[selectedIndex]?.toLowerCase(),
                        'description': decription,
                        'debited': 0,
                        'date': date,
                        'timestamp': Timestamp.now(),
                      })
                          : await FirebaseFirestore.instance
                          .collection('history')
                          .doc(userUID)
                          .collection(userUID)
                          .add({
                        'credited': 0,
                        'debited': ammDebit,
                        'item': item[selectedIndex]?.toLowerCase(),
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
