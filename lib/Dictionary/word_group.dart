import 'package:blind_keyboard/Dictionary/word.dart';
import 'package:flutter/foundation.dart';

// The words class holds a word and its alternatives.
class WordGroup {
  late ValueNotifier<int> index = ValueNotifier<int>(0);

  // The alternatives of the word.
  late List<Word> words;

  // If the word is punctuation.
  late bool isPunctuation = false;

  // # Constructors
  WordGroup(this.words, {this.isPunctuation = false});

  WordGroup.sorted(this.words, {this.isPunctuation = false}) {
    // Sort words by distance (so that index 0 is the closest word)
    words.sort((a, b) {
      return a.dist!.compareTo(b.dist!);
    });
  }

  WordGroup.punctuation() {
    isPunctuation = true;
    List<String> punctuationList = ["👍", "❤️", "🥳", "😃", ".", ",", "!", "?", ":", ";"];
    // Create a word for each punctuation
    words = [];
    for (String punctuation in punctuationList) {
      words.add(Word(punctuation, 0));
    }
    // set index to the index of . dynamically
    index.value = punctuationList.indexOf(".");
  }

  WordGroup.combine(WordGroup a, WordGroup b) {
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

  WordGroup.nothing() {
    words = [Word.nothing()];
  }

  WordGroup.toBeCalculated(int wordLength) {
    words = [Word("*" * wordLength, null)];
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
  static String wordsListToString(List<WordGroup> words) {
    String str = "";
    for (WordGroup word in words) {
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

  static WordGroup flatWordsList(List<WordGroup> wordsList, {isPunctuation = false}) {
    Map<String, Word> wordsMap = {};
    for (WordGroup wordsObj in wordsList) {
      for (Word wordObj in wordsObj.words) {
        if (wordObj.dist != null) {
          wordsMap[wordObj.word] = wordObj;
        }
      }
    }

    var words = wordsMap.values.toList();

    // Sort words by distance
    words.sort((a, b) => a.dist!.compareTo(b.dist!));

    // Only first 10
    words = words.sublist(0, words.length > 10 ? 10 : words.length);

    return WordGroup(words, isPunctuation: isPunctuation);
  }
}
