import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/Constants/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../Constants/TextFormFields.dart';
import 'LoginPage.dart';

class ForgotPassword extends StatefulWidget{
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String text_msg = "";
  String btn_msg = "send otp";
  String myOTP = "";
  String phoneNumber = "";
  bool OTP_sent = false;

  final _formKey = GlobalKey<FormState>();
  final Phone_NumberController = TextEditingController();
  final OTP_Controller = TextEditingController();

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

                // App Logo
                const Icon(Icons.login_outlined,size: 50, color: Colors.white,),

                const SizedBox(height: 25,),

                // Welcome
                Text("Login via OTP",style: TextStyle(color: Colors.white70,fontSize: 16,fontWeight: FontWeight.bold),),

                const SizedBox(height: 25,),

                // Mobile number text-field
                auth_TextFormField(Phone_NumberController, const Icon(Icons.phone), "Phone Number", "Enter Registered Phone Number"),

                SizedBox(height: 15,),

                auth_TextFormField(OTP_Controller, const Icon(Icons.password_outlined), "OTP", "Enter OTP"),

                const SizedBox(height: 15,),

                // Forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(text_msg.toUpperCase(),style: const TextStyle(color: Colors.white70),),
                    ],
                  ),
                ),

                const SizedBox(height: 20,),

                // Send OTP
                GestureDetector(
                  onTap: () async{
                    await varifyOTP(Phone_NumberController.text);
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
                        ]
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
    if(_formKey.currentState!.validate()){
      if(!OTP_sent){
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: "+91$number",
            verificationCompleted:
                (PhoneAuthCredential credentials) {},
            verificationFailed: (FirebaseAuthException e) {},
            codeSent: (String varificationId, int? resendToken) {
              print(myOTP);
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
        );}else{
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: myOTP,
          smsCode: OTP_Controller.text,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async{
          await getUserPhoneNumber(FirebaseAuth.instance.currentUser!.uid);
          if(phoneNumber.toString() == Phone_NumberController.text){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation()));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Login successfully!'),duration: Duration(seconds: 1),));
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mobile Number does not exist in Database'),duration: Duration(seconds: 1),));
          }
        })
            .onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: Duration(seconds: 3),));
        });
      }
    }
  }

}