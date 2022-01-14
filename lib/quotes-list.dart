import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'quote.dart';

Future<List<dynamic>> fetchQuotes() async {
  final response = await http.get(Uri.parse('http://localhost:3001/quotes'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var quotes = jsonDecode(response.body);
    return quotes;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class QuotesList extends StatefulWidget {
  const QuotesList({Key? key}) : super(key: key);

  @override
  _QuotesListState createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList> {
  late Future<List<dynamic>> futureQuotes;

  @override
  void initState() {
    super.initState();
    futureQuotes = fetchQuotes();
  }

  int _id(dynamic quote) {
    return quote['id'];
  }

  String _quote(dynamic quote) {
    return quote['quote'];
  }

  String _author(dynamic quote) {
    return quote['author'];
  }

  String _actor(dynamic quote) {
    return quote['actor'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futureQuotes,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(_quote(snapshot.data[index])),
                      subtitle: Text(_author(snapshot.data[index])),
                      isThreeLine: true,
                      dense: true,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0, bottom: 8.0),
                      child: Text(_actor(snapshot.data[index])),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
