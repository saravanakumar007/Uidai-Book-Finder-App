
class BookSearchResponse {
  final List<BookDoc> docs;
  final int numFound;

  BookSearchResponse({required this.docs, required this.numFound});

  factory BookSearchResponse.fromJson(Map<String, dynamic> json) {
    return BookSearchResponse(
      docs: (json['docs'] as List)
          .map((doc) => BookDoc.fromJson(doc))
          .toList(),
      numFound: json['numFound'] ?? 0,
    );
  }
}

class BookDoc {
  final String title;
  final List<String> authorName;
  final int? coverId;
  final String key;
  final int? firstPublishYear;
  final List<String>? isbn;

  BookDoc({
    required this.title,
    required this.authorName,
    this.coverId,
    required this.key,
    this.firstPublishYear,
    this.isbn,
  });

  factory BookDoc.fromJson(Map<String, dynamic> json) {
    return BookDoc(
      title: json['title'] ?? 'Unknown Title',
      authorName: List<String>.from(json['author_name'] ?? []),
      coverId: json['cover_i'],
      key: json['key'] ?? '',
      firstPublishYear: json['first_publish_year'],
      isbn: json['isbn'] != null ? List<String>.from(json['isbn']) : null,
    );
  }
}