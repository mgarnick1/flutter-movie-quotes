import 'package:flutter/material.dart';

Row buildBackButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/list'),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back'))
    ],
  );
}