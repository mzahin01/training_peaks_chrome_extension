@JS()
library my_js_library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

@JS('getData')
external dynamic getData();

// Example of passing Data from Dart
// @JS('changeColor')
// external String changeColor(String color);
// onPressed: () {
//   var got = changeColor('#3aa757');
// }

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
                const Text(
                  'You need to get open the session you want to export and then you need to press the below button to get the session',
                  textAlign: TextAlign.center,
                ),
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
                    } catch (e) {
                      if (kDebugMode) {
                        print('Error calling getData: $e');
                      }
                    }
                  },
                  child: const Text('Get Library Data'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  output ?? 'No output pursed yet',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
