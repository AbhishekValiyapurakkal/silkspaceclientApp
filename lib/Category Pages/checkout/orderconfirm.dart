import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:silkspaceclient/bottomnavigation.dart';

class OrderConfirmed extends StatefulWidget {
  const OrderConfirmed({super.key});

  @override
  State<OrderConfirmed> createState() => _OrderConfirmedState();
}

class _OrderConfirmedState extends State<OrderConfirmed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Lottie.asset('assets/animation.json'),
          ),
          SizedBox(height: 50),
          MaterialButton(
            animationDuration: Duration(seconds: 10),
            autofocus: true,
            color: Colors.blueGrey,
            height: 60,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => btmnav(),
                  ));
            },
            child: Text(
              "Continue Shopping",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
