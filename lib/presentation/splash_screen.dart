import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silkspaceclient/presentation/Login/Signuppage.dart';
import 'package:silkspaceclient/presentation/bottomnavigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> getloginstate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? state = preferences.getBool('login');

    await Future.delayed(const Duration(seconds: 2));

    if (state == false || state == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Signup()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const btmnav()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    getloginstate();
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 127, 198, 255),
        child: Image.asset("lib/images/logo1.png"),
      ),
    );
  }
}
