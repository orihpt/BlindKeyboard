// Contains the dictionary of each word-length.
import 'package:blind_keyboard/Dictionary/dictionary_wl.dart';

import '../Other Classes/point.dart';

class LangDictionary {
  final String language;

  // Dictionaries list
  late List<WLDictionary> dict;

  LangDictionary(this.language) {
    makeDict();
  }

  Future<void> makeDict() async {
    dict = [];
    for (int i = 2; i <= 18; i++) {
      dict.add(WLDictionary(i, language));
    }
  }

  // Calc word from points
  String calcWord(List<Point> points) {
    if (points.length < 2) {
      return '*';
    }

    // Get word length
    final int wordLength = points.length;

    // Get dictionary
    final WLDictionary dictionary = dict[wordLength - 2];

    // Get word
    final String word = dictionary.calcWord(points);

    return word;
  }
}
