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
    keyboards.add(Keyboard('en', this));
    keyboards.add(Keyboard('he', this));
    currentKeyboard = ValueNotifier<Keyboard>(keyboards[0]);
    _load();
  }

  // Loads the current keyboard, and unloads the other keyboards.
  void _load() {
    for (Keyboard keyboard in keyboards) {
      if (keyboard != currentKeyboard.value) {
        keyboard.unload();
      }
    }
    currentKeyboard.value.load();
  }

  // # Text Interactions
  // Updates the text and the text field.
  void _updateText() {
    WordGroup? word = currentKeyboard.value.getWord();
    if (word != null) {
      text.value = WordGroup.wordsListToString(words + [word]);
    } else {
      text.value = WordGroup.wordsListToString(words);
    }
    textEditingController.text = text.value;
    keyboardEditingController.text = currentKeyboard.value.getWord()?.getWord().word ?? getLastWord()?.getWord().word ?? '';
  }

  // Called when the word is updated.
  void wordUpdatedAtKeyboard({required Keyboard keyboard}) {
    if (keyboard == currentKeyboard.value) {
      _updateText();
    }
  }

  // Goes to the next alternative in the current word.
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

  // Goes to the previous alternative in the current word.
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

  // Adds space
  void space({double? keyboardAspectRatio}) {
    currentKeyboard.value.calcWord(aspectRatio: keyboardAspectRatio);
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

  // Removes the last character or word.
  void backSpace() {
    currentKeyboard.value.backspace();
  }

  // Removes the last word.
  void removeLastWord() {
    if (words.isNotEmpty) {
      words.removeLast();
      _updateText();
    }
  }

  // Returns the last word typed.
  WordGroup? getLastWord() {
    if (words.isNotEmpty) {
      return words.last;
    } else {
      return null;
    }
  }

  // Performs Text-to-Speech on the word.
  void _speakWord(Word word) {
    speakText(word.word);
  }

  // Performs Text-to-Speech on the text.
  void speakText(String text) {
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

  // Switches the language of the typer.
  void nextKeyboard() {
    int index = keyboards.indexOf(currentKeyboard.value);
    index++;
    if (index >= keyboards.length) {
      index = 0;
    }
    currentKeyboard.value = keyboards[index];
    switch (currentKeyboard.value.languageCode) {
      case 'he':
        speakText("מקלדת עברית");
        break;
      case 'en':
        speakText("English keyboard");
        break;
    }
    _updateText();
    _load();
  }
}
