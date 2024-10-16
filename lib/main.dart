import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silkspaceclient/Login/Signuppage.dart';
import 'package:silkspaceclient/address/addaddresscart.dart';
import 'package:silkspaceclient/bottomnavigation.dart';
import 'package:silkspaceclient/Category%20Pages/checkout/checkoutpage.dart';
import 'package:silkspaceclient/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: First(),
    routes: {
      'checkout': (context) => Checkoutpage(),
      'cartaddress': (context) => AddAddressCart(),
    },
  ));
}

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  bool finalstate = false;
  Future getloginstate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? state = preferences.getBool('login');
    setState(() {
      finalstate = state!;
    });
  }

  @override
  void initState() {
    getloginstate().whenComplete(
      () {
        if (finalstate == false) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Signup(),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => btmnav(),
              ));
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
