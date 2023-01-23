import 'package:blind_keyboard/Other%20Classes/point.dart';
import 'package:blind_keyboard/Typer/typer.dart';
import 'package:flutter/foundation.dart';

import 'keyboard_layout.dart';

// Keyboard is the class that holds the keyboard layout and the language code.
// It also holds the word that is currently being typed.
class Keyboard {
  late KeyboardLayout layout;
  late String languageCode;

  late Typer typer;

  // The word that is currently being typed.
  String _word = '';
  List<Point> wordPoints = [];

  Keyboard(String language, this.typer) {
    layout = KeyboardLayout(language);
    languageCode = language;
  }

  // # Keyboard Interactions

  // Click on keyboard
  //
  // Please notice that the x,y coordinates are relative to the keyboard.
  // The keyboard is MxN matrix, where M is the number of rows and N is the length of the longest row.
  // For example in English keyboard:
  // - (0,0) is Q
  // - (0,1) is W
  // - ()
  // For more information about the keyboard coordinates, check the repo documentation.
  void click(double x, double y) {
    // Add point to points list
    wordPoints.add(Point(x, y));
    calcWord();
  }

  // # Word Calculations

  // Word Calculation
  void calcWord() {
    _word = wordPoints.toString();

    // Notify typer
    typer.wordUpdatedAtKeyboard(keyboard: this);
  }

  // # Keyboard APIs

  // Get word
  String getWord() {
    return _word;
  }
}
