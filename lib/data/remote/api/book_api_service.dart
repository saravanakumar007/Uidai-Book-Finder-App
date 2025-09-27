import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uidai/data/remote/models/book_search_response.dart';

class BookApiService {
  static const String _baseUrl = 'https://openlibrary.org';
  final http.Client _client;

  BookApiService(this._client);

  Future<BookSearchResponse> searchBooks(String query, int page) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/search.json?title=$query&limit=20&page=$page'),
    );

    if (response.statusCode == 200) {
      return BookSearchResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<Map<String, dynamic>> getBookDetails(String workId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl$workId.json'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch book details');
    }
  }

  String getCoverUrl(int coverId) {
    return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
  }
}