import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // # Welcome to Blind Keyboard
    // If you have difficulty seeing or writing, this app is for you.
    // When you type, the app remembers where you typed and finds the words you typed.
    // ## How to use
    // → Swipe right to enter space.
    // ← Swipe left to delete the last character or the last word.
    // ↓ Swipe down to go to the next word suggestion.
    // ↑ Swipe up to go to the previous word suggestion.
    // 🌏 The earth button on the bottom left changes the language.
    // Alternatively, you can use the space bar and the backspace key on the keyboard.

    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Text(AppLocalizations.of(context)!.info_title,
            style: const TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        Text(AppLocalizations.of(context)!.info_description,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        Text(AppLocalizations.of(context)!.info_howtouse_title,
            style: const TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        Text(AppLocalizations.of(context)!.info_howtouse_description,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
      ],
    )));
  }
}
