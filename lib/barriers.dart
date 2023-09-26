import 'dart:math';

import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final upperPartHeight;
  final lowerPartHeight;
  MyBarrier({this.upperPartHeight, this.lowerPartHeight});

  static double gapSizeForBird = 150;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: upperPartHeight,
          child: Container(
            width: 100,
            decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(width: 10, color: Colors.black),
                borderRadius: BorderRadius.circular(15)),
          ),
        ),
        Container(
          width: 100,
          height: gapSizeForBird,
          color: Colors.yellow,
        ),
        Expanded(
          flex: lowerPartHeight,
          child: Container(
            width: 100,
            decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(width: 10, color: Colors.black),
                borderRadius: BorderRadius.circular(15)),
          ),
        )
      ],
    );
  }
}

class BarrierData {
  BarrierData(double _x, int _upperBarrierHeight, int _lowerBarrierHeight) {
    counted = false;
    x = _x;
    upperBarrierHeight = _upperBarrierHeight;
    lowerBarrierHeight = _lowerBarrierHeight;
  }

  late double x;
  late int upperBarrierHeight;
  late int lowerBarrierHeight;
  late bool counted;

  void relocate() {
    //schiebe die Barriere auf die rechte Seite des Bildschirmes
    x += 3.5;

    upperBarrierHeight = Random().nextInt(100);
    lowerBarrierHeight = 100 - lowerBarrierHeight;

    //Barriere wurde versetzt und darf wieder gezählt werden
    counted = false;
  }

  void move() {
    x -= 0.05;
  }

  bool passedBird() {
    if ((x < -0.3) && (counted == false)) {
      counted = true;
      return true;
    }
    return false;
  }
}
