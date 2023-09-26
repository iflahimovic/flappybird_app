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
  bool gameIsRunning = false;

  static double birdY = 0;
  double time = 0;
  double height = 0;
  double initialBirdY = birdY;

  var barriers = <BarrierData>[
    BarrierData(2, 55, 45),
    BarrierData(2 + 1.7, 30, 70)
  ];

  int score = 0;
  //theoretisch nh Datenbank dran hängen, um auch nach Spiel Beendigung wieder Highscore anzeigen zu können
  int highscore = 0;

  bool gameShouldRestart = false;

  void jump() {
    setState(() {
      time = 0;
      initialBirdY = birdY;
    });
  }

  bool birdIsDead() {
    bool birdHitCeiling = birdY > 1;
    bool birdHitFloor = birdY < -1;
    bool birdIsBetweenBarriers = barriers[0].x < -0.3 && barriers[0].x > 0;
    // bool birdHitUpperBarrier = birdIsBetweenBarriers && birdY > barriers[0].upperBarrierHeight;
    // bool birdHitLowerBarrier = false;
    if (birdHitFloor || birdHitCeiling) {
      return true;
    }
    return false;
  }

  void updateScore() {
    score += 1;
    highscore = highscore < score ? score : highscore;
  }

  void startGame() {
    gameIsRunning = true;

    final timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.04;
      //formel für fallgeschwindigkeit
      height = -4.9 * time * time + 2.8 * time;

      setState(() {
        birdY = initialBirdY - height;
      });

      if (birdIsDead()) {
        timer.cancel();
        gameIsRunning = false;
      }

      barriers.forEach((barrier) {
        if (barrier.x < -2) {
          barrier.relocate();
        } else {
          barrier.move();
          if (barrier.passedBird()) {
            updateScore();
          }
        }
      });
    });
  }

  restartGame() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (gameIsRunning) {
            if (!gameShouldRestart) {
              jump();
            } else {
              //if gameShouldRestart is true
              restartGame();
            }
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
                        alignment: Alignment(0, birdY),
                        duration: const Duration(milliseconds: 0),
                        color: Colors.blue,
                        child: MyBird(),
                      ),
                      Container(
                        alignment: const Alignment(0, -0.3),
                        child: gameIsRunning
                            ? const Text(" ")
                            : const Text(
                                "T A P  T O  P L A Y",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                      ),
                      AnimatedContainer(
                          alignment: Alignment(barriers[0].x, 0),
                          duration: const Duration(milliseconds: 0),
                          child: MyBarrier(
                            upperPartHeight: barriers[0].upperBarrierHeight,
                            lowerPartHeight: barriers[0].lowerBarrierHeight,
                          )),
                      AnimatedContainer(
                          alignment: Alignment(barriers[1].x, 0),
                          duration: const Duration(milliseconds: 0),
                          child: MyBarrier(
                            upperPartHeight: barriers[1].upperBarrierHeight,
                            lowerPartHeight: barriers[1].lowerBarrierHeight,
                          )),
                    ],
                  )),
              Container(
                height: 15,
                color: Colors.green,
              ),
              Expanded(
                child: Container(
                    color: Colors.brown,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Score",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                const SizedBox(height: 20),
                                Text(score.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 35)),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Highscore",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                const SizedBox(height: 20),
                                Text(highscore.toString(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 35)),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: restartGame(),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          child: const Text("Restart",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
