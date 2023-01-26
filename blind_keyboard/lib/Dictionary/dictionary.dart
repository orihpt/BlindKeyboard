// Contains the dictionary of each word-length.
import 'package:blind_keyboard/Dictionary/dictionary_wl.dart';
import 'package:blind_keyboard/Dictionary/word.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import '../Other Classes/point.dart';

class LangDictionary {
  final String language;

  // Dictionaries list
  late List<WLDictionary> dict;
  late WLDictionary prefixDict;

  LangDictionary(this.language) {
    makeDict();
  }

  Future<void> makeDict() async {
    await makePrefixesDict();
    dict = [];
    for (int i = 2; i <= 18; i++) {
      final WLDictionary dictionary = WLDictionary(i, language, "mat");
      await dictionary.makeTree();
      dict.add(dictionary);
    }
  }

  // Calc word from points
  Word calcWord(List<Point> points) {
    if (points.length < 2) {
      return Word("*", 0, []);
    }

    // Get word length
    final int wordLength = points.length;

    // Get dictionary
    final WLDictionary dictionary = dict[wordLength - 2];

    // Get word
    final Word word = dictionary.calcWord(points);

    return word;
  }

  // # Prefixes for word
  // In Hebrew, there are prefixes for words, for example:
  // "כש" + "נרוץ" = "כשנרוץ"
  // This code section keeps the prefixes in a list, and a KDTree for fast search.
  // The prefixes are saved at "assets/Lang/he/prefixes.csv"

  Future<void> makePrefixesDict() async {}
}
