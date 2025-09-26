
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
        title: const Row(
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
    Step(isActive: widget.currentstep >=0,title: const Text("Left silk space facility"), content:const Text("The item has left the silk space godown")),
    Step(isActive: widget.currentstep >=1,title: const Text("Reached nearest hub"), content:const Text("Item reached hub near you")),
    Step(isActive: widget.currentstep >=2,title: const Text("Out for delivery"), content:const Text("Item has left for delivery")),
    Step(isActive: widget.currentstep >=3,title: const Text("Delivered"), content:const Text("The Item has been delivered")),
    Step(isActive: widget.currentstep >=4,title: const Text("Cancelled"), content:const Text("Item has cancelled or returned")),],
      currentStep: widget.currentstep,
      controlsBuilder: (context, details) => const SizedBox(),
      
       ),
    );
  }
}
