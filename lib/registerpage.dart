import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  Function callback;
  RegisterPage(this.callback);
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController cUsername = TextEditingController();
  final TextEditingController cEmail = TextEditingController();
  final TextEditingController cPassword = TextEditingController();
  final TextEditingController cConFirmPassword = TextEditingController();
  bool _obscurePassword = true;

  SharedPreferences? prefs;
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Inregistrati-va",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          Text(
            "Creati-va cont",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 35),
          TextFormField(
            controller: cUsername,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: "Nume",
              prefixIcon: const Icon(Icons.person_outline),
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
          const SizedBox(height: 10),
          TextFormField(
            controller: cEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: const Icon(Icons.email_outlined),
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
          const SizedBox(height: 10),
          TextFormField(
            controller: cPassword,
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
          const SizedBox(height: 10),
          TextFormField(
            controller: cConFirmPassword,
            obscureText: _obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: "Confirma parola",
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
          const SizedBox(height: 50),
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
                  String cu = cUsername.text;
                  String ce = cEmail.text;
                  String cp = cPassword.text;
                  String cc = cConFirmPassword.text;

                  //validari
                  if (cp != cc) {
                    globals.showMessage(
                        context, "Parolele nu coincid !", Colors.redAccent);
                    return;
                    //Theme.of(context).colorScheme.secondary
                  }

                  if (cu.trim() == "") {
                    globals.showMessage(
                        context, "Introduceti numele !", Colors.redAccent);
                    return;
                  }

                  if ((ce.indexOf('@') < 1) || (ce.indexOf('.') < 1)) {
                    globals.showMessage(context, "Adresa de e-mail invalida !",
                        Colors.redAccent);
                    return;
                  }

                  if (cp.length < 6) {
                    globals.showMessage(
                        context,
                        "Parola trebuie sa contina minim 6 caractere !",
                        Colors.redAccent);
                    return;
                  }

                  dynamic reg = await globals.postData(
                      "register",
                      jsonEncode(<String, String?>{
                        'name': cu,
                        'email': ce,
                        'pass': cp
                      }));

                  RegData data = RegData.fromMap(reg);
                  String status = data.status!;
                  if (status == "error") {
                    String errtxt = data.error!;
                    globals.showMessage(context, errtxt, Colors.redAccent);
                    return;
                  }
                  globals.textInfo = "Ati primit pe adresa de e-mail \n" +
                      ce +
                      "\n un link de activare. \nDupa activarea contului, va puteti conecta!";
                  this.widget.callback(14);
                },
                child: const Text("Register"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Aveti deja cont ?"),
                  TextButton(
                    onPressed: () => {this.widget.callback(14)},
                    child: const Text("Conectati-va"),
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
    cUsername.dispose();
    cEmail.dispose();
    cPassword.dispose();
    cConFirmPassword.dispose();
    super.dispose();
  }
}

class RegData {
  final String? status;
  final String? error;
  RegData({this.status, this.error});
  factory RegData.fromMap(Map<String, dynamic> map) {
    return RegData(
      status: map['status'],
      error: map['error'],
    );
  }
}
