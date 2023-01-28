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
  WordGroup calcWord(List<Point> points) {
    if (points.length != wordLength) {
      return WordGroup.nothing();
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
    return WordGroup.sorted(words);
  }
}
