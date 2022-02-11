import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Transaction>> fetchTransactions(
    String userGuid, String memberGuid) async {
  final response = await http.get(
    Uri.parse('https://houndstooth-mx.herokuapp.com/users/$userGuid/transactions?member_guid=$memberGuid'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
  );
  if (response.statusCode == 200) {
    var parsed = compute(parseTransactions, response.body);
    return parsed;
  } else {
    throw Exception('Failed to fetch transactions');
  }
}

List<Transaction> parseTransactions(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Transaction>((json) => Transaction.fromJson(json)).toList();
}

class Transaction {
  final String date;
  final String description;
  final String type;
  final String guid;
  final double amount;

  const Transaction(
      {required this.date,
      required this.description,
      required this.type,
      required this.guid,
      required this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date'],
      description: json['description'],
      type: json['type'],
      guid: json['guid'],
      amount: json['amount'],
    );
  }
}
