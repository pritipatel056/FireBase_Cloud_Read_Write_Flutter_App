
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: 'key',
    appId: 'id',
    messagingSenderId: 'sendid',
    projectId: 'chroedifytask',
    storageBucket: 'myapp-b9yt18.appspot.com',
  ));
  runApp(   MaterialApp(home: RealtimeDatabaseInsert()));
}



class RealtimeDatabaseInsert extends StatefulWidget {
  RealtimeDatabaseInsert({super.key});

  @override
  State<RealtimeDatabaseInsert> createState() => _RealtimeDatabaseInsertState();
}

class _RealtimeDatabaseInsertState extends State<RealtimeDatabaseInsert> {
  var nameController = new TextEditingController();

  var lastNameController = new TextEditingController();

  var emailIdController = new TextEditingController();

  var messageController = new TextEditingController();

  final firestore = FirebaseFirestore.instance;

  get data => null;


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextFormField(
                      controller: nameController,
                      maxLength: 15,
                      decoration: const InputDecoration(
                          labelText: 'First Name', border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: lastNameController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'Last Name', border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: emailIdController,
                      maxLength: 20,
                      decoration: const InputDecoration(
                          labelText: 'Email Id',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(
                          labelText: 'Message', border:   OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isNotEmpty &&
                            lastNameController.text.isNotEmpty &&
                            emailIdController.text.isNotEmpty &&
                            messageController.text.isNotEmpty
                        ) {
                          firestore.collection("User Details").add({
                            "First Name": nameController.text,
                            "Last Name": lastNameController.text,
                            "Email ID": emailIdController.text,
                            "Message": messageController.text,
                          });
                       nameController.clear();
                          lastNameController.clear();
                          emailIdController.clear();
                          messageController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Data saved"),
                          ));
                        }
                      },
                      child: Text(
                        "Submit Details",
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("User Details").snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            print("userdaetails ${snapshot.data}");
                            return Container(
                              height: 10,
                              //child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            height: MediaQuery.of(context).size.height ,
                            width: MediaQuery.of(context).size.width ,
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                scrollDirection: Axis.vertical,shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),

                                itemBuilder: (context,index) {
                                  return index==0?Container(height: 10,):Container(
                                      padding: const EdgeInsets.all(12.0),
                                      margin: const EdgeInsets.all(8.0) ,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("First Name : ${snapshot.data!.docs[index]['First Name']}"),
                                          Text("Last Name:${snapshot.data!.docs[index]['Last Name']}"),
                                          Text("Email Id :${snapshot.data!.docs[index]['Email ID']}"),
                                          Text("Message :${snapshot.data!.docs[index]['Message']}"),
                                        ],
                                      )

                                  );

                                }


                            ),
                          );
                        })

              ],
                ),
              ),
            ),
          ),
        ));
  }
}
