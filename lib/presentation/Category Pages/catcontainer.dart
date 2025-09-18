import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Catcontainer extends StatefulWidget {
  const Catcontainer(
      {super.key,
      required this.ontap,
      required this.images,
      required this.txt});
  final VoidCallback ontap;
  final String txt;
  final ImageProvider images;
  @override
  State<Catcontainer> createState() => _CatcontainerState();
}

class _CatcontainerState extends State<Catcontainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueAccent,
      body: Center(
        child: GestureDetector(
          onTap: widget.ontap,
          child: Container(
            height: 250,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: widget.images,
                    // alignment: Alignment.bottomCenter,
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black87.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ]),
            child: Center(
              child: Text(
                widget.txt,
                style: GoogleFonts.sansita(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset(0, 2))
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
