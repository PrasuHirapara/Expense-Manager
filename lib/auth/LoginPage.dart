import 'package:expenses_manager/Constants/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../Constants/TextFormFields.dart';
import 'ForgotPassword.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final bool _signIn = true;
  bool obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

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
                    children: [
                      Hero(
                        tag: 'signinTOsignup',
                        child: Container(
                          margin: const EdgeInsets.all(7),
                          width: MediaQuery.sizeOf(context).width/2.4,
                          decoration: BoxDecoration(
                            color: _signIn ? Colors.grey : Colors.white,
                            borderRadius: BorderRadius.circular(18)
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text('Sign In',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                            const SizedBox(width: 5,),
                            GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                                },
                                child: const Text('Sign Up',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500, color: Colors.white),)
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50,),

                // Id text-field
                auth_TextFormField(userIdController, const Icon(Icons.email_outlined), "Email", "Enter Email id"),

                const SizedBox(height: 15,),

                // Password text-field
                auth_TextFormField(passwordController, const Icon(Icons.password_outlined), "Password", "Enter Password", obscureText: true),

                const SizedBox(height: 15,),

                // Forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword(),));
                        },
                          child: const Text("Forgot Password",style: TextStyle(color: Colors.blue),)
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15,),

                // Sign-in
                GestureDetector(
                  onTap: (){
                    if(_formKey.currentState!.validate()){
                      try {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: userIdController.text,
                          password: passwordController.text)
                      .then((value){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Login successfully!'),duration: Duration(seconds: 1),));
                      }).then((value){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigation()));
                      })
                      .onError((error, stackTrace){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: const Duration(seconds: 2),));
                      });
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString(),)));
                      }
                    }
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
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Center(child: Text("sign in".toUpperCase(),style: const TextStyle(color: Colors.white),)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}