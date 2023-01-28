import 'package:blind_keyboard/Dictionary/word_group.dart';
import 'package:blind_keyboard/Keyboard/keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../Dictionary/word.dart';

// Typer is the class that holds the written text and keyboards.
class Typer {
  List<Keyboard> keyboards = [];
  late Keyboard currentKeyboard;

  // The public text property, includes current word typed.
  ValueNotifier<String> text = ValueNotifier<String>('');

  // The words that were typed, does not include the current word typed.
  List<WordGroup> words = [];

  // The text field of all of the text.
  TextEditingController textEditingController = TextEditingController();

  // The text field of the current word only.
  TextEditingController keyboardEditingController = TextEditingController();

  // Text to speech
  final TextToSpeech _textToSpeech = TextToSpeech();

  Typer() {
    keyboards.add(Keyboard('he', this));
    //keyboards.add(Keyboard('en', this));
    currentKeyboard = keyboards[0];
  }

  void changeKeyboard(String language) {
    for (Keyboard keyboard in keyboards) {
      if (keyboard.languageCode == language) {
        currentKeyboard = keyboard;
        break;
      }
    }
  }

  void _updateText() {
    WordGroup? word = currentKeyboard.getWord();
    if (word != null) {
      text.value = WordGroup.wordsListToString(words + [word]);
    } else {
      text.value = WordGroup.wordsListToString(words);
    }
    textEditingController.text = text.value;
    keyboardEditingController.text =
        currentKeyboard.getWord()?.getWord().word ??
            getLastWord()?.getWord().word ??
            '?';
  }

  void wordUpdatedAtKeyboard({required Keyboard keyboard}) {
    if (keyboard == currentKeyboard) {
      _updateText();
    }
  }

  bool nextAlternative() {
    if (currentKeyboard.isTyping()) {
      return false;
    }
    // Get the last word
    WordGroup? lastWord = getLastWord();
    if (lastWord == null) {
      return false;
    }

    bool r = lastWord.nextWord();

    // Speak the word
    _speakWord(lastWord.getWord());

    _updateText();

    return r;
  }

  bool previousAlternative() {
    if (currentKeyboard.isTyping()) {
      return false;
    }
    // Get the last word
    WordGroup? lastWord = getLastWord();
    if (lastWord == null) {
      return false;
    }

    bool r = lastWord.previousWord();

    // Speak the word
    _speakWord(lastWord.getWord());

    _updateText();

    return r;
  }

  void space() {
    currentKeyboard.calcWord();
    WordGroup? word = currentKeyboard.getWord();
    if (word != null && word.getWord().word.isNotEmpty) {
      words.add(word);
      currentKeyboard.clearWord();
      _updateText();

      // Speak the word
      _speakWord(word.getWord());
    } else {
      words.add(WordGroup.punctuation());
    }
  }

  void backSpace() {
    currentKeyboard.backspace();
  }

  void removeLastWord() {
    if (words.isNotEmpty) {
      words.removeLast();
      _updateText();
    }
  }

  WordGroup? getLastWord() {
    if (words.isNotEmpty) {
      return words.last;
    } else {
      return null;
    }
  }

  void _speakWord(Word word) {
    _textToSpeech.speak(word.word);
  }

  void nextLanguage() {
    int index = keyboards.indexOf(currentKeyboard);
    index++;
    if (index >= keyboards.length) {
      index = 0;
    }
    currentKeyboard = keyboards[index];
    _updateText();
  }
}
