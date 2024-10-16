import 'package:flutter/material.dart';
import 'package:silkspaceclient/Category%20Pages/catcontainer.dart';
import 'package:silkspaceclient/product/productslist.dart';

class Categoriespage extends StatefulWidget {
  const Categoriespage({super.key});

  @override
  State<Categoriespage> createState() => _CategoriespageState();
}

List category = [
  {
    "text": "Under\nSkirt",
    "imgs": "lib/images/underskirt.jpg",
    "page": "under skirt"
  },
  {"text": "Lining", "imgs": "lib/images/lining.jpg", "page": 'lining'},
  {"text": "Crepe", "imgs": "lib/images/crepe.jpg", "page": 'crepe'},
  {
    "text": "Shape\nwear",
    "imgs": "lib/images/shapewear.jpg",
    "page": 'shape wear'
  },
  {"text": "Satin", "imgs": "lib/images/satin.jpg", "page": 'satin'},
  {"text": "Leggings", "imgs": "lib/images/leggings.jpg", "page": 'leggings'},
  {"text": "Shawl", "imgs": "lib/images/shawl.jpg", "page": 'shawl'},
  {"text": "Running", "imgs": "lib/images/runnings.jpg", "page": 'running'},
];

class _CategoriespageState extends State<Categoriespage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5,
          shadowColor: Colors.black,
          backgroundColor: Colors.blue,
          title: Row(
            children: [
              Text(
                "Categories",
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
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: GridView.builder(
            itemCount: category.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return Catcontainer(
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Productslist(category: category[index]['page']),
                        ));
                  },
                  images: AssetImage(category[index]["imgs"]),
                  txt: category[index]["text"]);
            },
          ),
        ));
  }
}
