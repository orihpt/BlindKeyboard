import 'Keyboard/keyboard_widget.dart';
import 'package:flutter/material.dart';

import 'Typer/typer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Typer typer = Typer();

  MyHomePage({super.key});

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
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'הקלידו כאן...',
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
