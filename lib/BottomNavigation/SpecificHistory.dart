import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Constants/AppColors.dart';

class SpecificHistory extends StatefulWidget {
  const SpecificHistory({super.key, required this.title});

  final String title;

  @override
  State<SpecificHistory> createState() => _SpecificHistoryState();
}

class _SpecificHistoryState extends State<SpecificHistory> {

  final String userUID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appPrimary,
      body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              _buildOtherHistory()
            ],
          )
      ),
    );
  }

  Expanded _buildOtherHistory(){
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
              return docs[index]['item'] == widget.title
                  ? Column(
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
                  )
                  : const SizedBox(width: 1,) ;
            },
          );
        },
      ),
    );
  }
}

