import 'package:flutter/material.dart';
import 'package:flutter_movie_quotes/edit-quote.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'quote.dart';

Future<List<Quote>> fetchQuotes() async {
  final response = await http.get(Uri.parse('http://localhost:3001/quotes'),
      headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List quotes = jsonDecode(response.body);

    return quotes.map((q) => Quote.fromJson(q)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Quotes');
  }
}

class QuotesList extends StatefulWidget {
  const QuotesList({Key? key}) : super(key: key);

  @override
  _QuotesListState createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList> {
  late Future<List<Quote>> futureQuotes;

  @override
  void initState() {
    futureQuotes = fetchQuotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Flutter Movie Quotes')),
        automaticallyImplyLeading: false
      ),
      backgroundColor: Colors.blueGrey,
      body: FutureBuilder<List<Quote>>(
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
                        title: Text(snapshot.data[index].quote),
                        subtitle: Text(snapshot.data[index].author),
                        isThreeLine: true,
                        dense: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.0, bottom: 8.0, top: 0.0),
                            child: Text(snapshot.data[index].actor),
                          ),
                          IconButton(
                              onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditQuote(
                                                quote: snapshot.data[index])))
                                  },
                              icon: const Icon(Icons.edit))
                        ],
                      )
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
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/add'),
          backgroundColor: Colors.blueAccent,
          tooltip: 'Add A Quote',
          child: const Icon(Icons.add)),
    );
  }
}
