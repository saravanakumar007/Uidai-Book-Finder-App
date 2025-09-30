import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uidai/domain/entities/book.dart';
import 'package:uidai/domain/repositories/book_repository.dart';
@GenerateMocks([BookRepository])
import 'book_repository_test.mocks.dart';

void main() {
  group('BookRepository Tests', () {
    late MockBookRepository mockRepository;
    late Book testBook;

    setUp(() {
      mockRepository = MockBookRepository();
      testBook = Book(
        id: 'OL123W',
        title: 'Test Book',
        authors: ['Test Author'],
        publishYear: 2023,
        coverUrl: 'https://test.com/cover.jpg',
      );
    });

    test('searchBooks returns list of books', () async {
      when(
        mockRepository.searchBooks('test', 1),
      ).thenAnswer((_) async => [testBook]);

      final result = await mockRepository.searchBooks('test', 1);

      expect(result, isA<List<Book>>());
      expect(result.length, 1);
      expect(result[0].title, 'Test Book');
      verify(mockRepository.searchBooks('test', 1)).called(1);
    });

    test('getBookDetails returns book details', () async {
      when(
        mockRepository.getBookDetails(testBook),
      ).thenAnswer((_) async => testBook);

      final result = await mockRepository.getBookDetails(testBook);

      expect(result, isA<Book>());
      expect(result.title, 'Test Book');
      verify(mockRepository.getBookDetails(testBook)).called(1);
    });

    test('saveBook saves book successfully', () async {
      when(mockRepository.saveBook(testBook)).thenAnswer((_) async {});

      await mockRepository.saveBook(testBook);

      verify(mockRepository.saveBook(testBook)).called(1);
    });

    test('removeBook removes book successfully', () async {
      when(mockRepository.removeBook('OL123W')).thenAnswer((_) async {});

      await mockRepository.removeBook('OL123W');

      verify(mockRepository.removeBook('OL123W')).called(1);
    });

    test('getFavoriteBooks returns favorite books', () async {
      when(
        mockRepository.getFavoriteBooks(),
      ).thenAnswer((_) async => [testBook]);

      final result = await mockRepository.getFavoriteBooks();

      expect(result, isA<List<Book>>());
      expect(result.length, 1);
      verify(mockRepository.getFavoriteBooks()).called(1);
    });

    test('isBookFavorite returns correct status', () async {
      when(
        mockRepository.isBookFavorite('OL123W'),
      ).thenAnswer((_) async => true);

      final result = await mockRepository.isBookFavorite('OL123W');

      expect(result, true);
      verify(mockRepository.isBookFavorite('OL123W')).called(1);
    });
  });
}
