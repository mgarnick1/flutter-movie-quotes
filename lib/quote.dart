class Quote {
  final int? id;
  final String quote;
  final String author;
  final String actor;
  final int? movieId;

  Quote(
      {this.id,
      required this.quote,
      required this.author,
      required this.actor,
      this.movieId});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        id: json['id'],
        quote: json['quote'],
        author: json['author'],
        actor: json['actor'],
        movieId: json['movie_id']);
  }

  Map<String, dynamic> toJson() {
    return {'quote': this.quote, 'author': this.author, 'actor': this.actor};
  }
}
