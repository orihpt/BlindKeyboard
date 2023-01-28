// Contains the dictionary of each word-length.
import 'dart:convert';
import 'dart:math';

import 'package:blind_keyboard/Dictionary/dictionary_wl.dart';
import 'package:blind_keyboard/Dictionary/word_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Other Classes/point.dart';

class LangDictionary {
  // Language Information
  final String language;
  late int _minimumLengthWord;
  late int _maximumLengthWord;
  late bool _hasPrefixes;
  late int _minimumLengthPrefix;
  late int _maximumLengthPrefix;

  // Dictionaries list
  late List<WLDictionary> dict;
  late List<WLDictionary> prefixDict;

  // Is loaded
  bool isLoaded = false;
  ValueNotifier<double> loadProgress = ValueNotifier(0);

  LangDictionary(this.language);

  Future<void> load() async {
    // Load language information
    final String fullPath = "assets/Lang/$language/$language.json";
    final String jsonString = await rootBundle.loadString(fullPath);
    final Map<String, dynamic> data = jsonDecode(jsonString);
    _minimumLengthWord = data["minimumLengthWord"];
    _maximumLengthWord = data["maximumLengthWord"];
    _hasPrefixes = data["hasPrefixes"];
    _minimumLengthPrefix = data["minimumLengthPrefix"];
    _maximumLengthPrefix = data["maximumLengthPrefix"];

    // Make dictionary for regular words
    dict = [];
    for (int i = _minimumLengthWord; i <= _maximumLengthWord; i++) {
      final WLDictionary dictionary = WLDictionary(i, language, "mat");
      await dictionary.makeTree();
      dict.add(dictionary);
      loadProgress.value = 0.9 *
          (i - _minimumLengthWord) /
          (_maximumLengthWord - _minimumLengthWord);
    }

    // Make dictionary for prefixes
    if (_hasPrefixes) {
      prefixDict = [];
      for (int i = _minimumLengthPrefix; i <= _maximumLengthPrefix; i++) {
        final WLDictionary dictionary = WLDictionary(i, language, "prefix");
        await dictionary.makeTree();
        prefixDict.add(dictionary);
        loadProgress.value = 0.1 *
                (i - _minimumLengthPrefix) /
                (_maximumLengthPrefix - _minimumLengthPrefix) +
            0.9;
      }
    }

    loadProgress.value = 1;
    isLoaded = true;
    print("Loaded $language dictionary");
  }

  // Calc word from points
  WordGroup calcWord(List<Point> points, {bool allowPrefix = true}) {
    // Check if dictionary is loaded
    if (!isLoaded) {
      // Flutter warning
      print("WARNING: Dictionary is not loaded.");
      return WordGroup.nothing();
    }

    if (points.length < _minimumLengthWord) {
      return WordGroup.nothing();
    }

    // Get word length
    final int wordLength = points.length;

    // Get dictionary
    final WLDictionary dictionary = dict[wordLength - _minimumLengthWord];

    // Get word
    final WordGroup word = dictionary.calcWord(points);

    List<WordGroup> words = [word];

    // Prefixes
    if (allowPrefix &&
        _hasPrefixes &&
        wordLength - _minimumLengthWord - _minimumLengthPrefix >= 0) {
      // This code section tries to find the best prefix for the word
      // If there is enough confidence in the prefix, it will add it to the words list
      for (int i = _minimumLengthPrefix;
          i <= min(_maximumLengthPrefix, wordLength - _minimumLengthWord);
          i++) {
        final WLDictionary prefixDictionary =
            prefixDict[i - _minimumLengthPrefix];
        final WordGroup prefix =
            prefixDictionary.calcWord(points.sublist(0, i));
        if (prefix.getWord().dist == null) {
          continue;
        }

        final WordGroup afterPrefixWord =
            calcWord(points.sublist(i, points.length), allowPrefix: false);
        if (afterPrefixWord.getWord().dist == null) {
          continue;
        }

        final WordGroup combinedWord =
            WordGroup.combine(prefix, afterPrefixWord);
        words.add(combinedWord);
      }
    }

    WordGroup bestWord = WordGroup.flatWordsList(words);

    return bestWord;
  }
}
