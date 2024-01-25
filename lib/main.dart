@JS()
library my_js_library;
// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
// import 'dart:js' as js;
import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('getData')
external dynamic getData();

@JS('changeColor')
external String changeColor(String color);

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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(onPressed: () {
              var got = changeColor('#3aa757');
              output = got;
              setState(() {});
            }),
            FloatingActionButton(onPressed: () {
              var got = changeColor('#ffa757');
              output = got;
              setState(() {});
            }),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Hello World 123'),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  color: Colors.amberAccent,
                  onPressed: () async {
                    try {
                      var promise = await getData();
                      output = await promiseToFuture(promise);
                      setState(() {});
                      print('Received data from JavaScript: $output');
                      print(output.runtimeType);
                    } catch (e) {
                      print('Error calling getData: $e');
                    }
                  },
                  // onPressed: () async {
                  //   dynamic data;
                  //   data = await js.context.callMethod('getData');
                  //   print(':: $data');
                  //   output = data.toString();
                  //   setState(() {});
                  // },
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
