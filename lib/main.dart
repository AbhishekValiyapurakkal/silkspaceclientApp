import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:silkspaceclient/presentation/address/addaddresscart.dart';
import 'package:silkspaceclient/presentation/checkout/checkoutpage.dart';
import 'package:silkspaceclient/api_services/firebase_options.dart';
import 'package:silkspaceclient/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home:  const SplashScreen(),
    routes: {
      'checkout': (context) => const Checkoutpage(),
      'cartaddress': (context) => const AddAddressCart(),
    },
  ));
}

