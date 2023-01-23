import 'package:flutter/material.dart';
import 'keyboard.dart';

class KeyboardWidget extends StatelessWidget {
  final Keyboard keyboard;

  KeyboardWidget({super.key, required this.keyboard});

  // Global Key map
  final Map<String, GlobalKey> lettersKeys = {};

  @override
  Widget build(BuildContext context) {
    // -------------------
    // Q W E R T Y U I O P
    //  A S D F G H J K L
    //    Z X C V B N M
    // -------------------
    // The letters are taken from the keyboard layout.
    // Each letter is a text, and each row is a horizontal layout.
    // The rows are stacked vertically.

    return Container(
        color: Colors.blue,
        child: Center(
            child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (TapDownDetails details) {
            keyboard.click(details.localPosition.dx, details.localPosition.dy);
          },
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: keyboard.layout.layout.map((row) {
                return Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row.map((letter) {
                          // Get the global key of the letter.
                          // If it does not exist, create it.
                          final key = lettersKeys[letter] ??= GlobalKey();

                          return Container(
                              color: Colors.black,
                              key: key,
                              child: SizedBox(
                                  width: 20,
                                  height: 28,
                                  child: Text(letter,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold))));
                        }).toList()),
                  ],
                );
              }).toList()),
        )));
  }
}
