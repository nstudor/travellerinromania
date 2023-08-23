import 'dart:io';
import 'dart:convert';
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
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword =
      TextEditingController();
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
            controller: _controllerUsername,
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
              if (value == null || value.isEmpty) {
                return "Introduceti numele.";
              }
              return null;
            },
            onEditingComplete: () => _focusNodeEmail.requestFocus(),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _controllerEmail,
            focusNode: _focusNodeEmail,
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
              if (value == null || value.isEmpty) {
                return "Introduceti email.";
              } else if (!(value.contains('@') && value.contains('.'))) {
                return "Email invalid ";
              }
              return null;
            },
            onEditingComplete: () => _focusNodePassword.requestFocus(),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _controllerPassword,
            obscureText: _obscurePassword,
            focusNode: _focusNodePassword,
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
              } else if (value.length < 8) {
                return "Parola trebuie sa aiba lungime minima 8.";
              }
              return null;
            },
            onEditingComplete: () => _focusNodeConfirmPassword.requestFocus(),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _controllerConFirmPassword,
            obscureText: _obscurePassword,
            focusNode: _focusNodeConfirmPassword,
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
              if (value == null || value.isEmpty) {
                return "Introduceti parola.";
              } else if (value != _controllerPassword.text) {
                return "Parolele nu coincid.";
              }
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
                onPressed: () {
                  // if (_formKey.currentState?.validate() ?? false) {

                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       width: 200,
                  //       backgroundColor:
                  //           Theme.of(context).colorScheme.secondary,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       behavior: SnackBarBehavior.floating,
                  //       content: const Text("Registered Successfully"),
                  //     ),
                  //   );

                  //   // _formKey.currentState?.reset();

                  //   Navigator.pop(context);
                  // }
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
}
