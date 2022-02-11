import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<User> createUser(String email, String firstName, String lastName) async {
  final response = await http.post(
    Uri.parse('https://houndstooth-mx.herokuapp.com/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'first_name': firstName,
      'last_name': lastName
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class User{
  final String guid;
  final String memberGuid;

  const User({required this.guid, required this.memberGuid});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      guid: json['guid'],
      memberGuid: json['member_guid'],
    );
  }
}
