import 'dart:async';
import 'dart:math';
import 'barriers.dart';
import 'package:flappybird_app/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/*
Für Restart: erkennen, wenn Vogel unterhalb der Grenze. Wenn das Eintritt, dann Vogel auf 0 Setzen.

*/
class _HomePageState extends State<HomePage> {
  resetGame() {
    // the app needs to restart
    setState(() {
      birdY = 0;
      initialBirdY = 0;
      time = 0;
      height = 0;
      barriers = <MyBarrier>[
        MyBarrier(
            key: GlobalKey(),
            x: 2,
            upperBarrierHeight: Random().nextInt(100),
            lowerBarrierHeight: 100 - Random().nextInt(100)),
        MyBarrier(
            key: GlobalKey(),
            x: 3.7,
            upperBarrierHeight: Random().nextInt(100),
            lowerBarrierHeight: 100 - Random().nextInt(100))
      ];
      score = 0;
    });
  }

  double birdAngle = 0;
  bool gameIsRunning = false;
  double birdY = 0;
  double initialBirdY = 0;
  double time = 0;
  double height = 0;

  var barriers = <MyBarrier>[
    MyBarrier(
        key: GlobalKey(), x: 2, upperBarrierHeight: 30, lowerBarrierHeight: 40),
    MyBarrier(
        key: GlobalKey(),
        x: 3.7,
        upperBarrierHeight: 50,
        lowerBarrierHeight: 20)
  ];
  var bird = MyBird();
  int score = 0;
  //theoretisch nh Datenbank dran hängen, um auch nach Spiel Beendigung wieder Highscore anzeigen zu können
  int highscore = 0;

  void jump() {
    if (!gameIsRunning) startGame();
    setState(() {
      time = 0;
      initialBirdY = birdY;
    });
  }

  bool birdIsDead() {
    //check if bird hit ceiling or floor
    bool birdHitCeiling = birdY > 1;
    bool birdHitFloor = birdY < -1;
    if (birdHitFloor || birdHitCeiling) {
      return true;
    }
    //get left barrier
    var barrier = barriers[0].key.currentState;
    if (barrier!.x < -0.3) {
      barrier = barriers[1].key.currentState;
    }
    //get gapKey from barriers.dart
    var gap = barrier?.gapKey;
    if (gap == null || barrier == null) return false;
    //get position of gap and bird
    RenderBox gapBox = gap.currentContext!.findRenderObject() as RenderBox;
    Offset gapPosition = gapBox.localToGlobal(Offset.zero);

    RenderBox birdBox =
        bird.key.currentContext!.findRenderObject() as RenderBox;
    Offset birdPosition = birdBox.localToGlobal(Offset.zero);
    //check if bird is between barriers
    bool birdIsBetweenBarriers = (gapPosition.dx < birdPosition.dx + 60 &&
        gapPosition.dx + 100 > birdPosition.dx);
    //check if bird hit upper or lower barrier
    if (birdIsBetweenBarriers) {
      // update score if bird passed barrier
      if (!barrier.counted) {
        barrier.counted = true;
        updateScore();
      }
      bool birdHitUpperBarrier = birdPosition.dy < gapPosition.dy;
      bool birdHitLowerBarrier = (birdPosition.dy + 45 > gapPosition.dy + 200);
      return (birdHitUpperBarrier || birdHitLowerBarrier);
    }

    return false;
  }

  void updateScore() {
    score += 1;
    highscore = highscore < score ? score : highscore;
  }

  void startGame() {
    resetGame();
    gameIsRunning = true;

    final timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      time += 0.030;
      //formel für fallgeschwindigkeit
      height = -4.9 * time * time + 2.8 * time;

      setState(() {
        birdY = initialBirdY - height;
      });

      if (birdIsDead()) {
        timer.cancel();
        gameIsRunning = false;
      }

      for (var barrier in barriers) {
        if (barrier.key.currentState!.x < -2) {
          barrier.key.currentState?.relocate();
        } else {
          barrier.key.currentState?.move();
        }
        barrier.key.currentState!.setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (gameIsRunning) {
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
                        alignment: Alignment(0, birdY),
                        duration: const Duration(milliseconds: 0),
                        color: Colors.blue,
                        child: Transform.rotate(
                          angle: birdAngle,
                          child: bird,
                        ),
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
                      barriers[0],
                      barriers[1],
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
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
