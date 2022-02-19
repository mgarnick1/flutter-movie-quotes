import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'quote.dart';
import 'back-button.dart';

Future<Map<String, dynamic>> createQuote(Quote? body) async {
  return await http
      .post(Uri.parse('http://localhost:3001/quotes/add'),
          headers: {"Content-Type": "application/json"}, body: jsonEncode(body))
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      throw Exception("Error adding Quote");
    }
    Map<String, dynamic> newQuote = json.decode(response.body);
    return newQuote;
  });
}

class AddQuote extends StatefulWidget {
  const AddQuote({Key? key}) : super(key: key);

  @override
  _AddQuoteState createState() {
    return _AddQuoteState();
  }
}

class _AddQuoteState extends State<AddQuote> {
  final _formKey = GlobalKey<FormState>();
  final quoteController = TextEditingController();
  final authorController = TextEditingController();
  final actorController = TextEditingController();

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
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Adding Quote')));
                      Quote newQuote = new Quote(
                          quote: quoteController.text,
                          author: authorController.text,
                          actor: actorController.text);
                      await createQuote(newQuote);
                      quoteController.clear();
                      authorController.clear();
                      actorController.clear();
                      Navigator.pushNamed(context, '/list');
                    }
                  },
                  child: const Text('Add Quote'),
                ),
              ),
              buildBackButton(context),
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
