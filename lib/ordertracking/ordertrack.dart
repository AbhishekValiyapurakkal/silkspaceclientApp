import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Ordertrack extends StatefulWidget {
final int currentstep;
  const Ordertrack({super.key, required this.currentstep});

  @override
  State<Ordertrack> createState() => _OrdertrackState();
}

  List <Step> steps =[
    
    ];
    
class _OrdertrackState extends State<Ordertrack> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 5,
        shadowColor: Colors.black,
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Text(
              "Track your order",
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
      body: Stepper(steps:[
    Step(isActive: widget.currentstep >=0,title: Text("Left silk space facility"), content:Text("The item has left the silk space godown")),
    Step(isActive: widget.currentstep >=1,title: Text("Reached nearest hub"), content:Text("Item reached hub near you")),
    Step(isActive: widget.currentstep >=2,title: Text("Out for delivery"), content:Text("Item has left for delivery")),
    Step(isActive: widget.currentstep >=3,title: Text("Delivered"), content:Text("The Item has been delivered")),
    Step(isActive: widget.currentstep >=4,title: Text("Cancelled"), content:Text("Item has cancelled or returned")),],
      currentStep: widget.currentstep,
      controlsBuilder: (context, details) => SizedBox(),
      
       ),
    );
  }
}
