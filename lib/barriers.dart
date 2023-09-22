import 'dart:math';

import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final height;
  MyBarrier({this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: height,
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 10, color: Colors.black),
          borderRadius: BorderRadius.circular(15)),
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

  static int bufferForBarrierVisualization = 30;
  static int gapSizeForBird = 150;

  late double x;
  late int upperBarrierHeight;
  late int lowerBarrierHeight;
  late bool counted;

  void relocate() {
    //schiebe die Barriere auf die rechte Seite des Bildschirmes
    x += 3.5;
    int randomHeight = Random().nextInt(340);
    upperBarrierHeight = randomHeight + bufferForBarrierVisualization;
    lowerBarrierHeight = 550 - randomHeight - gapSizeForBird;

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
