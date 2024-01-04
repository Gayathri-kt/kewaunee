import 'dart:convert';
import 'dart:developer';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/text_constants.dart';
import 'model/login_response.dart';
import 'signature_screen.dart';


void main() => runApp(MyApp());

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AAD OAuth Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      // home: MyHomePage(title: 'AAD OAuth Home'),
      home:MyHomePage() ,
      routes: {
        '/': (context) => MyHomePage(),
        '/sign': (context) => SignatureScreen(),
      },
      navigatorKey: navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  String? title;

  MyHomePage({Key? key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var logger = Logger(
    printer: PrettyPrinter(),
  );
  static final Config config = Config(
    tenant: 'ca51afa4-43e6-4d01-9a9a-633374b0618e',
    clientId: '961cc16d-48ee-4801-9a63-644bafb8ada5',
    scope: 'openid profile email offline_access User.Read mailboxsettings.read calendars.readwrite',
    clientSecret: "zBg8Q~ysHZHxZUYpZazfqJ-C3sdvDqX-8mYG1dfR",
    navigatorKey: navigatorKey,
    webUseRedirect: true,
    redirectUri: kIsWeb?"https://kewaunee.web.app/MyHomePage":"https://dane-loving-mammoth.ngrok-free.app/callback",
    loader: const SizedBox(),
    appBar: AppBar(
      title: const Text('AAD OAuth Demo'),
    ),
  );
  final AadOAuth oauth = AadOAuth(config);

  Widget build(BuildContext context) {

    // adjust window size for browser login

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.launch,color: Colors.blue,),
              title: const Text('Login Azure'),
              onTap: () {
                login(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                // Navigator.pushNamed(context, '/sign');

                logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void showMessage(String text) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      ElevatedButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login(BuildContext context) async {
    try {
      final result = await oauth.login(refreshIfAvailable: true);

      result.fold(
            (failure) => showError(failure.toString()),
            (token) {
              log("Refresh token: ${token.refreshToken}");
        },
      );

      String? accessToken = await oauth.getAccessToken();
      log("accessToken: $accessToken");
      print("Debug accessToken $accessToken");
      // loginAPI(accessToken);
      // fetchAzureUserDetails(accessToken,context);


    } catch (e) {
      debugPrint("error: $e");
      showError(e);
    }
  }

   Future fetchAzureUserDetails(accessToken, BuildContext context) async {
    http.Response response;

    response = await http.get(
      Uri.parse("https://graph.microsoft.com/v1.0/me"),
      headers: {"Authorization": "Bearer $accessToken"},
    );
    debugPrint("response: ${response.body}");
    Navigator.pushNamed(context, '/sign');

    return json.decode(response.body);
  }
  void logout() async {
    await oauth.logout();
    showMessage("Logged out");
  }

  void loginAPI(accessToken) async {
    String url = "https://dane-loving-mammoth.ngrok-free.app/microsoft_login";
    Map loginRequest = {
      "access_token": accessToken,
    };


    final response =
    await http.post(Uri.parse(url), body: loginRequest);

    var data = LoginResponse.fromJson(json.decode(response.body));

    debugPrint("login_Data: ${data.data}");

    if (response.statusCode == 200) {
      debugPrint("login_response: ${response.body}");
      if (data.status!) {

        debugPrint("content:${data.data}");
        SharedPreferences sharedPreferences = await _prefs;
        sharedPreferences.setString(authToken, data.data!.authToken.toString());
        // sharedPreferences.setString(authCode, data.data!.code.toString());
             Get.offAllNamed('/sign');
        // snackBarAlert(data.message.toString());


        // Get.offAll(const DevicesTypeScreen());

      }
    } else if (response.statusCode == 422) {
      debugPrint("Response3 ${data.message}${response.statusCode}");
      // snackBarAlert(data.data.join(', '));
    } else if (response.statusCode == 401) {

    } else {
      // updateApp(response.statusCode, data.message);
      debugPrint("Response4 ${data.message}${response.statusCode}");
    }
  }




}