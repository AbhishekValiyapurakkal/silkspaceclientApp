import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:silkspaceclient/presentation/bottomnavigation.dart';

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
          const SizedBox(height: 50),
          MaterialButton(
            animationDuration: const Duration(seconds: 10),
            autofocus: true,
            color: Colors.blueGrey,
            height: 60,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const btmnav(),
                  ));
            },
            child: const Text(
              "Continue Shopping",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
