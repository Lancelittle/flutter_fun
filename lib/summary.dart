import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Summary> fetchSummary(String userGuid, String memberGuid) async {
  final response = await http.get(
      Uri.parse('https://houndstooth-mx.herokuapp.com/users/$userGuid/summary?member_guid=$memberGuid'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Summary.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to get summary.');
  }
}

class SummaryResponse {
  final Summary summary;

  const SummaryResponse({required this.summary});

  factory SummaryResponse.fromJson(Map<String, dynamic> json) {
    return SummaryResponse(
      summary: Summary.fromJson(json['summary']),
    );
  }
}

class Summary {
  final double spend;
  final double income;

  const Summary({required this.spend, required this.income});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      spend: json['spend'],
      income: json['income'],
    );
  }
}