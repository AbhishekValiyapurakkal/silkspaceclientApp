import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silkspaceclient/presentation/buttons/buttons.dart';
import 'package:silkspaceclient/presentation/cart/cartpage.dart';
import 'package:silkspaceclient/presentation/wishlist/wishlistpage.dart';

class Productdescriptionpage extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final String image;
  final String price;
  final int stock;
  const Productdescriptionpage(
      {super.key,
      required this.name,
      required this.description,
      required this.image,
      required this.price,
      required this.id,
      required this.stock});

  @override
  State<Productdescriptionpage> createState() => _ProductdescriptionpageState();
}

class _ProductdescriptionpageState extends State<Productdescriptionpage> {
  bool isCart = false;
  bool isWish = false;

  create() async {
    try {
      await FirebaseFirestore.instance.collection('cart').add({
        'product_id': widget.id,
        'name': widget.name,
        'description': widget.description,
        'image': widget.image,
        'price': widget.price,
        'userId': FirebaseAuth.instance.currentUser!.email,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          "Product added to cart",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white60,
      ));
      setState(() {
        isCart = true;
      });
    } catch (e) {
      print(e);
    }
  }

  wishlist() async {
    try {
      await FirebaseFirestore.instance.collection('wishlist').add({
        'product_id': widget.id,
        'name': widget.name,
        'description': widget.description,
        'image': widget.image,
        'price': widget.price,
        'userId': FirebaseAuth.instance.currentUser!.email,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          "Product added to wishlist",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white60,
      ));
      setState(() {
        isWish = true;
      });
    } catch (e) {
      print(e);
    }
  }

  checkCartstate() async {
    final cartitems = await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('product_id', isEqualTo: widget.id)
        .get();
    if (cartitems.docs.isNotEmpty) {
      setState(() {
        isCart = true;
      });
    }
  }

  checkWishliststate() async {
    final wishlistitems = await FirebaseFirestore.instance
        .collection('wishlist')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('product_id', isEqualTo: widget.id)
        .get();
    if (wishlistitems.docs.isNotEmpty) {
      setState(() {
        isWish = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkCartstate();
    checkWishliststate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Details",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                      spreadRadius: 2)
                ],
                image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.image),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey),
          ),
          Row(
            children: [
              const SizedBox(
                width: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.description,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 140,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Text(
                      widget.stock == '0' ? "out of stock" : widget.price,
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 35,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 50),
                    IconButton(
                        onPressed: () {
                          if (isWish == false) {
                            wishlist();
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Wishlistpage()));
                          }
                        },
                        icon: Icon(
                          isWish ? Icons.favorite : Icons.favorite_border,
                          color: isWish ? Colors.red : Colors.black,
                        ))
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Spacer(),
              elvbtn(
                  txt: isCart ? "Go to Cart" : "Add to cart",
                  ontap: () {
                    if (isCart == false) {
                      create();
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Cartpage()));
                    }
                  },
                  height: 50,
                  width: 150),
              // Spacer(),
              // elvbtn(txt: "Buy Now", ontap: () {}, height: 50, width: 150),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
