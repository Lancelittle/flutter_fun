import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mx_flutter/transactions.dart';
import 'package:mx_flutter/user.dart';

import 'main.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  bool _signingIn = false;

  void _submit() {
    _loading(true);

    createUser(emailController.text, firstNameController.text,
            lastNameController.text)
        .then((user) {
      Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) async {
        if (timer.tick > 10) {
          timer.cancel();
          _loading(false);
        } else {
          getTransactions().then((transactions) {
            timer.cancel();
            _userCreated();
          });
        }
      });
    });
  }

  void _userCreated() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const MyTransactions(title: "hello")),
    );
    _loading(false);
  }

  void _loading(bool loading) {
    setState(() {
      _signingIn = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoadingOverlay(
            isLoading: _signingIn,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          "Lance's Angels",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20),
                        )),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller: firstNameController,
                        keyboardType: TextInputType.name,
                        decoration:
                            const InputDecoration(labelText: 'First Name'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.blue, width: 2),
                          ),
                          child: const Text(
                            'Super Secure Sign In',
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            _submit();
                          },
                        )),
                  ],
                ))));
  }
}
