import 'dart:async';
import 'barriers.dart';
import 'package:flappybird_app/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 2;
  double barrierXtwo = barrierXone + 1.5;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });

      if(barrierXone < -2){//wenn Barriere links aus dem Bild raus, schiebe die Barriere auf die rechte Seite des Bildschirmes -> andernfalls mach einfach weiter
        barrierXone += 3.5;
      }else{
        barrierXone -= 0.05;
      }

      if(barrierXtwo < -2){//wenn Barriere links aus dem Bild raus, schiebe die Barriere auf die rechte Seite des Bildschirmes -> andernfalls mach einfach weiter
        barrierXtwo += 3.5;
      }else{
        barrierXtwo -= 0.05;
      }

      if (birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: MyBird(),
                  ),
                Container(
                  alignment: Alignment(0, -0.3),
                  child: gameHasStarted
                      ? Text(" ")
                      : Text("T A P  T O  P L A Y",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                    ),
                  ),
                ),
                AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 200.0,
                    )
                ),
                AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 200.0,
                    )
                ),
                AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 250.0,
                    )
                ),
                AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 150.0,
                    )
                ),
              ],
            )
          ),
          Container(
            height: 15,
            color: Colors.green,
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Score", style: TextStyle(color: Colors.white, fontSize: 20),),
                      SizedBox(height: 20),
                      Text("0", style: TextStyle(color: Colors.white, fontSize: 35)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Highscore", style: TextStyle(color: Colors.white, fontSize: 20)),
                      SizedBox(height: 20),
                      Text("1", style: TextStyle(color: Colors.white, fontSize: 35)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    )

  );
  }
}
