import 'package:blind_keyboard/Keyboard/keyboard.dart';
import 'package:flutter/cupertino.dart';

// Typer is the class that holds the written text and keyboards.
class Typer {
  List<Keyboard> keyboards = [];
  Keyboard? currentKeyboard;

  // The public text property, includes current word typed.
  ValueNotifier<String> text = ValueNotifier<String>('hi');

  // The private text property, does not include current word typed.
  String _text = '';

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
    String? word = currentKeyboard?.getWord();
    if (word != null) {
      text.value = '$_text $word';
    } else {
      text.value = _text;
    }
  }

  void wordUpdatedAtKeyboard({required Keyboard keyboard}) {
    if (keyboard == currentKeyboard) {
      _updateText();
    }
  }

  void space() {
    String? word = currentKeyboard?.getWord();
    if (word != null) {
      _text += ' $word';
      currentKeyboard?.clearWord();
      _updateText();
    }
  }

  void backspace() {
    // Remove last word
    if (_text.isNotEmpty) {
      _text = _text.substring(0, _text.lastIndexOf(' '));
      _updateText();
    }
  }
}
