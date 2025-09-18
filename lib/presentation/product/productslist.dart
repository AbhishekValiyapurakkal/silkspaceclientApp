import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkspaceclient/presentation/product/productdescriptionpage.dart';

class Productslist extends StatefulWidget {
  const Productslist({
    super.key,
    required this.category,
  });
  final String category;
  @override
  State<Productslist> createState() => _ProductslistState();
}

class _ProductslistState extends State<Productslist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 5,
        shadowColor: Colors.black,
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Text(
              "Products",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                  shadows: [
                    Shadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 2)
                  ]),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('category', isEqualTo: widget.category)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LinearProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final snap = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Productdescriptionpage(
                                id: snap.id,
                                stock: snap['stock'],
                                name: snap['name'],
                                description: snap['description'],
                                image: snap['image'],
                                price: snap['price']),
                          ));
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      //color: Colors.blue,
                      child: Row(
                        children: [
                          Container(
                            height: 200,
                            width: 120,
                            color: Colors.grey[700],
                            child: Image(
                              image: NetworkImage(snap['image']),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  snap['name'],
                                  style: GoogleFonts.sansita(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  snap['description'],
                                  style: GoogleFonts.sansita(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 10),
                                child: Text("Rs:${snap['price']}₹",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
