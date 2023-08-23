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
            "Introduceti email si parola",
            style: Theme.of(context).textTheme.bodyMedium,
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
              if (value == null || value.isEmpty) {
                return "Introduceti adresa de e-mail.";
              }
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
              if (value == null || value.isEmpty) {
                return "Introduceti parola.";
              }
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
                onPressed: () {
                  print("Trying to login");
                },
                child: const Text("CONECTARE"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Nu aveti cont?"),
                  TextButton(
                    onPressed: () {
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
}
