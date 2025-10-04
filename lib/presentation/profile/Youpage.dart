import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silkspaceclient/presentation/Login/Loginpage.dart';
import 'package:silkspaceclient/presentation/Login/Signuppage.dart';
import 'package:silkspaceclient/presentation/orders/orderspage.dart';
import 'package:silkspaceclient/presentation/wishlist/wishlistpage.dart';

class Youpage extends StatelessWidget {
  const Youpage({super.key});

  @override
  Widget build(BuildContext context) {
    List profile = [
      {"txt": "Your Orders", "page": const Orderspage()},
      {"txt": "Creat new account", "page": const Signup()},
      {"txt": "Whishlist", "page": const Wishlistpage()},
      {"txt": "LogOut"},
    ];
    return Container(
      color: Colors.blue,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 5,
              shadowColor: Colors.black,
              backgroundColor: Colors.blue,
              title: const Row(
                children: [
                  Text(
                    "Silk Space",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        shadows: [
                          Shadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 2)
                        ]),
                  ),
                ],
              ),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.only(top: 100),
              itemCount: profile.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      onTap: () async {
                        if (profile[index]["txt"] == "LogOut") {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: const Text("Do you want to logout ?"),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      preferences.setBool('login', false);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Loginpage(),
                                          ));
                                    },
                                    child: const Text("yes")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                              ],
                            ),
                          );
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => profile[index]["page"],
                              ));
                        }
                      },
                      title: Text(
                        profile[index]["txt"],
                        style: GoogleFonts.modernAntiqua(
                            fontWeight: FontWeight.w900),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => profile[index]["page"],
                                ));
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            weight: 80,
                            size: 25,
                          )),
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }
}
