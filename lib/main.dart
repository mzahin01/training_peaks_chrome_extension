@JS()
library my_js_library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:training_peaks_library_export_extension/session_model.dart';
import 'package:training_peaks_library_export_extension/shared_preference.dart';
import 'package:http/http.dart' as http;

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
  String? fcmToken;
  SessionList? sessionList;

  bool isLoading = false;

  TextEditingController? emailController;
  TextEditingController? passwordController;
  String? emailErrorText;
  String? passwordErrorText;

  Future<void> removeSessionFromList(Session? session) async {
    sessionList?.sessions?.removeWhere((Session s) => s == session);
    if (sessionList != null) {
      SharedPref.setSessionList(sessionList!);
    }
    setState(() {});
  }

  @override
  void initState() async {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    fcmToken = await SharedPref.getFCMToken();
    sessionList = await SharedPref.getSessionList();
    setState(() {});
    super.initState();
  }

  bool isFCMTokenExpired() {
    if (fcmToken == '' || fcmToken == null) {
      return true;
    }
    if (JwtDecoder.isExpired(fcmToken ?? '')) {
      return true;
    }
    return false;
  }

  Future<void> getFCMToken() async {
    setState(() {
      isLoading = true;
    });

    if (emailController?.text == null || emailController?.text == '') {
      emailErrorText = 'Email is required';
      setState(() {});
      return;
    }
    emailErrorText = null;
    if (passwordController?.text == null || passwordController?.text == '') {
      passwordErrorText = 'Password is required';
      setState(() {});
      return;
    }
    passwordErrorText = null;
    setState(() {});
    String baseUrl = 'stg-api-gw.pillar-app.com';
    // String baseUrl = 'prod-api-gw.pillar-app.com';
    var url = Uri.https(baseUrl, '/daroan/public/api/v1/auth/coach/login');
    http.Response? response;
    try {
      response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': emailController?.text,
            'password': passwordController?.text
          },
        ),
        headers: {
          'authority': 'stg-api-gw.pillar-app.com',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    String sampleToken =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJmcmVzaCI6dHJ1ZSwiaWF0IjoxNzA2NjE2NDc2LCJqdGkiOiI4ZTRkYjM1ZC1kMjZlLTQzNDEtODRhOS1hODVjZTlhYjYxZGEiLCJ0eXBlIjoiYWNjZXNzIiwic3ViIjoiZDkzYTAzZjUtNjVmNS00YjM0LWI4YjEtM2JhM2ZjMTIxMDhhIiwibmJmIjoxNzA2NjE2NDc2LCJpc3MiOiJRaU9qRTJNRFE1T1RFMk1EWXNJbTVpWmlJNk1UWXdORGs1TVRZd05pd2lhblJwSWpvaU9UTmxORGt6TjJJdFpqQmhPQzAwTkdKakxUazVNVFV0TmpReFl6WmlNREJsT1Rrd0lpd2laWGh3SWpveE5qQTFOVGsyTkRBMkxDSnBaR1Z1ZEdsMGVTSTZNaXdpWm5KbGMyZ2lPbVpoYkhObExDSjBlWEJsSWpvaVlXTmpaWE56SWl3aWEiLCJleHAiOjE3MjIzODQ0NzYsImlkZW50aXR5IjoiZDkzYTAzZjUtNjVmNS00YjM0LWI4YjEtM2JhM2ZjMTIxMDhhIiwiZW1haWwiOiJ0ZXN0LTFAZ21haWwuY29tIn0.AZICiSOyVwqUktipoo6pqgdrCuxq4DQk3v9B87IG_-jx_Ng_ztqOe-bq_4zQuCrbr3GF-QvAg_2-OQOQTp6MJOQ1sp4fjrFJkWZDWP6j2uu7ZqZWFabooo_eS0VaddN27jzJpGJ5TbcZi9pvYyuChnH3IfhwYfW32soyYtVl0yTT8drK8dvGzwPsFUPLCkwoRAtTJ_8V7sD3xjbv3-Kfraq0VNyaT3o63_Bqur8bAPvtV_sJAvKt3f0So6rHyVAmZuRuDRSobHzLFht8UZtWFZDD-temBK7VxQIwB6YTTjaECQZvID71MeM4Fzz8wTZFejNjIimeiOnLJN4ldI6TWg";
    fcmToken = sampleToken;
    SharedPref.setFCMToken(sampleToken);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () async {
          SharedPref.removeFCMToken();
          SharedPref.removeSessionList();
        }),
        body: Center(
          child: Visibility(
            visible: !isLoading,
            replacement: const CircularProgressIndicator(),
            child: SingleChildScrollView(
              child: Visibility(
                visible: !isFCMTokenExpired(),
                replacement: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          errorText: emailErrorText,
                        ),
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          errorText: passwordErrorText,
                        ),
                        controller: passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        color: Colors.amberAccent,
                        onPressed: () {
                          getFCMToken();
                        },
                        child: const Text('Login to Pillar'),
                      )
                    ],
                  ),
                ),
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
                          Session session = Session.fromRawJson(output ?? '');
                          if (sessionList == null) {
                            sessionList = SessionList(sessions: [session]);
                          } else {
                            sessionList?.sessions?.add(session);
                          }
                          if (sessionList != null) {
                            SharedPref.setSessionList(sessionList!);
                          }
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
                    SessionListWidget(
                      sessionList: sessionList,
                      removeSessoin: removeSessionFromList,
                    )
                    // Text(
                    //   output ?? 'No output pursed yet',
                    //   textAlign: TextAlign.center,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SessionListWidget extends StatelessWidget {
  const SessionListWidget(
      {super.key, required this.sessionList, required this.removeSessoin});

  final SessionList? sessionList;
  final Function(Session?) removeSessoin;

  @override
  Widget build(BuildContext context) {
    if (sessionList == null) {
      return const Text('No Library Session Parsed Yet.');
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < (sessionList?.sessions?.length ?? 0); i++)
            SingleSessionWidget(
              session: sessionList?.sessions?[i],
              removeSession: removeSessoin,
            )
        ],
      );
    }
  }
}

class SingleSessionWidget extends StatelessWidget {
  const SingleSessionWidget(
      {super.key, required this.session, required this.removeSession});

  final Session? session;
  final Function(Session?) removeSession;

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 100,
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  session?.title ?? '--',
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  session?.description ?? 'No description',
                  maxLines: 3,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            width: 50,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                removeSession.call(session);
              },
            ),
          )
        ],
      ),
    );
  }
}
