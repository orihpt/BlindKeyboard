import 'package:blind_keyboard/UI/Assistant/assistant_screen.dart';
import 'package:blind_keyboard/UI/Style/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoteScreenTopBar extends StatelessWidget {
  const NoteScreenTopBar({Key? key, required this.copyListener})
      : super(key: key);

  final Function() copyListener;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: AppColors.barColor,
      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(AppLocalizations.of(context)!.note_screen_title,
              style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.copy),
            iconSize: 40,
            onPressed: copyListener,
          ),
          IconButton(
            icon: const Icon(Icons.info),
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AssistantScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
