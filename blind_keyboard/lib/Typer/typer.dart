import 'package:blind_keyboard/Dictionary/words.dart';
import 'package:blind_keyboard/Keyboard/keyboard.dart';
import 'package:flutter/cupertino.dart';

// Typer is the class that holds the written text and keyboards.
class Typer {
  List<Keyboard> keyboards = [];
  late Keyboard currentKeyboard;

  // The public text property, includes current word typed.
  ValueNotifier<String> text = ValueNotifier<String>('hi');

  // The private text property, does not include current word typed.
  List<Words> words = [];

  TextEditingController textEditingController = TextEditingController();

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
    Words? word = currentKeyboard.getWord();
    if (word != null) {
      text.value = Words.wordsListToString(words + [word]);
    } else {
      text.value = Words.wordsListToString(words);
    }
    textEditingController.text = text.value;
  }

  void wordUpdatedAtKeyboard({required Keyboard keyboard}) {
    if (keyboard == currentKeyboard) {
      _updateText();
    }
  }

  bool nextAlternative() {
    return currentKeyboard.nextAlternative();
  }

  bool previousAlternative() {
    return currentKeyboard.previousAlternative();
  }

  void space() {
    Words? word = currentKeyboard.getWord();
    if (word != null && word.getWord().word.isNotEmpty) {
      words.add(word);
      currentKeyboard.clearWord();
      _updateText();
    } else {
      words.add(Words.punctuation());
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
}
