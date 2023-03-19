import 'dart:async';

import 'package:app/buttons.dart';
import 'package:app/missile.dart';
import 'package:app/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //player variables
  static double playerX = 0;

  //Missile variable
  double missileX = playerX;

  double missileHeight = 10;

  bool midShot = false;

  void moveLeft() {
    setState(() {
      // playerX = playerX - 0.1;
      missileX = playerX;
      if (playerX - 0.1 < -1) {
        //do nothing
      } else {
        playerX -= 0.1;
      }
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      // playerX += 0.1;
      missileX = playerX;
      if (playerX + 0.1 > 1) {
        //do nothing
      } else {
        playerX += 0.1;
      }
      missileX = playerX;
    });
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(Duration(milliseconds: 20), (timer) {
        // shots fired
        midShot = true;

        //missile grows til it hits the top of the screen
        setState(() {
          missileHeight += 10;
        });
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          //stop missile
          restMissile();
          timer.cancel();
          midShot = false;
        }
      });
    }
  }

  void restMissile() {
    missileX = playerX;
    missileHeight = 10;
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.pink[100],
                child: Center(
                  child: Stack(
                    children: [
                      MyMissile(
                        height: missileHeight,
                        missileX: missileX,
                      ),
                      MyPlayer(
                        playerX: playerX,
                      ),
                    ],
                  ),
                ),
              )),
          Expanded(
              child: Container(
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                  icon: Icons.arrow_back,
                  function: moveLeft,
                ),
                MyButton(
                  icon: Icons.arrow_upward,
                  function: fireMissile,
                ),
                MyButton(
                  icon: Icons.arrow_forward,
                  function: moveRight,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
