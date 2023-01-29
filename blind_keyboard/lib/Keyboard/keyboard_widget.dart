import 'package:flutter/material.dart';
import 'keyboard.dart';

class KeyboardWidget extends StatelessWidget {
  final Keyboard keyboard;

  KeyboardWidget({super.key, required this.keyboard});

  // Global Key map
  final Map<String, GlobalKey> lettersKeys = {};

  static const double verticalPadding = 20.0;
  static const double letterWidth = 20.0;
  static const double letterHeight = 32.0;
  static const double wordTypingHeight = 55.0;
  static const double bottomBarHeight = 50.0;

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

    return Localizations.override(
        context: context,
        locale: Locale(keyboard.languageCode),
        child: Container(
            color: Colors.black,
            child: ValueListenableBuilder(
                valueListenable: keyboard.loadingProgress,
                builder: (context, value, child) {
                  if (value == 1) {
                    return Directionality(
                      textDirection: TextDirection.ltr,
                      child: Column(children: [
                        _createWordTyping(context),
                        _createKeyboard(context),
                        _createBottomBar(context)
                      ]),
                    );
                  } else {
                    return _createLoadingWidget(context, value);
                  }
                })));
  }

  Widget _createLoadingWidget(BuildContext context, double progress) {
    return SizedBox(
        height: matchingHeight(context),
        child: Center(
            child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: Colors.white,
                ))));
  }

  Widget _createKeyboard(BuildContext context) {
    return Center(
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (TapDownDetails details) {
              clicked(
                  context, details.localPosition.dx, details.localPosition.dy);
            },
            onPanEnd: (details) {
              var xDist = details.velocity.pixelsPerSecond.dx;
              var yDist = details.velocity.pixelsPerSecond.dy;

              if (Keyboard.isRTL(keyboard.languageCode)) xDist = -xDist;
              print("xDist: $xDist, yDist: $yDist");
              if (xDist.abs() > yDist.abs() && xDist.abs() > 700) {
                if (xDist > 0) {
                  print("space");
                  space();
                } else {
                  print("backspace");
                  backspace();
                }
              } else if (yDist.abs() > 700) {
                if (yDist > 0) {
                  print("next alternative");
                  keyboard.typer.nextAlternative();
                } else {
                  print("previous alternative");
                  keyboard.typer.previousAlternative();
                }
              }
            },
            child: Column(children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: keyboard.layout.layout.map((row) {
                    return Column(
                      children: <Widget>[
                        const SizedBox(height: verticalPadding),
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
                                      width: letterWidth,
                                      height: letterHeight,
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
              const SizedBox(height: verticalPadding),
            ])));
  }

  Widget _createWordTyping(BuildContext context) {
    return SizedBox(
        height: wordTypingHeight,
        child: Center(
            child: TextField(
                controller: keyboard.typer.keyboardEditingController,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 40))));
  }

  Widget _createBottomBar(BuildContext context) {
    // Contains backspace, space bar and earth icon to change language.
    return SizedBox(
        height: bottomBarHeight,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
              width: 100,
              height: 40,
              child: IconButton(
                  onPressed: () {
                    keyboard.typer.nextKeyboard();
                  },
                  iconSize: 40,
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.language,
                      color: Colors.white, size: 40))),

          // Space bar
          Expanded(
              child: TextButton(
                  onPressed: () {
                    space();
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: const Center(
                          child: Text("Space",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)))))),

          SizedBox(
              width: 100,
              height: 40,
              child: IconButton(
                  onPressed: () {
                    backspace();
                  },
                  iconSize: 40,
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.backspace,
                      color: Colors.white, size: 40))),
        ]));
  }

  void clicked(BuildContext context, double x, double y) {
    // This code section converts the coordinates of the click to the coordinates of the keyboard.
    double width = context.size?.width ?? 0;
    double height =
        (context.size?.height ?? 0) - wordTypingHeight - bottomBarHeight;

    y = y - verticalPadding - letterHeight / 2;
    height = height - 2 * verticalPadding - letterHeight;

    double xKeyboard = x / width;
    double yKeyboard = y / height;

    print("Clicked at ($xKeyboard, $yKeyboard)");

    keyboard.click(xKeyboard, yKeyboard);
  }

  double matchingHeight(BuildContext context) {
    int rows = keyboard.layout.layout.length;
    return rows * letterHeight +
        (rows + 1) * verticalPadding +
        wordTypingHeight +
        bottomBarHeight;
  }

  void space() {
    keyboard.addSpace();
  }

  void backspace() {
    keyboard.backspace();
  }
}
