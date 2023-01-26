class Word {
  late final String word;
  late final double? confidence;
  late final List<String> alternatives;
  late bool isPunctuation = false;

  Word(this.word, this.confidence, this.alternatives);

  Word.punctuation() {
    word = ".";
    confidence = 1;
    alternatives = [","];
    isPunctuation = true;
  }

  Word.nothing() {
    word = "";
    confidence = 0;
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
}
