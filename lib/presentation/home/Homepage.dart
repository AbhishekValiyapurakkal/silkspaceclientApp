import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkspaceclient/presentation/product/sareeproductlist.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List sareelist = [];
  List sareepics = [];

  Future fetchsareecategories() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('sareecategories').get();
      List sarees = querySnapshot.docs.map((doc) => doc['category']).toList();
      setState(() {
        sareelist = sarees;
      });
    } catch (e) {
      print(e);
    }
  }

  Future fetchsareecover() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('sareecategories').get();
      List cover = querySnapshot.docs.map((doc) => doc['cover']).toList();
      setState(() {
        sareepics = cover;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    fetchsareecategories();
    fetchsareecover();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 5,
            shadowColor: Colors.black,
            backgroundColor: Colors.blue,
            title: Row(
              children: [
                Text(
                  "Home Page",
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 80,
                  width: double.infinity,
                  color: Colors.white,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sareelist.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Sareeproductlist(
                                            category: sareelist[index],
                                          ),
                                        ));
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(sareepics[index]),
                                    foregroundImage:
                                        NetworkImage(sareepics[index]),
                                    radius: 30,
                                    backgroundColor: Colors.white12,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(sareelist[index],
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )),
              SizedBox(height: 10),
              CarouselSlider(
                  items: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        height: 260,
                        width: 358,
                        // color: Colors.orange,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              const BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  spreadRadius: 5,
                                  offset: Offset(0, 2))
                            ]),
                        child: const Image(
                          image: AssetImage("lib/images/kuberapattu.jpg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        height: 260,
                        width: 358,
                        //color: Colors.orange,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              const BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  spreadRadius: 5,
                                  offset: Offset(0, 2))
                            ]),
                        child: const Image(
                          image: AssetImage("lib/images/kuberapattu2.jpg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        height: 260,
                        width: 358,
                        //color: Colors.orange,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              const BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black,
                                  spreadRadius: 5,
                                  offset: Offset(0, 2))
                            ]),
                        child: const Image(
                          image: AssetImage("lib/images/kubera-pattu3.jpg"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                  options: CarouselOptions(
                      autoPlay: true,
                      height: 300,
                      animateToClosest: false,
                      viewportFraction: 1.1,
                      enlargeCenterPage: true
                      //aspectRatio: 16 / 9,
                      )),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.5,
                      crossAxisSpacing: 40,
                      mainAxisSpacing: 5),
                  itemCount: sareelist.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Sareeproductlist(
                                    category: sareelist[index],
                                  ),
                                ));
                          },
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                //color: Colors.amber,
                                boxShadow: [
                                  const BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                      spreadRadius: 5)
                                ],
                                image: DecorationImage(
                                    image: NetworkImage(sareepics[index]),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  sareelist[index],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
