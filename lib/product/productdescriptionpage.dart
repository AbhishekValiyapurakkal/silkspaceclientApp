import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silkspaceclient/buttons/buttons.dart';
import 'package:silkspaceclient/cart/cartpage.dart';
import 'package:silkspaceclient/wishlist/wishlistpage.dart';

class Productdescriptionpage extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final String image;
  final String price;
  final String stock;
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
        title: Text(
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
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                      spreadRadius: 2)
                ],
                image: DecorationImage(
                    image: NetworkImage(widget.image), fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange),
          ),
          Row(
            children: [
              SizedBox(
                width: 80,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.name,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  widget.description,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 140,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Text(
                      widget.stock == '0' ? "out of stock" : widget.price,
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 35,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(width: 50),
                    IconButton(
                        onPressed: () {
                          if (isWish == false) {
                            wishlist();
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Wishlistpage()));
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
          SizedBox(height: 30),
          Row(
            children: [
              Spacer(),
              elvbtn(
                  txt: isCart ? "Go to Cart" : "Add to cart",
                  ontap: () {
                    if (isCart == false) {
                      create();
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Cartpage()));
                    }
                  },
                  height: 50,
                  width: 150),
              Spacer(),
              elvbtn(txt: "Buy Now", ontap: () {}, height: 50, width: 150),
              Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
