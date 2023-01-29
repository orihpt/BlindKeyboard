import 'package:blind_keyboard/Keyboard/keyboard_widget.dart';
import 'package:blind_keyboard/Typer/typer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoteScreen extends StatelessWidget {
  final Typer typer = Typer();

  NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        final safeArea = MediaQuery.of(context).padding;
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: typer.textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        AppLocalizations.of(context)!.placeholder_type_here,
                  ),
                  readOnly: true,
                  showCursor: true,
                  textAlign: TextAlign.right,
                ),
              ),
              const Spacer(flex: 1),
              ValueListenableBuilder(
                  valueListenable: typer.currentKeyboard,
                  builder: (context, value, child) {
                    return KeyboardWidget(keyboard: value);
                  }),
              Container(color: Colors.black, height: safeArea.bottom),
            ]),
          ),
        );
      },
    );
  }
}
