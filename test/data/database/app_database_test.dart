import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uidai/data/local/database/app_database.dart';
import 'package:uidai/domain/entities/book.dart';
import '../../domain/repositories/book_repository_test.mocks.dart';
void main() {
  group('AppDatabase Tests', () {
    late AppDatabase database;
    late MockBookRepository mockRepository;

    setUpAll(() {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() async {
      mockRepository = MockBookRepository();
      database = AppDatabase();
      final db = await database.database;
      await db.delete('favorites');
    });

    tearDown(() async {
      final db = await database.database;
      await db.close();
    });

    test('saveBook inserts book correctly', () async {
      final book = Book(
        id: 'OL123W',
        title: 'Test Book',
        authors: ['Author 1', 'Author 2'],
        publishYear: 2023,
        coverUrl: 'https://test.com/cover.jpg',
        description: 'Test description',
        isbns: ['1234567890'],
      );

      await mockRepository.saveBook(book);

      final favorites = await mockRepository.getFavoriteBooks();
      expect(favorites.length, 1);
      expect(favorites[0].title, 'Test Book');
      expect(favorites[0].authors, ['Author 1', 'Author 2']);
    });

    test('getFavoriteBooks returns empty list when no favorites', () async {
      final favorites = await mockRepository.getFavoriteBooks();

      expect(favorites, isEmpty);
    });

    test('removeBook deletes book correctly', () async {
      final book = Book(
        id: 'OL123W',
        title: 'Test Book',
        authors: ['Test Author'],
      );
      await mockRepository.saveBook(book);

      await mockRepository.removeBook('OL123W');

      final favorites = await mockRepository.getFavoriteBooks();
      expect(favorites, isEmpty);
    });

    test('isBookFavorite returns correct status', () async {
      final book = Book(
        id: 'OL123W',
        title: 'Test Book',
        authors: ['Test Author'],
      );

      var isFavorite = await mockRepository.isBookFavorite('OL123W');
      expect(isFavorite, false);

      await mockRepository.saveBook(book);
      isFavorite = await mockRepository.isBookFavorite('OL123W');
      expect(isFavorite, true);

      await mockRepository.removeBook('OL123W');
      isFavorite = await mockRepository.isBookFavorite('OL123W');
      expect(isFavorite, false);
    });

    test('saveBook updates existing book', () async {
      final book1 = Book(
        id: 'OL123W',
        title: 'Original Title',
        authors: ['Author 1'],
      );

      final book2 = Book(
        id: 'OL123W',
        title: 'Updated Title',
        authors: ['Author 2'],
      );

      await mockRepository.saveBook(book1);
      await mockRepository.saveBook(book2); // Same ID, should update

      final favorites = await mockRepository.getFavoriteBooks();
      expect(favorites.length, 1);
      expect(favorites[0].title, 'Updated Title');
      expect(favorites[0].authors, ['Author 2']);
    });
  });
}
