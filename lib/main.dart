import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mx_flutter/sign_in.dart';
import 'package:mx_flutter/summary.dart';
import 'package:mx_flutter/transactions.dart';

void main() => runApp(const MyApp());

final currencyFormatter = NumberFormat("#,##0.00", "en_US");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = "Lance's Angels";

    return const MaterialApp(
      title: appTitle,
      home: SignInWidget(),
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key, required this.transactions, required this.summary}) : super(key: key);

  final List<Transaction> transactions;
  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
                leading: Icon(Icons.list),
                title: Text(transactions[index].description,),
                trailing:Text("\$${currencyFormatter.format(transactions[index].amount)}",
                    style: TextStyle(color: (transactions[index].type == "DEBIT") ? Colors.red : Colors.green,fontSize: 15),)
            );
          }
      ),
    );
  }
}
