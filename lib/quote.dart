class Quote {
  final int id;
  final String quote;
  final String author;
  final String actor;

  Quote({
    required this.id,
    required this.quote,
    required this.author,
    required this.actor,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        id: json['id'],
        quote: json['quote'],
        author: json['author'],
        actor: json['actor']);
  }
}
