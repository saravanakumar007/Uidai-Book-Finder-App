
class Book {
  final String id;
  final String title;
  final List<String> authors;
  final int? publishYear;
  final String? coverUrl;
  final String? description;
  final List<String>? isbns;
  final bool isFavorite;

  const Book({
    required this.id,
    required this.title,
    required this.authors,
    this.publishYear,
    this.coverUrl,
    this.description,
    this.isbns,
    this.isFavorite = false,
  });

  Book copyWith({
    String? id,
    String? title,
    List<String>? authors,
    int? publishYear,
    String? coverUrl,
    String? description,
    List<String>? isbns,
    bool? isFavorite,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      publishYear: publishYear ?? this.publishYear,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      isbns: isbns ?? this.isbns,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}