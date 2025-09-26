import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:silkspaceclient/presentation/checkout/orderconfirm.dart';

class Checkoutpage extends StatefulWidget {
  const Checkoutpage({super.key});

  @override
  State<Checkoutpage> createState() => _CheckoutpageState();
}

class _CheckoutpageState extends State<Checkoutpage> {
  String? payment;
  String? paymentmethod;
  late Razorpay razorpay;
  DateFormat outputFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    void checkout(int price) async {
      final userId = FirebaseAuth.instance.currentUser!.email;
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('userId', isEqualTo: userId)
          .get();

      bool hasOutOfStockItems = false;

      for (var cartDoc in cartSnapshot.docs) {
        final cartItem = cartDoc.data() as Map<String, dynamic>;
        final productId = cartItem['product_id'];
        final cartQuantity = int.parse(args['quantity'][cartDoc.id] ?? "1");

        DocumentSnapshot productDoc = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();

        final productData = productDoc.data() as Map<String, dynamic>;
        final currentStock = productData['stock'];

        if (currentStock < cartQuantity) {
          hasOutOfStockItems = true;
          log('Product $productId is out of stock');
          break;
        }
      }

      if (hasOutOfStockItems) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text(
                  "Some products are out of stock. Please update your cart."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Go back"),
                ),
              ],
            );
          },
        );
      } else {
        var options = {
          'key': 'rzp_test_xMQq5wAwtsmsfE',
          'amount': 100 * price,
          'name': 'Silk Space PVT.Ltd',
          'description': 'Silk Space PVT.Ltd',
          'prefill': {
            'contact': '9747816550',
            'email': 'abhisheksilkspace@razorpay.com',
          }
        };
        try {
          razorpay.open(options);
        } catch (e) {
          log(e.toString());
        }
      }
    }

    Future updateStock() async {
      try {
        final userId = FirebaseAuth.instance.currentUser!.email;
        QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: userId)
            .get();

        for (var cartDoc in cartSnapshot.docs) {
          final cartItem = cartDoc.data() as Map<String, dynamic>;
          final productId = cartItem['product_id'];
          final cartQuantity = int.parse(args['quantity'][cartDoc.id] ?? "1");

          DocumentSnapshot productDoc = await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();

          final productData = productDoc.data() as Map<String, dynamic>;
          final currentStock = productData['stock'];

          if (currentStock >= cartQuantity) {
            // Check if stock is enough
            await FirebaseFirestore.instance
                .collection('products')
                .doc(productId)
                .update({
              'stock': currentStock - cartQuantity,
            });
          } else {
            log('Product $productId is out of stock');
          }
        }
      } catch (e) {
        log(e.toString());
      }
    }

    Future placeorder() async {
      try {
        final userId = FirebaseAuth.instance.currentUser!.email;

        QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: userId)
            .get();

        for (var cartDoc in cartSnapshot.docs) {
          final cartItem = cartDoc.data() as Map<String, dynamic>;
          final productId = cartItem['product_id'];
          final cartQuantity = int.parse(args['quantity'][cartDoc.id] ?? "1");

          DocumentSnapshot productDoc = await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();

          final productData = productDoc.data() as Map<String, dynamic>;
          final currentStock = productData['stock'] as int;

          if (currentStock >= cartQuantity) {
            // Check if stock is enough
            await FirebaseFirestore.instance.collection('orders').add({
              'product_id': cartItem['product_id'],
              'quantity': args['quantity'][cartDoc.id] ?? "1",
              'image': cartItem['image'],
              'name': cartItem['name'],
              'description': cartItem['description'],
              'phone': args['phone'],
              'totalPrice': cartItem['price'],
              'address': args['address'],
              'payment': paymentmethod,
              'placed_date': outputFormat.format(DateTime.now()),
              'userId': userId,
              'track': "pending",
              'status': 0,
            });

            await updateStock(); // Update stock after placing the order

            for (QueryDocumentSnapshot doc in cartSnapshot.docs) {
              await doc.reference.delete();
            }
          } else {
            log('Product $productId is out of stock, skipping order.');
          }
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderConfirmed(),
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text("Something went wrong"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Check later?"),
                ),
              ],
            );
          },
        );
      }
    }

    void handlepaymentsuccess(PaymentSuccessResponse response) {
      log(response.toString());
      placeorder();
      updateStock();
    }

    void handlepaymentError(PaymentFailureResponse response) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text("Something went wrong ! Please try again"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Go back"))
            ],
          );
        },
      );
    }

    void handleExternalWallet(ExternalWalletResponse response) {}

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlepaymentsuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlepaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: Colors.blue,
        title: const Text(
          "Order Now",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              shadows: [
                Shadow(
                    color: Colors.black12, offset: Offset(0, 2), blurRadius: 2)
              ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              child: Card(
                elevation: 20,
                shadowColor: Colors.black,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Text(
                              "Deliver to:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'cartaddress',
                                      arguments: {
                                        'Items': args['Items'],
                                        'totalPrice': args['totalPrice'],
                                        'address': args['address'],
                                        'quantity': args['quantity'],
                                      });
                                },
                                child: Text(
                                  args['address'] == "" ? "Add" : "Change",
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 15),
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          // color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              args['address'].split("+").join("\n"),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Card(
                elevation: 20,
                shadowColor: Colors.black,
                child: RadioListTile(
                  value: 'UPI',
                  title: const Row(
                    children: [
                      Text(
                        'UPI',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Icon(
                        Icons.home_filled,
                        color: Colors.black,
                      )
                    ],
                  ),
                  groupValue: payment,
                  onChanged: (value) {
                    setState(() {
                      payment = value;
                      paymentmethod = 'razorpay';
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Card(
                elevation: 20,
                shadowColor: Colors.black,
                child: RadioListTile(
                  value: 'Cash on delivery',
                  title: const Row(
                    children: [
                      Text(
                        'Cash on delivery',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Icon(
                        Icons.money_rounded,
                        color: Colors.black,
                      )
                    ],
                  ),
                  groupValue: payment,
                  onChanged: (value) {
                    setState(() {
                      payment = value;
                      paymentmethod = 'cod';
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Card(
                elevation: 20,
                shadowColor: Colors.black,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              const Text(
                                "Items:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              Text(
                                " ₹ ${args['totalPrice']} /-",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text("Delivery charge:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: paymentmethod == "razorpay"
                                          ? Colors.black
                                          : Colors.red,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Text(
                                paymentmethod == "razorpay"
                                    ? "₹ 0 /-"
                                    : " ₹ 50 /-",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                "Order Total: ",
                                style: GoogleFonts.sansita(
                                    fontSize: 30, fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              Text(
                                paymentmethod == "razorpay"
                                    ? "₹ ${args['totalPrice']} /-"
                                    : ": ₹ ${int.parse(args['totalPrice']) + 50} /-",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
              onTap: () {
                if (paymentmethod == "razorpay") {
                  checkout(int.parse(args['totalPrice']));
                } else if (paymentmethod == "cod") {
                  placeorder();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text("Please select a payment method"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Go back"))
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 10,
                width: 300,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.green]),
                    //color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 20,
                        spreadRadius: 2,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      )
                    ]),
                child: Center(
                    child: Text(
                  paymentmethod == "razorpay"
                      ? "Proceed To Pay"
                      : "Place Order",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal),
                )),
              )),
        ),
      ),
    );
  }
}
