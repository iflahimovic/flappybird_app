import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  @override
  GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.asset(
      'lib/images/flappybird.png',
      width: 60,
    ));
  }
}
