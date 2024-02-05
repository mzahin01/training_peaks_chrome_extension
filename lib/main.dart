@JS()
library my_js_library;

import 'dart:async';
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
  // String baseUrl = 'stg-api-gw.pillar-app.com';
  String baseUrl = 'prod-api-gw.pillar-app.com';
  String? output;
  String? fcmToken;
  SessionList? sessionList;

  bool isLoading = false;

  String? backendError;

  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? ftpController;
  String? emailErrorText;
  String? passwordErrorText;
  String? ftpErrorText;

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
    ftpController = TextEditingController();
    fcmToken = await SharedPref.getFCMToken();
    sessionList = await SharedPref.getSessionList();
    ftpController?.text = (await SharedPref.getFTP())?.toString() ?? '';
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
    setState(() {
      isLoading = true;
    });
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
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if (response?.statusCode == 200) {
      String sampleToken =
          jsonDecode(response?.body ?? '')['data']['access_jwt_token'];
      fcmToken = sampleToken;
      SharedPref.setFCMToken(sampleToken);
    } else {
      backendError = jsonDecode(response?.body ?? '')['message'];
      setState(() {});
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> removeError() async {
    if (backendError != null) {
      await Future.delayed(const Duration(seconds: 3));
      backendError = null;
      setState(() {});
    }
  }

  Future<void> saveSessionList() async {
    if (ftpController?.text == null || ftpController?.text == '') {
      ftpErrorText = 'FTP is required';
      setState(() {});
      return;
    }
    int? ftp = int.tryParse(ftpController?.text ?? '');
    if (ftp == null || ftp < 30 || ftp > 500) {
      ftpErrorText = 'Accepted range of FTP is 30-500';
      setState(() {});
      return;
    }
    ftpErrorText = null;
    await SharedPref.setFTP(ftp);
    setState(() {
      isLoading = true;
    });

    var url = Uri.https(
        baseUrl, '/trainer/private/api/v1/coach/library/session/import');

    for (int i = 0; i < (sessionList?.sessions?.length ?? 0); i++) {
      sessionList?.sessions?[i].ftp = ftp;
    }
    http.Response? response;
    try {
      response = await http.post(
        url,
        body: jsonEncode(sessionList?.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $fcmToken',
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    if (response?.statusCode == 200) {
      sessionList?.sessions = [];
      if (sessionList != null) {
        await SharedPref.setSessionList(sessionList!);
      }
    } else {
      backendError = jsonDecode(response?.body ?? '')['message'];
      setState(() {});
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: (fcmToken != null && fcmToken != '')
            ? MaterialButton(
                color: Colors.amberAccent,
                onPressed: () async {
                  SharedPref.removeFCMToken();
                  SharedPref.removeSessionList();
                  fcmToken = null;
                  sessionList = null;
                  setState(() {});
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text('Log Out'),
                ),
              )
            : null,
        body: Stack(
          children: [
            Center(
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
                            onPressed: () async {
                              getFCMToken().then((value) => removeError());
                            },
                            child: const Text('Login to Pillar'),
                          )
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            decoration: InputDecoration(
                              label: const Text('FTP'),
                              errorText: ftpErrorText,
                            ),
                            controller: ftpController,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'To export a session to Pillar, click on the session in the calendar view to view the session detail view. Then click on the button "Save" to include the session into the import. Once ready, click the button "Send" to send the saved session\'s to your Pillar library',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              color: Colors.amberAccent,
                              onPressed: () async {
                                try {
                                  var promise = await getData();
                                  output = await promiseToFuture(promise);
                                  Session session =
                                      Session.fromRawJson(output ?? '');
                                  if (sessionList == null) {
                                    sessionList =
                                        SessionList(sessions: [session]);
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
                              child: const Text('Save'),
                            ),
                            if (sessionList?.sessions?.isNotEmpty ?? false) ...[
                              const SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                color: Colors.amberAccent,
                                onPressed: () {
                                  saveSessionList()
                                      .then((value) => removeError());
                                },
                                child: const Text('Send'),
                              ),
                            ]
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SessionListWidget(
                          sessionList: sessionList,
                          removeSessoin: removeSessionFromList,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Visibility(
                visible: backendError != null,
                child: Container(
                  width: 600,
                  height: 50,
                  color: Colors.redAccent,
                  child: Center(
                    child: Text(backendError ?? ''),
                  ),
                ),
              ),
            ),
          ],
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
