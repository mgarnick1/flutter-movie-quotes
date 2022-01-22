class Quote {
  // final int id;
  final String quote;
  final String author;
  final String actor;
  // final int movieId;

  Quote({
    required this.quote,
    required this.author,
    required this.actor,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        // id: json['id'],
        quote: json['quote'],
        author: json['author'],
        actor: json['actor']);
    // movieId: json['movie_id']);
  }

  Map toMap() {
    var map = Map();
    map['quote'] = quote;
    map['author'] = author;
    map['actor'] = actor;

    return map;
  }
}
