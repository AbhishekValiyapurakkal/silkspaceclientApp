// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddAddressCart extends StatefulWidget {
  const AddAddressCart({
    super.key,
  });

  @override
  State<AddAddressCart> createState() => _AddAddressCartState();
}

class _AddAddressCartState extends State<AddAddressCart> {
  String? address;

  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController house = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController pincode = TextEditingController();

  Future addAddress() async {
    try {
      await FirebaseFirestore.instance.collection('address').add({
        'address':
            "${name.text}+${contact.text}+${house.text}(H)+${street.text}+${city.text}+${district.text}+${pincode.text}",
        'userId': FirebaseAuth.instance.currentUser!.email,
        'phone': contact.text,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('address')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    log(snapshot.error.toString());
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final snap = snapshot.data!.docs[index];
                      return RadioListTile(
                        value: snap['address'] + "*" + snap['phone'],
                        title: Text(
                          snap['address'].split("+").join("\n"),
                        ),
                        groupValue: address,
                        onChanged: (value) {
                          setState(() {
                            address = value;
                            log(address.toString());
                          });
                        },
                      );
                    },
                  );
                }),
            SizedBox(
              height: 15,
            ),
            ExpansionTile(
              childrenPadding: EdgeInsets.all(10.0),
              title: Text(
                "Add Address",
                style: GoogleFonts.acme(color: Colors.blueGrey),
              ),
              trailing: Icon(Icons.arrow_drop_down),
              backgroundColor: Colors.blue[50],
              initiallyExpanded: false,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      focusedBorder: OutlineInputBorder(),
                      labelStyle:
                          GoogleFonts.acme(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: contact,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                      focusedBorder: OutlineInputBorder(),
                      labelStyle:
                          GoogleFonts.acme(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: house,
                    decoration: InputDecoration(
                      labelText: 'House Name/ House Number',
                      focusedBorder: OutlineInputBorder(),
                      labelStyle:
                          GoogleFonts.acme(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: street,
                    decoration: InputDecoration(
                      labelText: 'Street Name',
                      focusedBorder: OutlineInputBorder(),
                      labelStyle:
                          GoogleFonts.acme(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: city,
                    decoration: InputDecoration(
                      labelText: 'City',
                      focusedBorder: OutlineInputBorder(),
                      labelStyle:
                          GoogleFonts.acme(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: district,
                    decoration: InputDecoration(
                      labelText: 'District',
                      focusedBorder: OutlineInputBorder(),
                      labelStyle:
                          GoogleFonts.acme(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: pincode,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Pin code',
                      focusedBorder: OutlineInputBorder(),
                      labelStyle:
                          GoogleFonts.acme(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (name.text.isNotEmpty &&
                          contact.text.isNotEmpty &&
                          house.text.isNotEmpty &&
                          street.text.isNotEmpty &&
                          city.text.isNotEmpty &&
                          district.text.isNotEmpty &&
                          pincode.text.isNotEmpty) {
                        setState(() {
                          addAddress();
                        });
                        name.clear();
                        contact.clear();
                        house.clear();
                        street.clear();
                        city.clear();
                        district.clear();
                        pincode.clear();
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Text("fields can't be empty"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Go back"))
                            ],
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(200, 50)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueGrey)),
                    child: Text(
                      "Save Address",
                      style: GoogleFonts.acme(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final addresses = address!.split('*');
                  String selectedaddress = addresses[0];
                  String phone = addresses[1];
                  Navigator.pushNamed(context, 'checkout', arguments: {
                    'address': address == ""
                        ? "Add+New+Address+for delivery"
                        : selectedaddress,
                    'phone': phone,
                    'totalPrice': args['totalPrice'],
                    'quantity': args['quantity'],
                    'Items': args['Items'],
                  });
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueGrey)),
                child: Text(
                  "Done",
                  style: GoogleFonts.acme(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
