import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class WorkOnList extends StatefulWidget {
   const WorkOnList({Key? key}) : super(key: key);

  @override
  State<WorkOnList> createState() => _WorkOnListState();
}

class _WorkOnListState extends State<WorkOnList> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Products");
 createlist(String val) async {
  await ref.set({
    "todo": val,
    "priority": "high"
  });
  return Text("its created");
}
 updateList(String val) async {
  await ref.update({
    "todo": val,
  });
  return Text("its updated");
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("\nProduct"),
            TextButton(child: Text("edit"), onPressed: (){createlist("yes");}
            // createlist("yes")
            ),
            TextButton(child: Text("update"), onPressed:
            (){updateList("yes its updated");}
            // updateList("yes its updated")
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Products").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasData) {
                  final snap = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 70,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snap[index]['name'],
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              alignment: Alignment.centerRight,
                              child: Text(
                                "\$${snap[index]['price']}",
                                style: TextStyle(
                                  color: Colors.green.withOpacity(0.7),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Container(child: Column(
                    children: [ Text("else")
                     ],
                  ),);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}