import '../Other Classes/point.dart';

class KeyboardLayout {
  late final List<List<String>> layout;

  late final String languageCode;

  // Initializer that get language as string.
  KeyboardLayout(String language) {
    languageCode = language;
    // Switch language
    switch (language) {
      case 'he':
        layout = [
          ['ק', 'ר', 'א', 'ט', 'ו', 'ן', 'ם', 'פ'],
          ['ש', 'ד', 'ג', 'כ', 'ע', 'י', 'ח', 'ל', 'ך', 'ף'],
          ['ז', 'ס', 'ב', 'ה', 'נ', 'מ', 'צ', 'ת', 'ץ']
        ];
        break;
      case 'en':
        layout = [
          ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
          ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
          ['z', 'x', 'c', 'v', 'b', 'n', 'm']
        ];
        break;
      default:
        throw Exception('Language not supported');
    }
  }

  // Get point for a letter
  Point letterToPoint(String letter) {
    /*
    This is a matlab code that enters the points of each letter into a dictionary M.

    keyboardLayout = "קראטוןםפ,שדגכעיחלךף,זסבהנמצתץ";
lang = "he";
langLettersRegex = "א-ת";
wordsFile = "wordslist.txt";

% Code
w = readlines(wordsFile);

keyboard = split(keyboardLayout, ",");
rowsLengths = strlength(keyboard);
M = containers.Map('KeyType','char','ValueType','any');

% Calculate point for each letter
for i = 1:numel(keyboard)
    row = split(keyboard(i), "")';
    row = row(2:end-1);
    rowLen = numel(row);
    for j = 1:rowLen
        letter = row(j);
        M(letter) = [j/(rowLen+1), i-1];
    end
end
    */

    // Find the letter in the layout
    for (int i = 0; i < layout.length; i++) {
      for (int j = 0; j < layout[i].length; j++) {
        if (layout[i][j] == letter) {
          return Point(j / (layout[i].length + 1), i.toDouble());
        }
      }
    }

    throw Exception('The provided letter is not in the layout');
  }

  // Get points from word
  List<Point> wordToPoints(String word) {
    // Check if word is valid
    if (word.length < 2) {
      throw Exception('Word must be at least 2 letters long');
    }

    // Create list of points
    final List<Point> points = List.filled(word.length, Point(0, 0));

    // Find the letter in the layout
    for (int i = 0; i < layout.length; i++) {
      for (int j = 0; j < layout[i].length; j++) {
        for (int k = 0; k < word.length; k++) {
          if (layout[i][j] == word[k]) {
            points[k] = (Point(j / (layout[i].length + 1), i.toDouble()));
          }
        }
      }
    }

    return points;
  }
}
