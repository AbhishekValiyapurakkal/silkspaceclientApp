import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:silkspaceclient/presentation/Category%20Pages/Categoriespage.dart';
import 'package:silkspaceclient/presentation/home/Homepage.dart';
import 'package:silkspaceclient/presentation/profile/Youpage.dart';
import 'package:silkspaceclient/presentation/cart/cartpage.dart';

class btmnav extends StatefulWidget {
  const btmnav({super.key});

  @override
  State<btmnav> createState() => _btmnavState();
}

class _btmnavState extends State<btmnav> {
  int currentindex = 0;

  List screens = [Homepage(), Categoriespage(), Cartpage(), Youpage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentindex],
      bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.circle,
          padding: EdgeInsets.symmetric(horizontal: 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          backgroundColor: Colors.blue.shade500,
          elevation: 50,
          currentIndex: currentindex,
          onTap: (value) {
            setState(() {
              currentindex = value;
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.blue.shade900,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_rounded), label: 'Categories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}
