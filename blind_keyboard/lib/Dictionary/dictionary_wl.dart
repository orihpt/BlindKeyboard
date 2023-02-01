import 'dart:convert';

import 'package:blind_keyboard/Dictionary/word.dart';
import 'package:blind_keyboard/Dictionary/word_group.dart';
import 'package:flutter/services.dart';
import 'package:kdtree/kdtree.dart';
import 'package:csv/csv.dart';

import '../Other Classes/point.dart';

// Contains the words for a specific word-length.
class WLDictionary {
  late final int wordLength;
  late final String source;
  late final String wordsSource;
  final String language;
  late KDTree tree;
  late final WordType _type;

  // The aspect ratio of the keyboard: width/height
  double aspectRatio = 1.0;

  // words
  List<String> words = [];

  // Initialize dictionary
  // Please call makeTree() after initializing the dictionary.
  //
  // Type = "mat" for regular words, "prefix" for prefixes.
  WLDictionary(this.wordLength, this.language, this._type) {
    source =
        "assets/Lang/$language/${dirNameForWordType(_type)}/tree_$wordLength.json";
    wordsSource =
        "assets/Lang/$language/${dirNameForWordType(_type)}/words_$wordLength.json";
  }

  Future<void> makeTree() async {
    // Import tree from the json file.
    final String str = await rootBundle.loadString(source);
    final Map<String, dynamic> json = jsonDecode(str);

    // Import words from the json file.
    final String strWords = await rootBundle.loadString(wordsSource);
    final List<dynamic> wordsListDynamic = jsonDecode(strWords);
    words = wordsListDynamic.map((e) => e.toString()).toList();

    // Create distance function
    distance(lhs, rhs) {
      var sum = 0.0;
      for (int i = 0; i < wordLength; i++) {
        var iStr = i.toString();
        var x1 = lhs['x$iStr'] * aspectRatio;
        var y1 = lhs['y$iStr'];
        var x2 = rhs['x$iStr'] * aspectRatio;
        var y2 = rhs['y$iStr'];

        sum += (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
      }
      return sum;
    }

    // Create tree
    tree = KDTree.fromJson(json);
    tree.metric = distance;

    print(
        "Done creating tree for $_type with $wordLength letter words in $language");
  }

  // Calculate word from points
  WordGroup calcWord(List<Point> points, {double? aspectRatio}) {
    // hello	0.6	0.125	0.272727272727273	0	0.9	0.125	0.9	0.125	0.818181818181818	0
    if (points.length != wordLength) {
      return WordGroup.nothing();
    }

    // Set aspect ratio
    if (aspectRatio != null) {
      this.aspectRatio = aspectRatio;
    }

    // Create map from points
    final Map<String, dynamic> map = {"i": -1};
    for (int i = 0; i < wordLength; i++) {
      var iStr = i.toString();
      map['x$iStr'] = points[i].x;
      map['y$iStr'] = points[i].y;
    }

    // Find nearest word
    final nearest = tree.nearest(map, 7);
    List<Word> wordsList = [];
    for (int i = 0; i < nearest.length; i++) {
      var row = nearest[i];
      double dist = row[1];
      int wordIndex = row[0]["i"];
      String wordStr = words[wordIndex];

      wordsList.add(Word(wordStr, dist));
    }

    // Return word
    return WordGroup.sorted(wordsList);
  }
}

enum WordType { mat, prefix }

String dirNameForWordType(WordType wordType) {
  switch (wordType) {
    case WordType.mat:
      return "words";
    case WordType.prefix:
      return "prefixes";
  }
}
