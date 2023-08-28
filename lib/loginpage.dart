import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  Function callback;
  LoginPage(this.callback);
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final FocusNode _focusNodePassword = FocusNode();
  final cUser = TextEditingController();
  final cPass = TextEditingController();
  bool _obscurePassword = true;
  SharedPreferences? prefs;
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            "Conectati-va",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          Text(
            globals.textInfo == ""
                ? "Introduceti email si parola"
                : globals.textInfo,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          TextFormField(
            controller: cUser,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "E-mail",
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onEditingComplete: () => _focusNodePassword.requestFocus(),
            validator: (String? value) {
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: cPass,
            focusNode: _focusNodePassword,
            obscureText: _obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: "Parola",
              prefixIcon: const Icon(Icons.password_outlined),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: _obscurePassword
                      ? const Icon(Icons.visibility_outlined)
                      : const Icon(Icons.visibility_off_outlined)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (String? value) {
              return null;
            },
          ),
          const SizedBox(height: 60),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  globals.textInfo = "";

                  String ce = cUser.text;
                  String cp = cPass.text;

                  if ((ce.indexOf('@') < 1) || (ce.indexOf('.') < 1)) {
                    globals.showMessage(context, "Adresa de e-mail invalida !",
                        Colors.redAccent);
                    return;
                  }

                  if (cp.length < 6) {
                    globals.showMessage(
                        context, "Parola invalida !", Colors.redAccent);
                    return;
                  }

                  dynamic log = await globals.postData("login",
                      jsonEncode(<String, String?>{'email': ce, 'pass': cp}));

                  LogData data = LogData.fromMap(log);
                  String status = data.status!;
                  if (status == "error") {
                    String errtxt = data.error!;
                    globals.showMessage(context, errtxt, Colors.redAccent);
                    return;
                  }
                  globals.userId = data.userid!;
                  globals.userName = data.username!;
                  globals.userMail = data.usermail!;
                  print("ID:" + globals.userId);
                  print("NM:" + globals.userName);
                  print("EM:" + globals.userMail);
                  this.widget.callback(14);
                },
                child: const Text("CONECTARE"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Nu aveti cont?"),
                  TextButton(
                    onPressed: () {
                      globals.textInfo = "";
                      this.widget.callback(5);
                    },
                    child: const Text("Inregistrati-va"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cUser.dispose();
    cPass.dispose();
    super.dispose();
  }
}

class LogData {
  final String? status;
  final String? error;
  final String? userid;
  final String? usermail;
  final String? username;
  LogData({this.status, this.error, this.userid, this.usermail, this.username});
  factory LogData.fromMap(Map<String, dynamic> map) {
    return LogData(
        status: map['status'],
        error: map['error'],
        userid: map['userid'],
        usermail: map['usermail'],
        username: map['username']);
  }
}
