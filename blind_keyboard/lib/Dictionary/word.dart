class Word {
  // The word.
  late final String word;

  // The distance of the word from the points tapped on keyboard.
  late final double? dist;

  // The alternatives of the word.
  late List<Word> alternatives;

  // If the word is punctuation.
  late bool isPunctuation = false;

  // # Constructors
  Word(this.word, this.dist, this.alternatives);

  Word.alternative(this.word, {this.isPunctuation = true});

  Word.punctuation() {
    word = ".";
    dist = 0;
    alternatives = [Word.alternative(",", isPunctuation: true)];
    isPunctuation = true;
  }

  Word.nothing() {
    word = "";
    dist = null;
    alternatives = [];
  }

  // # Static functions

  // Converts a words list into a string.
  static String wordsListToString(List<Word> words) {
    String str = "";
    for (Word word in words) {
      if (word.isPunctuation) {
        str += word.word;
      } else {
        str += "${word.word} ";
      }
    }

    // If last word is punctuation, remove space
    if (words.isNotEmpty && words.last.isPunctuation) {
      str = str.substring(0, str.length - 1);
    }

    return str;
  }

  static Word getBestWord(List<Word> words) {
    List<Word> alternatives = [];
    Word bestWord = Word.nothing();
    for (Word word in words) {
      if (word.dist == null) {
        continue;
      }
      alternatives.addAll(word.alternatives);
      if (bestWord.dist == null || word.dist! < bestWord.dist!) {
        if (bestWord.dist != null) {
          alternatives.add(bestWord);
        }
        bestWord = word;
      } else {
        alternatives.add(word);
      }
    }
    // Sort alternatives by distance
    alternatives.sort((a, b) => b.dist!.compareTo(a.dist!));
    bestWord.alternatives = alternatives;
    return bestWord;
  }
}
