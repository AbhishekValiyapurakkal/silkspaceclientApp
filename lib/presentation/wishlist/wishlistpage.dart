import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Wishlistpage extends StatelessWidget {
  const Wishlistpage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              elevation: 10,
              shadowColor: Colors.black,
              backgroundColor: Colors.blue,
              title: Text(
                "wishlist",
                style: TextStyle(fontWeight: FontWeight.w600),
              )),
          body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('wishlist').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LinearProgressIndicator(),
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final snap = snapshot.data!.docs[index];
                      return ListTile(
                        leading: Image(
                          image: NetworkImage(snap['image']),
                          fit: BoxFit.fill,
                        ),
                        title: Text(snap['name']),
                        subtitle: Text(snap['price']),
                        trailing: IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('wishlist')
                                  .doc(snap.id)
                                  .delete();
                            },
                            icon: Icon(Icons.delete)),
                      );
                    });
              })),
    );
  }
}
