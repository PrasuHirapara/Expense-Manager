import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/Constants/AppColors.dart';
import 'package:expenses_manager/auth/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../Constants/TextFormFields.dart';

class SignUpPage extends StatefulWidget{
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final bool _signUp = true;
  bool obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final userFirstNameController = TextEditingController();
  final userLastNameController = TextEditingController();
  final userNumberController = TextEditingController();
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

  Map<String, int> updateItem = {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appPrimary,

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
              const SizedBox(height: 100,),

                Container(
                  width: MediaQuery.sizeOf(context).width/1.2,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Hero(
                        tag: 'signinTOsignup',
                        child: Container(
                          margin: const EdgeInsets.all(7),
                          width: MediaQuery.sizeOf(context).width/2.4,
                          decoration: BoxDecoration(
                              color: _signUp
                                  ? Colors.grey
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18)
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                                },
                                child: const Text('Sign In',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500, color: Colors.white),)
                            ),
                            const SizedBox(width: 5,),
                            const Text('Sign Up',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 50,),

              // Username text-field
                auth_TextFormField(userFirstNameController, const Icon(Icons.perm_identity_outlined), "Name", "Enter First Name"),

                const SizedBox(height: 15,),

                // Username text-field
                auth_TextFormField(userLastNameController, const Icon(Icons.perm_identity_outlined), "Surname", "Enter Last Name"),

                const SizedBox(height: 15,),

                // Id text-field
                auth_TextFormField(userIdController, const Icon(Icons.email_outlined), "Email", "Enter Email ID"),

                const SizedBox(height: 15,),

                // Mobile number text-field
                auth_TextFormField(userNumberController, const Icon(Icons.phone), "Phone Number", "Enter Phone Number"),

                const SizedBox(height: 15,),

                // Password text-field
                auth_TextFormField(passwordController, const Icon(Icons.password_outlined), "password", "Enter Password", obscureText: true),

              const SizedBox(height: 20,),

              // Sign-Up
              GestureDetector(
                onTap: (){
                  signUp();
                },
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurpleAccent,
                        Colors.purpleAccent.shade200,
                        Colors.purpleAccent,
                        Colors.purple,
                      ],
                    ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Center(child: Text("sign up".toUpperCase(),style: const TextStyle(color: Colors.white),)),
                ),
              ),

                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
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

  Future signUp() async {
    if (_formKey.currentState!.validate()) {
      late String currentDateTime = getCurrentDateTime();
      try {
        final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: userIdController.text,
            password: passwordController.text
        );
        final user = authResult.user;

        Map<String, dynamic> data = {
          "first_name": userFirstNameController.text,
          "last_name": userLastNameController.text,
          "email": userIdController.text,
          "password" : passwordController.text,
          "user_uid" : user!.uid.toString(),
          "phone_number": userNumberController.text,
          "registration_date" : currentDateTime,
        };

        Map<String, dynamic> balance = {
          'credited': 0,
          'debited': 0
        };

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(data)
            .then((value){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigation()));
        });
        await FirebaseFirestore.instance.collection('balance').doc(user.uid).set(balance)
            .then((value){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigation()));
        });
        await FirebaseFirestore.instance.collection('credit_analysis').doc(user.uid).set(updateItem);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User created successfully!'),duration: Duration(seconds: 1),));

      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}


