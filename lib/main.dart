// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
// import 'package:web/web.dart' as w;
import 'dart:js' as js;

import 'package:js/js_util.dart';

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
              print(':: from Dart');
              var got = js.context.callMethod('changeColor', ['#3aa757']);
              output = got;
              setState(() {});
              print(':: $got');
            }),
            FloatingActionButton(onPressed: () {
              var got = js.context.callMethod('changeColor', ['#ffa757']);
              output = got;
              setState(() {});
              print(':: $got');
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
                      var promise = js.context.callMethod('getData');
                      var result = await promiseToFuture(promise);
                      print(result);
                      output = result.toString();
                      setState(() {});
                      print('Received data from JavaScript: $result');
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
