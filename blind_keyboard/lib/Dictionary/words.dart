import 'package:blind_keyboard/Dictionary/word.dart';
import 'package:flutter/foundation.dart';

// The words class holds a word and its alternatives.
class Words {
  late ValueNotifier<int> index = ValueNotifier<int>(0);

  // The alternatives of the word.
  late List<Word> words;

  // If the word is punctuation.
  late bool isPunctuation = false;

  // # Constructors
  Words(this.words, {this.isPunctuation = false});

  Words.sorted(this.words, {this.isPunctuation = false}) {
    // Sort words by distance (so that index 0 is the closest word)
    words.sort((a, b) => a.dist!.compareTo(b.dist!));
  }

  Words.punctuation() {
    isPunctuation = true;
    List<String> punctuationList = [".", ",", "!", "?", ":", ";"];
    // Create a word for each punctuation
    words = [];
    for (String punctuation in punctuationList) {
      words.add(Word(punctuation, 0));
    }
  }

  Words.combine(Words a, Words b) {
    // Possible combinations
    words = [];
    for (Word wordA in a.words) {
      for (Word wordB in b.words) {
        words.add(Word.combine(wordA, wordB));
      }
    }
    // Sort words by distance (so that index 0 is the closest word)
    words.sort((a, b) => a.dist!.compareTo(b.dist!));
  }

  Words.nothing() {
    words = [Word.nothing()];
  }

  // # Word
  Word getWord() {
    return words[index.value];
  }

  // Goes to the next alternative.
  // If there are no more alternatives, it returns false, otherwise true.
  bool nextWord() {
    if (index.value < words.length - 1) {
      index.value++;
      return true;
    }
    return false;
  }

  // Goes to the previous alternative.
  // If there are no more alternatives, it returns false, otherwise true.
  bool previousWord() {
    if (index.value > 0) {
      index.value--;
      return true;
    }
    return false;
  }

  // Returns a boolean value indicating whether the word is empty.
  bool isEmpty() {
    return words.isEmpty || words[0].dist == null;
  }

  // # Static functions

  // Converts a words list into a string.
  static String wordsListToString(List<Words> words) {
    String str = "";
    for (Words word in words) {
      if (word.isPunctuation) {
        str += word.getWord().word;
      } else {
        str += " ${word.getWord().word}";
      }
    }

    // If first character is a space, remove it.
    if (str.isNotEmpty && str[0] == " ") {
      str = str.substring(1);
    }

    return str;
  }

  static Words flatWordsList(List<Words> wordsList, {isPunctuation = false}) {
    List<Word> words = [];
    for (Words wordsObj in wordsList) {
      for (Word wordObj in wordsObj.words) {
        if (wordObj.dist != null) {
          words.add(wordObj);
        }
      }
    }

    // Sort words by distance
    words.sort((a, b) => a.dist!.compareTo(b.dist!));

    return Words(words, isPunctuation: isPunctuation);
  }
}
