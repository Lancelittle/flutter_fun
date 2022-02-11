import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<User> createUser(String email, String firstName, String lastName) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'firstName': firstName,
      'lastName': lastName
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return const User(guid: "1234");
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class User{
  static User? _instance = null;
  final String guid;

  const User({required this.guid});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      guid: json['guid'],
    );
  }

  static void setState(User user) {
    _instance = user;
  }

  static User? getState() {
    return _instance;
  }
}
