import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget auth_TextFormField(TextEditingController controller, Icon icon, String label, String validator, {bool obscureText = false}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
      cursorColor: Colors.red,
      validator: (value){
        if(value!.isEmpty){
          return validator;
        }else{
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: label.toUpperCase(),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
        prefixIcon: icon,
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
  );
}