import 'package:flutter_web/material.dart';
import 'dart:math';
// Color getRandomColor(){
//   var r = Random().nextInt(256),g = Random().nextInt(256), b = Random().nextInt(256);
//   return Color.fromARGB(255, r, g, b);
// }

Color getRandomColor(){
  var r = Random().nextInt(200),g = Random().nextInt(200), b = Random().nextInt(200);
  return Color.fromARGB(255, r, g, b);
}