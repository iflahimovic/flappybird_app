import 'dart:async';
import 'barriers.dart';
import 'package:flappybird_app/bird.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


/*
Für Restart: erkennen, wenn Vogel unterhalb der Grenze. Wenn das Eintritt, dann Vogel auf 0 Setzen.

*/
class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 2;
  double barrierXtwo = barrierXone + 1.7; // hier wird der abstand zwischen den Barrieren bestimmt

  int gapSizeForBird = 150;
  int bufferForBarrierVisualization = 30;
  int barrierOneHeightTop = 150;
  int barrierOneHeightBottom = 250;
  int barrierTwoHeightTop = 200;
  int barrierTwoHeightBottom = 200;

  int score = 0;
  int highscore = 0;//theoretisch nh Datenbank dran hängen, um auch nach Spiel Beendigung wieder Highscore anzeigen zu können
  bool barrierOneCounted = false;
  bool barrierTwoCounted = false;


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
        int randomHeight = Random().nextInt(340);
        barrierOneHeightTop = randomHeight + bufferForBarrierVisualization;
        barrierOneHeightBottom = 550 - randomHeight - gapSizeForBird;

        barrierOneCounted = false;//Barriere wurde versetzt und darf wieder gezählt werden
        //550-150= 400 - 60(30 oben und 30 unten) = 340
      }else{
        barrierXone -= 0.05;

        //Barriere One ist am Vogel vorbei und muss hochgezählt werden
        if((barrierXone < -0.3) & (barrierOneCounted == false)){
          score += 1;
          barrierOneCounted = true;

          //neuer Highscore?
          highscore = highscore < score ? score : highscore;
        }
      }

      if(barrierXtwo < -2){//wenn Barriere links aus dem Bild raus, schiebe die Barriere auf die rechte Seite des Bildschirmes -> andernfalls mach einfach weiter
        barrierXtwo += 3.5;
        int randomHeight = Random().nextInt(340);
        barrierTwoHeightTop = randomHeight + bufferForBarrierVisualization;
        barrierTwoHeightBottom = 550 - randomHeight - gapSizeForBird;

        barrierTwoCounted = false;//Barriere wurde versetzt und darf wieder gezählt werden

      }else{
        barrierXtwo -= 0.05;

        //Barriere Two ist am Vogel vorbei und muss hochgezählt werden
        if((barrierXtwo < -0.3) & (barrierTwoCounted == false)){
          score += 1;
          barrierTwoCounted = true;
          //neuer Highscore?
          highscore = highscore < score ? score : highscore;
        }
      }



      /* Funktionen, dass das Spiel beendet wird, wenn der Vogel oben oder unten aus dem Bild geht
      if (birdYaxis > 1.2) {
        timer.cancel();
        gameHasStarted = false;
      }
      if(birdYaxis < -1.2){
        timer.cancel();
        gameHasStarted = false;
      }*/

      //blablacar
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
                      size: barrierOneHeightTop + 0.0,
                    )
                ),
                AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: barrierOneHeightBottom + 0.0,
                    )
                ),
                AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: barrierTwoHeightTop + 0.0,
                    )
                ),
                AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: barrierTwoHeightBottom + 0.0,
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
                      Text(score.toString(), style: TextStyle(color: Colors.white, fontSize: 35)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Highscore", style: TextStyle(color: Colors.white, fontSize: 20)),
                      SizedBox(height: 20),
                      Text(highscore.toString(), style: TextStyle(color: Colors.white, fontSize: 35)),
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
