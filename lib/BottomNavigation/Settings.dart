import 'dart:async';
import 'package:expenses_manager/Constants/TextStyle.dart';
import 'package:expenses_manager/auth/ResetPassword.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Constants/AppColors.dart';
import '../auth/LoginPage.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isVisible = false;

  static final String userUID = FirebaseAuth.instance.currentUser!.uid;
  static String first_name = "";
  static String last_name = "";
  static String email = "";
  static String phone_number = "";
  static String registration_date = "";

  @override
  initState() {
    super.initState();
    Timer(const Duration(milliseconds: 50), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    fetchUserInformation(userUID);

    return Scaffold(
      backgroundColor: appPrimary,

      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: const Duration(seconds: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: const Image(
                              image: AssetImage('assets/icons/user_logo.png'),
                            ),
                          ),
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${first_name} ${last_name}',style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20),),
                            const SizedBox(height: 5,),
                            Text(phone_number,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                            Text(email,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              ListTile(
                leading: const Icon(Icons.lock_reset_outlined,color: Colors.white,size: 30,),
                title: Text('Reset Expenses',style: settingTextStyle()),
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Reset Expenses',style: TextStyle(fontSize: 30),),
                        content: const Text('Your expense history will deleted',style: TextStyle(fontSize: 17),),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('NO'),
                          ),
                          TextButton(
                            onPressed: () async {

                              Map<String, int> balance = {
                                'credited': 0,
                                'debited': 0
                              };
                              Map<int, String> item = {
                                0: 'Other',
                                1: 'Deposit',
                                2: 'Withdraw',
                                3: 'Investment',
                                4: 'Bank',
                                5: 'Business',
                                6: 'Food',
                                7: 'Grocery',
                                8: 'Hotel',
                                9: 'Stationary',
                                10: 'Collage',
                                11: 'Festivals',
                              };
                              Map<String, dynamic> creditItem = {
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
                              Map<String, dynamic> debitItem = {
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

                              await FirebaseFirestore.instance.collection('balance').doc(userUID).set(balance);

                              await FirebaseFirestore.instance.collection('credit_analysis').doc(userUID).set(creditItem);

                              await FirebaseFirestore.instance.collection('debit_analysis').doc(userUID).set(debitItem);

                            },
                            child: const Text('YES'),
                          ),
                        ],
                      )
                  );
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.bug_report_outlined,color: Colors.white,size: 30,),
                title: Text('Report a Bug',style: settingTextStyle()),
              ),

              const Divider(),

              ListTile(
                onTap: (){
                  _launchGmail();
                },
                leading: const Icon(Icons.developer_board,color: Colors.white,size: 30,),
                title: Text('Contact Developer',style: settingTextStyle()),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.change_circle_outlined,color: Colors.white,size: 30,),
                title: Text('Change Password',style: settingTextStyle()),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout_outlined,color: Colors.white,size: 30,),
                title: Text('Log out',style: settingTextStyle()),
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Log Out',style: TextStyle(fontSize: 30),),
                        content: const Text('Are you sure want to Log Out ?',style: TextStyle(fontSize: 17),),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('NO'),
                          ),
                          TextButton(
                            onPressed: () {
                              signOut();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
                            },
                            child: const Text('YES'),
                          ),
                        ],
                      )
                  );
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.delete_outline,color: Colors.white,size: 30,),
                title: Text('Delete Account',style: settingTextStyle()),
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Account',style: TextStyle(fontSize: 30),),
                        content: const Text('Are you sure want to Delete Account ?',style: TextStyle(fontSize: 17),),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('NO'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteAccount(FirebaseAuth.instance.currentUser!.uid);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
                            },
                            child: const Text('YES'),
                          ),
                        ],
                      )
                  );
                },
              ),

              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
    await firestore.collection('users').doc(userId).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  void fetchUserInformation(String userId) async {
    Map<dynamic, dynamic>? userData = await getUserData(userId);

    if (userData != null) {
      setState(() {
        first_name = userData['first_name'];
        last_name = userData['last_name'];
        email = userData['email'];
        phone_number = userData['phone_number'];
        registration_date = userData['registration_date'];
      });
    } else {
      if (kDebugMode) {
        print('User data not found.');
      }
    }
  }

  void signOut(){
    FirebaseAuth.instance.signOut().onError((error, stackTrace){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }

  void deleteAccount(String docId) async {
    try {
      DocumentReference documentReference =
      FirebaseFirestore.instance.collection('users').doc(docId);

      await FirebaseAuth.instance.currentUser!.delete();

      await documentReference.delete()
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account deleted successfully."),duration: Duration(seconds: 2),));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: const Duration(seconds: 3),));
    }
  }

  void _launchGmail() async {
    const email = 'prasuhirpara@gmail.com';
    const url = 'mailto:$email';

    await launch(url);
  }
}
