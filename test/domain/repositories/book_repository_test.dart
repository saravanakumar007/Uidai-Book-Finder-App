// test/unit/domain/repositories/book_repository_test.dart
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
      // Arrange
      when(mockRepository.searchBooks('test', 1))
          .thenAnswer((_) async => [testBook]);

      // Act
      final result = await mockRepository.searchBooks('test', 1);

      // Assert
      expect(result, isA<List<Book>>());
      expect(result.length, 1);
      expect(result[0].title, 'Test Book');
      verify(mockRepository.searchBooks('test', 1)).called(1);
    });

    test('getBookDetails returns book details', () async {
      // Arrange
      when(mockRepository.getBookDetails(testBook))
          .thenAnswer((_) async => testBook);

      // Act
      final result = await mockRepository.getBookDetails(testBook);

      // Assert
      expect(result, isA<Book>());
      expect(result.title, 'Test Book');
      verify(mockRepository.getBookDetails(testBook)).called(1);
    });

    test('saveBook saves book successfully', () async {
      // Arrange
      when(mockRepository.saveBook(testBook)).thenAnswer((_) async {});

      // Act
      await mockRepository.saveBook(testBook);

      // Assert
      verify(mockRepository.saveBook(testBook)).called(1);
    });

    test('removeBook removes book successfully', () async {
      // Arrange
      when(mockRepository.removeBook('OL123W')).thenAnswer((_) async {});

      // Act
      await mockRepository.removeBook('OL123W');

      // Assert
      verify(mockRepository.removeBook('OL123W')).called(1);
    });

    test('getFavoriteBooks returns favorite books', () async {
      // Arrange
      when(mockRepository.getFavoriteBooks())
          .thenAnswer((_) async => [testBook]);

      // Act
      final result = await mockRepository.getFavoriteBooks();

      // Assert
      expect(result, isA<List<Book>>());
      expect(result.length, 1);
      verify(mockRepository.getFavoriteBooks()).called(1);
    });

    test('isBookFavorite returns correct status', () async {
      // Arrange
      when(mockRepository.isBookFavorite('OL123W'))
          .thenAnswer((_) async => true);

      // Act
      final result = await mockRepository.isBookFavorite('OL123W');

      // Assert
      expect(result, true);
      verify(mockRepository.isBookFavorite('OL123W')).called(1);
    });
  });
}