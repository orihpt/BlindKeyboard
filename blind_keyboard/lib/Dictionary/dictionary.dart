// Contains the dictionary of each word-length.
import 'dart:convert';
import 'dart:math';

import 'package:blind_keyboard/Dictionary/dictionary_wl.dart';
import 'package:blind_keyboard/Dictionary/word.dart';
import 'package:csv/csv.dart';
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

  LangDictionary(this.language) {
    load();
  }

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
    }

    // Make dictionary for prefixes
    if (_hasPrefixes) {
      prefixDict = [];
      for (int i = _minimumLengthPrefix; i <= _maximumLengthPrefix; i++) {
        final WLDictionary dictionary = WLDictionary(i, language, "prefix");
        await dictionary.makeTree();
        prefixDict.add(dictionary);
      }
    }

    isLoaded = true;
    print("Loaded $language dictionary");
  }

  // Calc word from points
  Word calcWord(List<Point> points, {bool allowPrefix = true}) {
    // Check if dictionary is loaded
    if (!isLoaded) {
      return Word("*", null, []);
    }

    if (points.length < 2) {
      return Word("*", null, []);
    }

    // Get word length
    final int wordLength = points.length;

    // Get dictionary
    final WLDictionary dictionary = dict[wordLength - _minimumLengthWord];

    // Get word
    final Word word = dictionary.calcWord(points);

    List<Word> words = [word];

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
        final Word prefix = prefixDictionary.calcWord(points.sublist(0, i));

        if (prefix.dist == null) {
          continue;
        }

        final Word afterPrefixWord =
            calcWord(points.sublist(i, points.length), allowPrefix: false);
        if (afterPrefixWord.dist == null) {
          continue;
        }

        // Calculate confidence
        final double dist = prefix.dist! + afterPrefixWord.dist!;

        print("${prefix.word}+${afterPrefixWord.word}");

        final Word newWord = Word(prefix.word + afterPrefixWord.word, dist, []);
        words.add(newWord);
      }
    }

    Word bestWord = Word.getBestWord(words);

    return bestWord;
  }
}
