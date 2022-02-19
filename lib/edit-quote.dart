import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'quote.dart';
import 'back-button.dart';

Future<Map<String, dynamic>> editQuote(Quote? body) async {
  return await http
      .put(Uri.parse('http://localhost:3001/quotes/${body?.id}'),
          headers: {"Content-Type": "application/json"}, body: jsonEncode(body))
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception("Error Editing Quote");
    }
    Map<String, dynamic> newQuote = json.decode(response.body);
    return newQuote;
  });
}

Future<Map<String, dynamic>> deleteQuote(Quote? body) async {
  return await http
      .delete(Uri.parse('http://localhost:3001/quotes/${body?.id}'),
          headers: {"Content-Type": "application/json"}, body: jsonEncode(body))
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception("Error deleting Quote");
    }
    Map<String, dynamic> newQuote = json.decode(response.body);
    return newQuote;
  });
}

class EditQuote extends StatefulWidget {
  final Quote quote;
  EditQuote({Key? key, required this.quote}) : super(key: key);

  @override
  _EditQuoteState createState() => _EditQuoteState();
}

class _EditQuoteState extends State<EditQuote> {
  final _formKey = GlobalKey<FormState>();
  var quoteController = TextEditingController();
  var authorController = TextEditingController();
  var actorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    quoteController = TextEditingController(text: widget.quote.quote);
    authorController = TextEditingController(text: widget.quote.author);
    actorController = TextEditingController(text: widget.quote.actor);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    quoteController.dispose();
    authorController.dispose();
    actorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Flutter Movie Quotes'),
            automaticallyImplyLeading: false),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildFormInputs(
                  'Please enter a movie quote', _formKey, quoteController),
              _buildFormInputs(
                  'Please enter the quote author', _formKey, actorController),
              _buildFormInputs(
                  'Please enter the actors name', _formKey, authorController),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Editing Quote')));
                            Quote newQuote = new Quote(
                                id: widget.quote.id,
                                quote: quoteController.text,
                                author: authorController.text,
                                actor: actorController.text,
                                movieId: widget.quote.movieId);
                            await editQuote(newQuote);
                            quoteController.clear();
                            authorController.clear();
                            actorController.clear();
                            Navigator.pushNamed(context, '/list');
                          }
                        },
                        child: const Text('Edit Quote'),
                      ),
                      ElevatedButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Delete Quote'),
                                  content: const Text(
                                      'Are you sure you want to delete this quote?'),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () async {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content:
                                                      Text('Deleted Quote')));
                                          Quote removeQuote = new Quote(
                                              id: widget.quote.id,
                                              quote: quoteController.text,
                                              author: authorController.text,
                                              actor: actorController.text,
                                              movieId: widget.quote.movieId);
                                          await deleteQuote(removeQuote);
                                          quoteController.clear();
                                          authorController.clear();
                                          actorController.clear();
                                          Navigator.pushNamed(context, '/list');
                                        },
                                        child: const Text('Yes')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('No'))
                                  ],
                                ))

                        // await editQuote(newQuote);
                        ,
                        child: const Text('Delete Quote'),
                      )
                    ],
                  )),
              buildBackButton(context)
            ],
          ),
        ));
  }
}

Padding _buildFormInputs(String hint, formKey, controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    child: TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: hint),
    ),
  );
}
