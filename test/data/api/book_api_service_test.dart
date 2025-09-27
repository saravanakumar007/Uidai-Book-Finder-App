import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:uidai/data/remote/api/book_api_service.dart';
import 'package:uidai/data/remote/models/book_search_response.dart';

void main() {
  group('BookApiService Integration Tests', () {
    late BookApiService apiService;

    test('searchBooks returns valid response', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString().contains('/search.json?title=test')) {
          return http.Response('''
            {
              "docs": [
                {
                  "title": "Test Book",
                  "author_name": ["Test Author"],
                  "cover_i": 12345,
                  "key": "/works/OL123W",
                  "first_publish_year": 2023
                }
              ],
              "numFound": 1
            }
          ''', 200);
        }
        return http.Response('Not Found', 404);
      });

      apiService = BookApiService(mockClient);

      final response = await apiService.searchBooks('test', 1);

      expect(response, isA<BookSearchResponse>());
      expect(response.docs.length, 1);
      expect(response.docs[0].title, 'Test Book');
      expect(response.numFound, 1);
    });

    test('searchBooks handles network errors', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      apiService = BookApiService(mockClient);

      expect(
        () async => await apiService.searchBooks('test', 1),
        throwsException,
      );
    });

    test('getBookDetails returns valid book details', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString().contains('/works/OL123W')) {
          return http.Response('''
            {
              "title": "Detailed Book",
              "authors": [{"key": "/authors/OL123A", "name": "Test Author"}],
              "first_publish_date": "2023-01-01",
              "description": "Test description"
            }
          ''', 200);
        }
        return http.Response('Not Found', 404);
      });

      apiService = BookApiService(mockClient);

      final response = await apiService.getBookDetails('/works/OL123W');

      expect(response, isA<Map<String, dynamic>>());
      expect(response['title'], 'Detailed Book');
      expect(response['description'], 'Test description');
    });

    test('getCoverUrl returns correct URL', () {
      apiService = BookApiService(http.Client());
      const int coverId = 12345;

      final coverUrl = apiService.getCoverUrl(coverId);

      expect(coverUrl, 'https://covers.openlibrary.org/b/id/12345-M.jpg');
    });
  });
}
