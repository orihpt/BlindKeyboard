import 'package:blind_keyboard/UI/Keyboard/keyboard_widget.dart';
import 'package:blind_keyboard/Typer/typer.dart';
import 'package:blind_keyboard/UI/Note%20Screen/note_screen_top_bar.dart';
import 'package:blind_keyboard/UI/Style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            top: false,
            child: Column(children: [
              Container(color: AppColors.barColor, height: safeArea.top),
              NoteScreenTopBar(
                copyListener: (() {
                  // Copy the text to the clipboard
                  Clipboard.setData(ClipboardData(text: typer.text.value));
                  typer.speakText(AppLocalizations.of(context)!.message_copy_to_clipboard);
                }),
              ),
              Container(color: AppColors.separatorColor, height: 2),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: typer.textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!.placeholder_type_here,
                  ),
                  readOnly: true,
                  showCursor: true,
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                  scrollPhysics: const BouncingScrollPhysics(),
                  textAlign: Directionality.of(context) == TextDirection.rtl ? TextAlign.right : TextAlign.left,
                ),
              )),
              const Spacer(flex: 1),
              ValueListenableBuilder(
                  valueListenable: typer.currentKeyboard,
                  builder: (context, value, child) {
                    return KeyboardWidget(keyboard: value);
                  }),
              Container(color: Colors.black, height: safeArea.bottom + 15),
            ]),
          ),
        );
      },
    );
  }
}
