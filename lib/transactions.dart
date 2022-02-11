import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Transaction>> fetchTransactions(String userGuid, String memberGuid) async {
  final response = await http.get(Uri.parse('https://houndstooth-mx.herokuapp.com/users/$userGuid/transactions?member_guid=$memberGuid'));
  if (response.statusCode == 200) {
    return compute(parseTransactions, response.body);
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
  final double amount;

  const Transaction({
    required this.date,
    required this.description,
    required this.type,
    required this.amount
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date'],
      description: json['description'],
      type: json['type'],
      amount: json['amount'],
    );
  }
}