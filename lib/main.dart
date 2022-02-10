import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Isolate Demo';

    return const MaterialApp(
      title: appTitle,
      home: MyPokemon(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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

// class TransactionList extends StatelessWidget {
//   const TransactionList({Key? key, required this.transactions}) : super(key: key);
//
//   final List<Transaction> transactions;
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       itemCount: transactions.length,
//       itemBuilder: (context, index) {
//         return Image.network(transactions[index].thumbnailUrl);
//       },
//     );
//   }
// }

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key, required this.transactions}) : super(key: key);

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("ListView.builder")
      ),
      body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
                leading: Icon(Icons.list),
                trailing: Text("GFG",
                  style: TextStyle(
                      color: Colors.green,fontSize: 15),),
                title:Text("List item $index")
            );
          }
      ),
    );
  }
}

class MyPokemon extends StatelessWidget {
  const MyPokemon({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<PokemonResponse>(
        future: fetchPokemon(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PokemonList(pokemonResponse: snapshot.data!);
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

class PokemonList extends StatelessWidget {
  const PokemonList({Key? key, required this.pokemonResponse}) : super(key: key);

  final PokemonResponse pokemonResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("ListView.builder")
      ),
      body: ListView.builder(
          itemCount: pokemonResponse.count,
          itemBuilder: (BuildContext context,int index){
            return ListTile(
                leading: Text(pokemonResponse.results[index].name),
                trailing: Text(pokemonResponse.results[index].url,
                  style: const TextStyle(color: Colors.blue,fontSize: 15),),
                title:Text("List item $index")
            );
          }
      ),
    );
  }
}

Future<List<Transaction>> fetchTransactions(http.Client client) async {
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1118'));

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
  final int amount;

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

Future<PokemonResponse> fetchPokemon(http.Client client) async {
  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1118'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return pokemonFromJson(response.body);
}

PokemonResponse pokemonFromJson(String str) => PokemonResponse.fromJson(json.decode(str));

class PokemonResponse {
  int count;
  List<Pokemon> results;

  PokemonResponse({
    required this.count,
    required this.results
  });

  factory PokemonResponse.fromJson(Map<String, dynamic> json) => PokemonResponse(
    count: json["count"],
    results: List<Pokemon>.from(json["results"].map((x) => Pokemon.fromJson(x))),
  );
}

class Pokemon {
  String name;
  String url;

  Pokemon({
    required this.name,
    required this.url,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
    name: json["name"],
    url: json["url"],
  );
}
