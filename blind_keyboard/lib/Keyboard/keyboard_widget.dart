import 'package:flutter/material.dart';
import 'keyboard.dart';

class KeyboardWidget extends StatelessWidget {
  final Keyboard keyboard;

  const KeyboardWidget({super.key, required this.keyboard});

  @override
  Widget build(BuildContext context) {
    // ------------
    // Q W E R T Y U I O P
    // A S D F G H J K L
    // Z X C V B N M
    // ------------
    // The letters are taken from the keyboard layout.
    // Each letter is a text, and each row is a horizontal layout.
    // The rows are stacked vertically.

    // Get the width of widget.
    final double width = MediaQuery.of(context).size.width;

    return Container(
        color: Colors.blue,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: keyboard.layout.layout.map((row) {
                return Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: row.map((letter) {
                          return Container(
                              color: Colors.black,
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
        ));
  }
}
