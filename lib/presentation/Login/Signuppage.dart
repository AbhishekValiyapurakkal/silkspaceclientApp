import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silkspaceclient/presentation/Login/Loginpage.dart';
import 'package:silkspaceclient/presentation/buttons/buttons.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController email = TextEditingController();

  bool isobsecure = true;
  bool isobsecure2 = true;

  Future Signup() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool('login', true);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Loginpage(),
          ));
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("ALERT !"),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: const Text("OK"))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                  height: 110,
                  width: 100,
                  //color: Colors.blue,
                  child: const Center(
                      child: Image(
                    image: AssetImage("lib/images/Designer.png"),
                    fit: BoxFit.fill,
                  ))),
              SizedBox(
                height: 80,
                width: 300,
                //color: Colors.blue,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Sign up",
                        style: GoogleFonts.merriweather(
                            fontWeight: FontWeight.w600,
                            fontSize: 35,
                            shadows: [
                              const Shadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 5)
                            ]),
                      ),
                      const Text(
                        "Create your account",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    fillColor: Colors.grey,
                    prefixIcon: const Icon(Icons.person),
                    labelText: 'Username/email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: password,
                        obscureText: isobsecure,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.grey,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isobsecure = !isobsecure;
                                });
                              },
                              icon: Icon(isobsecure
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: confirmpassword,
                        obscureText: isobsecure2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.grey,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isobsecure2 = !isobsecure2;
                                });
                              },
                              icon: Icon(isobsecure2
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          labelText: 'Confirm password',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              elvbtn(
                  txt: "Sign Up",
                  ontap: () {
                    if (email.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext) => AlertDialog(
                                content: Text(
                                  "username is empty",
                                  style: TextStyle(
                                      color: Colors.red[800],
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ));
                    } else if (password.text != confirmpassword.text) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(
                            "Password is not equal to confirmed password",
                            style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }
                    Signup();
                  },
                  height: 50,
                  width: 220),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text("Already have an account?"),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Loginpage(),
                            ));
                      },
                      child: const Text("Login"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
