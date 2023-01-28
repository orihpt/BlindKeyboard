import 'package:blind_keyboard/Dictionary/dictionary.dart';
import 'package:blind_keyboard/Dictionary/words.dart';
import 'package:blind_keyboard/Other%20Classes/point.dart';
import 'package:blind_keyboard/Typer/typer.dart';
import 'package:flutter/material.dart';

import 'keyboard_layout.dart';

// Keyboard is the class that holds the keyboard layout and the language code.
// It also holds the word that is currently being typed.
class Keyboard {
  late KeyboardLayout layout;
  late LangDictionary dictionary;
  late String languageCode;

  late Typer typer;

  // The word that is currently being typed.
  Words _word = Words.nothing();
  List<Point> wordPoints = [];

  // The loading progress of the dictionary.
  ValueNotifier<double> loadingProgress = ValueNotifier<double>(0);

  Keyboard(String language, this.typer) {
    layout = KeyboardLayout(language);
    languageCode = language;
    dictionary = LangDictionary(language);
    dictionary.loadProgress.addListener(() {
      loadingProgress.value = dictionary.loadProgress.value;
    });
  }

  // # Keyboard Interactions

  // Click on keyboard
  //
  // Please notice that the x,y coordinates are relative to the keyboard.
  // The keyboard is Mx1 matrix, where M is the number of rows and N is the length of the longest row.
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

  void addSpace() {
    typer.space();
    _word = Words.nothing();
    wordPoints = [];
  }

  // Backspace
  void backspace() {
    // Remove last point
    if (wordPoints.isNotEmpty) {
      wordPoints.removeLast();

      // Calculate word
      calcWord();
    } else {
      typer.removeLastWord();
    }
  }

  // Clear word
  void clearWord() {
    _word = Words.nothing();
    wordPoints = [];
  }

  // # Word Calculations

  // Word Calculation
  void calcWord() {
    // Get word from dictionary
    _word = dictionary.calcWord(wordPoints);

    // Notify typer
    typer.wordUpdatedAtKeyboard(keyboard: this);
  }

  // # Keyboard APIs

  // Get word
  Words? getWord() {
    if (_word.isEmpty()) {
      return null;
    }
    return _word;
  }

  // Next alternative
  bool nextAlternative() {
    if (!_word.nextWord()) {
      return false;
    }

    // Notify typer
    typer.wordUpdatedAtKeyboard(keyboard: this);
    return true;
  }

  // Previous alternative
  bool previousAlternative() {
    if (!_word.previousWord()) {
      return false;
    }

    // Notify typer
    typer.wordUpdatedAtKeyboard(keyboard: this);
    return true;
  }

  // # Static methods

  // Is language RTL
  static bool isRTL(String languageCode) {
    return languageCode == 'he' ||
        languageCode == 'ar' ||
        languageCode == 'fa' ||
        languageCode == 'ur' ||
        languageCode == 'yi';
  }
}
