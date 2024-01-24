// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
// import 'package:web/web.dart' as w;
import 'dart:js' as js;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String? output;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Hello World 123'),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    js.context.callMethod('changeColor', ['#3aa757']);
                  },
                  child: const Text('Print to Console'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(output ?? 'NO output'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
