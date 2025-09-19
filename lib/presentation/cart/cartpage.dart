import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  bool allItemsOutOfStock = false;
  Map<String, String> selectedItems = {};
  Map<String, List<String>> itemQuantities = {};
  int total = 0;

  Future fetchPrice() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();

      int newTotal = 0;

      List prices = querySnapshot.docs.map((doc) => doc['price']).toList();
      for (var item in prices) {
        newTotal += int.parse(item);
      }

      setState(() {
        total = newTotal;
      });
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Future<List<String>> fetchstock(String product_id) async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(product_id)
          .get();
      int stock = int.parse(productDoc['stock']);
      log('Stock for product_id $product_id: $stock');
      // return List<String>.generate(stock, (index) => (index + 1).toString());
      return stock > 0
          ? List<String>.generate(stock, (index) => (index + 1).toString())
          : [];
    } catch (e) {
      log('Error fetching stock: $e');
      return [];
    }
  }

  List addresslist = [];
  List phonelist = [];
  Future fetchAddress() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('address')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();
      List address = querySnapshot.docs.map((doc) => doc['address']).toList();
      List phone = querySnapshot.docs.map((doc) => doc['phone']).toList();
      setState(() {
        addresslist = address;
        phonelist = phone;
      });
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    fetchPrice();
    fetchAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchAddress,
      child: Container(
        color: Colors.blue,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 5,
              shadowColor: Colors.black,
              backgroundColor: Colors.blue,
              title: Row(
                children: [
                  Text(
                    "CART",
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
                    .collection('cart')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: LinearProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final snap = snapshot.data!.docs[index];
                        String itemId = snap.id;
        
                        int.parse(selectedItems[itemId] ?? '1');
                        return FutureBuilder(
                          future: fetchstock(snap['product_id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LinearProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              log(snapshot.error.toString());
                            }
        
                            List<String> quantities = snapshot.data ?? ['1'];
                            itemQuantities[itemId] = quantities;
        
                            int quantity =
                                int.parse(selectedItems[itemId] ?? '1');
                            int price = int.parse(snap['price']);
        
                            bool isOutOfStock = quantities.isEmpty;
        
                            if (isOutOfStock) {
                              allItemsOutOfStock = allItemsOutOfStock || true;
                            } else {
                              allItemsOutOfStock = allItemsOutOfStock && false;
                            }
                            return ListTile(
                              leading: Image(
                                image: NetworkImage(snap['image']),
                                fit: BoxFit.fill,
                              ),
                              title: Text(snap['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isOutOfStock
                                        ? "Out of stock"
                                        : "₹ ${price * quantity}",
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if (!isOutOfStock) ...[
                                        SizedBox(
                                          height: 50,
                                          width: 100,
                                          child: DropdownButton<String>(
                                            hint: const Text("quantity"),
                                            value: selectedItems[itemId] ?? "1",
                                            items: quantities.map(
                                              (String item) {
                                                return DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(item));
                                              },
                                            ).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                int previousQuantity = int.parse(
                                                    selectedItems[itemId] ?? '1');
                                                int newQuantity =
                                                    int.parse(newValue!);
        
                                                total -= price * previousQuantity;
                                                total += price * newQuantity;
        
                                                selectedItems[itemId] =
                                                    newValue.toString();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(snap.id)
                                        .delete();
                                  },
                                  icon: const Icon(Icons.delete)),
                            );
                          },
                        );
                      });
                }),
            bottomSheet: Container(
              height: 100,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.acme(fontSize: 25),
                        ),
                        Text('₹ $total/-')
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                        onTap: allItemsOutOfStock
                            ? null
                            : () {
                                Navigator.pushNamed(context, 'checkout',
                                    arguments: {
                                      'quantity': selectedItems,
                                      'totalPrice': total.toString(),
                                      'address': addresslist.isEmpty
                                          ? "Add+New+Address+for delivery"
                                          : addresslist[0],
                                      'phone':
                                          phonelist.isEmpty ? " " : phonelist[0],
                                    });
                              },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.green]),
                              //color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                )
                              ]),
                          child: Center(
                              child: Text(
                            "Checkout",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal),
                          )),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
