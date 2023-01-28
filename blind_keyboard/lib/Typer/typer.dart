import 'package:blind_keyboard/Dictionary/word_group.dart';
import 'package:blind_keyboard/Keyboard/keyboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:text_to_speech/text_to_speech.dart';

import '../Dictionary/word.dart';

// Typer is the class that holds the written text and keyboards.
class Typer {
  List<Keyboard> keyboards = [];
  late ValueNotifier<Keyboard> currentKeyboard;

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
    keyboards.add(Keyboard('en', this));
    currentKeyboard = ValueNotifier<Keyboard>(keyboards[0]);
    _load();
  }

  Future<void> _load() async {
    for (Keyboard keyboard in keyboards) {
      await keyboard.dictionary.load();
    }
  }

  void _updateText() {
    WordGroup? word = currentKeyboard.value.getWord();
    if (word != null) {
      text.value = WordGroup.wordsListToString(words + [word]);
    } else {
      text.value = WordGroup.wordsListToString(words);
    }
    textEditingController.text = text.value;
    keyboardEditingController.text =
        currentKeyboard.value.getWord()?.getWord().word ??
            getLastWord()?.getWord().word ??
            '';
  }

  void wordUpdatedAtKeyboard({required Keyboard keyboard}) {
    if (keyboard == currentKeyboard.value) {
      _updateText();
    }
  }

  bool nextAlternative() {
    if (currentKeyboard.value.isTyping()) {
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
    if (currentKeyboard.value.isTyping()) {
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
    currentKeyboard.value.calcWord();
    WordGroup? word = currentKeyboard.value.getWord();
    if (word != null && word.getWord().word.isNotEmpty) {
      words.add(word);
      currentKeyboard.value.clearWord();
      _updateText();
    } else {
      word = WordGroup.punctuation();
      words.add(word);
      _updateText();
    }

    // Speak the word
    _speakWord(word.getWord());
  }

  void backSpace() {
    currentKeyboard.value.backspace();
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
    _speakText(word.word);
  }

  void _speakText(String text) {
    _textToSpeech.stop();
    switch (currentKeyboard.value.languageCode) {
      case 'he':
        _textToSpeech.setLanguage('he-IL');
        break;
      case 'en':
        _textToSpeech.setLanguage('en-US');
        break;
    }
    _textToSpeech.speak(text);
  }

  void nextKeyboard() {
    int index = keyboards.indexOf(currentKeyboard.value);
    index++;
    if (index >= keyboards.length) {
      index = 0;
    }
    currentKeyboard.value = keyboards[index];
    switch (currentKeyboard.value.languageCode) {
      case 'he':
        _speakText("מקלדת עברית");
        break;
      case 'en':
        _speakText("English keyboard");
        break;
    }
    _updateText();
  }
}
