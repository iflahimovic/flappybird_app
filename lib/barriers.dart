import 'dart:math';
import 'package:flutter/material.dart';

class MyBarrier extends StatefulWidget {
  @override
  GlobalKey<MyBarrierState> key = GlobalKey();

  MyBarrier(
      {required this.key,
      required this.x,
      required this.upperBarrierHeight,
      required this.lowerBarrierHeight});
  double x;
  int upperBarrierHeight;
  int lowerBarrierHeight;

  MyBarrierState createState() => new MyBarrierState(
      x: x,
      upperBarrierHeight: upperBarrierHeight,
      lowerBarrierHeight: lowerBarrierHeight);
}

class MyBarrierState extends State<MyBarrier> {
  MyBarrierState(
      {required this.x,
      required this.upperBarrierHeight,
      required this.lowerBarrierHeight});
  double x;
  int upperBarrierHeight;
  int lowerBarrierHeight;
  bool counted = false;
  GlobalKey gapKey = GlobalKey();

  void relocate() {
    //schiebe die Barriere auf die rechte Seite des Bildschirmes
    upperBarrierHeight = Random().nextInt(100);
    lowerBarrierHeight = 100 - upperBarrierHeight;
    x += 3.5;
    //Barriere wurde versetzt und darf wieder gezählt werden
    counted = true;
  }

  void move() {
    x -= 0.030;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      alignment: Alignment(x, 0),
      child: Column(
        children: [
          Expanded(
            flex: upperBarrierHeight,
            child: Container(
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.green,
                border: Border(
                    left: BorderSide(color: Colors.black, width: 10),
                    right: BorderSide(color: Colors.black, width: 10)),
              ),
            ),
          ),
          Container(
            key: gapKey,
            width: 100,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: const Border(
                  top: BorderSide(color: Colors.black, width: 10),
                  bottom: BorderSide(color: Colors.black, width: 10),
                )),
          ),
          Expanded(
            flex: lowerBarrierHeight,
            child: Container(
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.green,
                border: Border(
                    left: BorderSide(color: Colors.black, width: 10),
                    right: BorderSide(color: Colors.black, width: 10)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
