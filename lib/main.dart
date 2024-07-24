// import 'package:chit_chat/pic_upload.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
//
// import 'WorkOnList.dart';
//
// void main() async {
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      //  appBar: AppBar(
//      //    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//      //    title: Text("Firebase initialize app"),
//      //  ),
//       body: FutureBuilder(future: _firebaseApp,
//       builder: (context, snapshot){
//         if(snapshot.hasError){
//           return  Text("something went wrong with firebase");
//         }else if(snapshot.hasData){
//           print("yee ho gya.. firebase connect ho gya..");
//           return  const WorkOnList();
//         }else{
//           return CircularProgressIndicator();
//         }
//       },)
//       );
//   }
// }
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'locations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root
// of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase',
      home: AddData(),
    );
  }
}

class AddData extends StatelessWidget {
  DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  savedata() async {
    await ref.set({
      "name": "John",
      "age": 18,
      "address": {
        "line1": "100 Mountain View"
      }
    });
    return Text("data saved");}

  updatedate() async {
    await ref.update({
      "123/age": 19,
      "123/address/line1": "1 Mountain View",
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.green,
        title: Text(" "),
      ),
      body:Column(
        children: [ Center(
          child: FloatingActionButton(
            // backgroundColor: Colors.green,
            child: Icon(Icons.add),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('data')
                  .add({'text': 'data added through app'});
            },
          ),
        ),
          TextButton(onPressed: (){
            Text("save data pressed");
            savedata();
          }, child: Text("save")),
          TextButton(onPressed: (){
            Text("save data pressed");
            updatedate();
          }, child: Text("update")),
          TextButton(onPressed: (){
            Text("save data pressed");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GetLocation()),
            );
            // updatedate();
          }, child: Text("location"))
          // updatedate
        ],
      ),
    );
  }
}
