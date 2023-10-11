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
  bool gameIsRunning = false;

  static double birdY = 0;
  double time = 0;
  double height = 0;
  double initialBirdY = birdY;

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

  bool gameShouldRestart = false;

  void jump() {
    setState(() {
      time = 0;
      initialBirdY = birdY;
    });
  }

  bool barrierPassedBird(MyBarrier b) {
    if ((b.x < -0.3) && (b.key.currentState?.counted == false)) {
      b.key.currentState?.counted = true;
      return true;
    }
    return false;
  }

  bool birdIsDead() {
    bool birdHitCeiling = birdY > 1;
    bool birdHitFloor = birdY < -1;
    if (birdHitFloor || birdHitCeiling) {
      return true;
    }
    //get left barrier
    var barrier;
    if (barriers[0].key.currentState!.x < barriers[1].key.currentState!.x) {
      barrier = barriers[0];
    } else {
      barrier = barriers[1];
    }

    var gap = barrier.key.currentState!.gapKey;
    RenderBox gapBox = gap.currentContext!.findRenderObject() as RenderBox;
    Offset gapPosition = gapBox.localToGlobal(Offset.zero);

    RenderBox birdBox =
        bird.key.currentContext!.findRenderObject() as RenderBox;
    Offset birdPosition = birdBox.localToGlobal(Offset.zero);

    bool birdIsBetweenBarriers = (birdPosition.dx + 60 > gapPosition.dx &&
        birdPosition.dx < gapPosition.dx + 100);
    // if (birdIsBetweenBarriers) {
    //   print("gap  bird  gap");
    //   print(gapPosition.dx);
    //   print(birdPosition.dx);
    //   print(gapPosition.dx + 100);
    // }
    bool birdHitUpperBarrier =
        (birdIsBetweenBarriers) && birdPosition.dy < gapPosition.dy;
    if (birdHitUpperBarrier) {
      print("upper");
      print(birdPosition.dy);
      print(gapPosition.dy);
    }
    bool birdHitLowerBarrier = (birdIsBetweenBarriers) &&
        (birdPosition.dy + 60 > gapPosition.dy + 200);
    if (birdHitLowerBarrier) {
      print("lower");
      print(birdPosition.dy + 60);
      print(gapPosition.dy + 200);
    }
    if (birdHitUpperBarrier || birdHitLowerBarrier) return true;
    return false;
  }

  void updateScore() {
    score += 1;
    highscore = highscore < score ? score : highscore;
  }

  void startGame() {
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
        gameShouldRestart = true;
      }

      barriers.forEach((barrier) {
        if (barrier.key.currentState!.x < -2) {
          barrier.key.currentState?.relocate();
        } else {
          barrier.key.currentState?.move();
          if (barrierPassedBird(barrier)) {
            updateScore();
          }
        }
        barrier.key.currentState!.setState(() {});
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
              //restartGame();
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
                        child: bird,
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
