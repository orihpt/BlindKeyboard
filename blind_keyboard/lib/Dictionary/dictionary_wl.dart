import 'package:blind_keyboard/Dictionary/word.dart';
import 'package:blind_keyboard/Dictionary/words.dart';
import 'package:blind_keyboard/Keyboard/keyboard.dart';
import 'package:blind_keyboard/Keyboard/keyboard_layout.dart';
import 'package:flutter/services.dart';
import 'package:kdtree/kdtree.dart';
import 'package:csv/csv.dart';

import '../Other Classes/point.dart';

// Contains the words for a specific word-length.
class WLDictionary {
  late final int wordLength;
  late final String source;
  final String language;
  late KDTree tree;
  late final String _type;

  // words
  List<String> words = [];

  // Initialize dictionary
  // Please call makeTree() after initializing the dictionary.
  //
  // Type = "mat" for regular words, "prefix" for prefixes.
  WLDictionary(this.wordLength, this.language, this._type) {
    switch (_type) {
      case "mat":
        source = "assets/Lang/$language/matrixes/mat_$wordLength.csv";
        break;
      case "prefix":
        source = "assets/Lang/$language/prefixes/prefix_$wordLength.csv";
        break;
      default:
        throw Exception("Invalid type: $_type");
    }
  }

  Future<void> makeTree() async {
    // Import tree from matricies.

    // Matrices are saved at "assets/Lang/he/mat_(this.wordLength).csv"
    // The csv is in the following format:
    // word, mat_1, mat_2, ...
    // word => The word that the line represents (String).
    // mat_1 => The x of the first point in the word => (1,1) (double).
    // mat_2 => The y of the first point in the word => (2,1) (double).
    // mat_3 => The x of the second point in the word => (1,2) (double).
    // and so on...

    // Read from the csv file.

    final String fullPath = source;
    final String csvString = await rootBundle.loadString(fullPath);
    final List<List<dynamic>> data =
        const CsvToListConverter().convert(csvString);

    final List<Map<String, dynamic>> map = [];
    for (int i = 1; i < data.length; i++) {
      final row = data[i];
      final Map<String, dynamic> mapRow = {"i": i - 1};
      words.add(row[0]);
      for (int j = 0; j < wordLength; j++) {
        var jStr = j.toString();
        mapRow['x$jStr'] = row[j * 2 + 1];
        mapRow['y$jStr'] = row[j * 2 + 2];
      }
      map.add(mapRow);
    }

    // Dimentions is the list of keys in the map
    final List<String> dimensions = ["i"];
    for (int i = 0; i < wordLength; i++) {
      var iStr = i.toString();
      dimensions.add('x$iStr');
      dimensions.add('y$iStr');
    }

    // Create distance function
    distance(lhs, rhs) {
      var sum = 0.0;
      for (int i = 0; i < wordLength; i++) {
        var iStr = i.toString();
        var x1 = lhs['x$iStr'];
        var y1 = lhs['y$iStr'];
        var x2 = rhs['x$iStr'];
        var y2 = rhs['y$iStr'];
        sum += (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
      }
      return sum;
    }

    // Create tree
    // Create a new tree from a list of points, a distance function, and a
    tree = KDTree(map, distance, dimensions);

    print(
        "Done creating tree for $_type with $wordLength letter words in $language");
  }

  // Calculate word from points
  Words calcWord(List<Point> points) {
    if (points.length != wordLength) {
      return Words.nothing();
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
    List<Word> words = [];
    for (int i = 0; i < nearest.length; i++) {
      var row = nearest[i];
      double dist = row[1];
      int wordIndex = row[0]["i"];
      String wordStr = this.words[wordIndex];

      words.add(Word(wordStr, dist));
    }

    // Return word
    return Words.sorted(words);
  }

/*
  // Calculate possible prefixes
  void calcPossiblePrefixes() {
    _possiblePrefixes = WLDictionary.possiblePrefixes(language);
    _possiblePrefixesPoints = [];
    KeyboardLayout layout = KeyboardLayout(language);
    for (var prefix in _possiblePrefixes) {
      _possiblePrefixesPoints.add(layout.wordToPoints(prefix));
    }

    // Create tree from possible prefixes
    final List<Map<String, dynamic>> map = [];
    for (int i = 0; i < _possiblePrefixes.length; i++) {
      final Map<String, dynamic> mapRow = {"i": i};
      for (int j = 0; j < _possiblePrefixesPoints[i].length; j++) {
        var jStr = j.toString();
        mapRow['x$jStr'] = _possiblePrefixesPoints[i][j].x;
        mapRow['y$jStr'] = _possiblePrefixesPoints[i][j].y;
      }
      map.add(mapRow);
    }

    // Dimentions is the list of keys in the map
    final List<String> dimensions = ["i"];
    for (int i = 0; i < _possiblePrefixesPoints[0].length; i++) {
      var iStr = i.toString();
      dimensions.add('x$iStr');
      dimensions.add('y$iStr');
    }

    // Create distance function
    distance(lhs, rhs) {
      var sum = 0.0;
      for (int i = 0; i < _possiblePrefixesPoints[0].length; i++) {
        var iStr = i.toString();
        var x1 = lhs['x$iStr'];
        var y1 = lhs['y$iStr'];
        var x2 = rhs['x$iStr'];
        var y2 = rhs['y$iStr'];
        sum += (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
      }
      return sum;
    }

    // Create tree
    // Create a new tree from a list of points, a distance function, and a
    _possiblePrefixesTree = KDTree(map, distance, dimensions);

    /* 
    טוב עכשיו אני הולך לשחק ביט סייבר אבל בעקרון הרעיון פה הוא שנגיד מילים עם פרפיקס כמו ״כשאמרתי״ יהיו מורכבות מ ״כש״ ו״אמרתי״
    ובעצם נגיד יש מילה עם 7 אותיות אז זה מנסה לחלק אותה ל״כש״ ול״אמרתי״ ואז להתאים את הקונפידנס של ״כש״ עם הקונפידנס של ״אמרתי״
    (הקונפידנס יותאם גם לפי האורך, ככה שהקונפידנס של ״כש״ כפול 2/7 + הקונפידנס של ״אמרתי״ כפול 5/7 יהיה הקונפידנס של ״כשאמרתי״)
    וככה למצוא את המילה עם הקונפידנס הכי גבוה עכשיו לא יודע כמה טוב זה יעבוד
    אבל בכל מקרה זה עדיף מלטעון פאקינג 800 מגה של  מילים כל פעם
    וזה יעבוד גם עם מילים שאין להן פרפיקס כמו ״אמרתי״
    קיצר שיהיה לי בהצלחה מחר בבגרות בהיסטוריה, הלכתי לשחק ביט סייבר, ביי!
    */
  }

  // # Static functions for languages

  // Possible Prefixes
  static List<String> possiblePrefixes(languageCode) {
    switch (languageCode) {
      case 'he':
        return [
          "כ",
          "ל",
          "ש",
          "ו",
          "כש",
          "מ",
          "ב",
          "ה",
          "כשה",
          "מה",
          "לכ",
          "שה",
          "מש"
        ];
      case 'en':
        return [];
      default:
        return [];
    }
  }*/
}
