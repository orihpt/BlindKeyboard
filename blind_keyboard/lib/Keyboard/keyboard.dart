import 'dart:isolate';

import 'package:blind_keyboard/Dictionary/dictionary.dart';
import 'package:blind_keyboard/Dictionary/word_group.dart';
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
  WordGroup? _word;
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
  // For more information about the keyboard coordinates, check the repo documentation.
  void click(double x, double y) {
    // Add point to points list
    wordPoints.add(Point(x, y));

    wordUpdated();
  }

  void addSpace({double? keyboardAspectRatio}) {
    typer.space(keyboardAspectRatio: keyboardAspectRatio);
    _word = WordGroup.nothing();
    wordPoints = [];
  }

  // Backspace
  void backspace() {
    // Remove last point
    if (wordPoints.isNotEmpty) {
      wordPoints.removeLast();

      wordUpdated();
    } else {
      typer.removeLastWord();
    }
  }

  // Clear word
  void clearWord() {
    _word = WordGroup.nothing();
    wordPoints = [];
    wordUpdated();
  }

  // # Word Calculations

  // Word Calculation
  void calcWord({double? aspectRatio}) {
    // Get word from dictionary
    _word = dictionary.calcWord(wordPoints, aspectRatio: aspectRatio);

    wordUpdated();
  }

  // # Keyboard APIs

  // Get word
  WordGroup? getWord() {
    if (wordPoints.isEmpty) {
      return null;
    }
    if (_word == null || _word!.isEmpty()) {
      return WordGroup.toBeCalculated(wordPoints.length);
    }
    return _word;
  }

  // Is typing
  bool isTyping() {
    return wordPoints.isNotEmpty;
  }

  void wordUpdated() {
    typer.wordUpdatedAtKeyboard(keyboard: this);
  }

  void unload() {
    loadingProgress.value = 0;
    dictionary.unload();
  }

  void load() {
    dictionary.load();
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
