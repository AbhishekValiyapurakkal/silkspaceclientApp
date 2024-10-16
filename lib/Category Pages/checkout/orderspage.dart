import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkspaceclient/ordertracking/ordertrack.dart';

class Orderspage extends StatelessWidget {
  const Orderspage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 10,
            shadowColor: Colors.black,
            backgroundColor: Colors.blue,
            title: SizedBox(height: 40, child: Text("Orders")),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('orders').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator();
              }
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final snap = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Ordertrack(
                                    currentstep: snap['status'].toInt()),
                              ));
                        },
                        leading: Image(
                          image: NetworkImage(snap['image']),
                          fit: BoxFit.fill,
                        ),
                        title: Text(snap['name']),
                        subtitle: Text(snap['totalPrice']),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text("Do you want to cancel order?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(snap.id)
                                              .delete();
                                        },
                                        child: Text(
                                          "YES",
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    TextButton(
                                        onPressed: () {}, child: Text("NO")),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.delete)),
                      ),
                    );
                  });
            },
          )),
    );
  }
}
