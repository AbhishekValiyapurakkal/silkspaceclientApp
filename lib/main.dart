import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silkspaceclient/presentation/Login/Signuppage.dart';
import 'package:silkspaceclient/presentation/address/addaddresscart.dart';
import 'package:silkspaceclient/presentation/bottomnavigation.dart';
import 'package:silkspaceclient/presentation/checkout/checkoutpage.dart';
import 'package:silkspaceclient/api_services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const First(),
    routes: {
      'checkout': (context) => const Checkoutpage(),
      'cartaddress': (context) => const AddAddressCart(),
    },
  ));
}

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  Future<void> getloginstate() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool? state = preferences.getBool('login');

  if (state == false || state == null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Signup()),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const btmnav()),
    );
  }
}

@override
void initState() {
  super.initState();
  getloginstate();
}


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
