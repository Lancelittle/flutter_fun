import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


void main() => runApp(const MyApp());

final currencyFormatter = NumberFormat("#,##0.00", "en_US");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = "Lance's Angels";

    return const MaterialApp(
      title: appTitle,
      home: MyTransactions(title: appTitle),
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key, required this.transactions}) : super(key: key);

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
                leading: Icon(Icons.list),
                trailing: Text(transactions[index].description,
                  style: TextStyle(
                      color: Colors.green,fontSize: 15),),
                title:Text("\$${currencyFormatter.format(transactions[index].amount)}")
            );
          }
      ),
    );
  }
}

class MyTransactions extends StatelessWidget {
  const MyTransactions({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: fetchTransactions(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return TransactionList(transactions: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
Future<List<Transaction>> fetchTransactions(http.Client client) async {
  final response = await http.get(Uri.parse('https://houndstooth-mx.herokuapp.com/users/My-Unique-ID/transactions'));

  return compute(parseTransactions, response.body);
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
