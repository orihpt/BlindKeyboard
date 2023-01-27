import 'package:blind_keyboard/Dictionary/dictionary.dart';
import 'package:blind_keyboard/Dictionary/word.dart';
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
  Word _word = Word.nothing();
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
    _word = Word.nothing();
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
    _word = Word.nothing();
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
  Word? getWord() {
    if (_word.dist == null) {
      return null;
    }
    return _word;
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
