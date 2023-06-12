import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/Constants/AppColors.dart';
import 'package:expenses_manager/Constants/TextFormFields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../BottomNavigation/BottomNavigation.dart';
import 'LoginPage.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String text_msg = "";
  String btn_msg = "send otp";
  String myOTP = "";
  String phoneNumber = "";
  bool OTP_sent = false;
  bool OTP_varified = false;
  bool obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController();
  final OTP_Controller = TextEditingController();
  final Phone_NumberController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appPrimary,
      body: OTP_varified?
      SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [

                  // Welcome
                  Text("Set new Password",style: TextStyle(color: Colors.grey[400],fontSize: 16,fontWeight: FontWeight.bold),),

                  const SizedBox(height: 25,),

                  Container(
                    width: MediaQuery.sizeOf(context).width/1.2,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'varifyTOreset',
                          child: Container(
                            margin: const EdgeInsets.all(7),
                            width: MediaQuery.sizeOf(context).width/2.4,
                            decoration: BoxDecoration(
                                color: OTP_varified
                                    ? Colors.grey
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(18)
                            ),
                          ),
                        ),
                        const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Varify',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                              SizedBox(width: 5,),
                              Text('Reset',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500, color: Colors.white),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25,),

                  // Mobile number text-field
                  auth_TextFormField(newPasswordController, const Icon(Icons.password_outlined), "New Password", "Enter a Password", obscureText: true),

                  const SizedBox(height: 15,),

                  auth_TextFormField(confirmNewPasswordController, const Icon(Icons.password_outlined), "Confirm New Password", "Enter a Password", obscureText: true),

                  const SizedBox(height: 20,),

                  // Send OTP
                  GestureDetector(
                    onTap: (){
                      setState(() async{
                        if(_formKey.currentState!.validate()){
                          if(newPasswordController.text == confirmNewPasswordController.text){
                            await updatePassword(newPasswordController.text);
                            await updateFirebaseFirestore();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigation()));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Both Password must be same.'),duration: Duration(seconds: 1),));
                          }
                        }
                      });
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
                      child: Center(child: Text("set password".toUpperCase(),style: const TextStyle(color: Colors.white,fontSize: 18),)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ) :
      SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // Welcome
                  Text("Verifying via Mobile Number",style: TextStyle(color: Colors.grey[400],fontSize: 16,fontWeight: FontWeight.bold),),

                  const SizedBox(height: 25,),

                  Container(
                    width: MediaQuery.sizeOf(context).width/1.2,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'varifyTOreset',
                          child: Container(
                            margin: const EdgeInsets.all(7),
                            width: MediaQuery.sizeOf(context).width/2.4,
                            decoration: BoxDecoration(
                                color: OTP_varified
                                    ? Colors.white
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(18)
                            ),
                          ),
                        ),
                        const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Varify',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,),),
                              SizedBox(width: 5,),
                              Text('Reset',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500, color: Colors.white),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25,),

                  // Mobile number text-field
                  auth_TextFormField(Phone_NumberController, Icon(Icons.phone), "Registered Phone Number", "Enter a number"),

                  const SizedBox(height: 15,),

                  // Mobile number text-field
                  auth_TextFormField(OTP_Controller, Icon(Icons.phone), "OTP", "Enter a OTP"),

                  const SizedBox(height: 15,),

                  // Forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(text_msg.toUpperCase(),),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20,),

                  // Send OTP
                  GestureDetector(
                    onTap: () async{
                      varifyOTP(Phone_NumberController.text);
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
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text(btn_msg.toUpperCase(),style: const TextStyle(color: Colors.white),)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getUserPhoneNumber(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (documentSnapshot.exists) {
        phoneNumber = documentSnapshot.data()!['phone_number'];
      }
    } catch (e) {
      print('Error getting user phone number: $e');
    }
    return phoneNumber;
  }

  Future<void> varifyOTP(String number) async{
      if(!OTP_sent){
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: "+91"+number,
            verificationCompleted:
                (PhoneAuthCredential credentials) {},
            verificationFailed: (FirebaseAuthException e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: const Duration(seconds: 2),));},
            codeSent: (String varificationId, int? resendToken) {
              myOTP = varificationId;
              setState(() {
                if(_formKey.currentState!.validate()){
                  if(!OTP_sent){
                    text_msg = "otp sent via mobile number";
                    btn_msg = "verify otp";
                    OTP_sent = true;
                  }
                }
              });
            },
            codeAutoRetrievalTimeout: (String varificationId){}
        ).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: const Duration(seconds: 1),));
        });
      }else{
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: myOTP,
          smsCode: OTP_Controller.text,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          await getUserPhoneNumber(FirebaseAuth.instance.currentUser!.uid);
          setState(() {
            btn_msg = "Reset password";
            OTP_varified = true;
          });
        });
      }
  }

  Future<void> updatePassword(String newPassword) async {
    if(_formKey.currentState!.validate()){
      if(newPasswordController.text == confirmNewPasswordController.text){
        try {
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            await user.updatePassword(newPassword)
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password Updated Successfully !'),duration: Duration(seconds: 1),));
            })
                .onError((error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: const Duration(seconds: 2),));
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Some error occurred !'),duration: Duration(seconds: 1),));
          }
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: const Duration(seconds: 3),));
        }
      }
    }
  }

  Future<void> updateFirebaseFirestore() async{
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'password' : newPasswordController.text,
    })
        .then((value) {ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Some error occurred !'),duration: Duration(seconds: 1),)); })
        .onError((error, stackTrace) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: const Duration(seconds: 1),));});
  }
}
