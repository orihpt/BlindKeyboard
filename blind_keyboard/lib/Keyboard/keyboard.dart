import 'keyboard_layout.dart';

class Keyboard {
  late KeyboardLayout layout;
  late String languageCode;

  Keyboard(String language) {
    layout = KeyboardLayout(language);
    languageCode = language;
  }
}
