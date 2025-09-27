import 'package:sqflite/sqflite.dart';
import 'package:uidai/data/local/database/app_database.dart';
import 'package:uidai/data/remote/api/book_api_service.dart';
import 'package:uidai/domain/entities/book.dart';
import 'package:uidai/domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final BookApiService _apiService;
  final AppDatabase _database;

  BookRepositoryImpl(this._apiService, this._database);

  @override
  Future<List<Book>> searchBooks(String query, int page) async {
    final response = await _apiService.searchBooks(query, page);
    
    return response.docs.map((doc) {
      return Book(
        id: doc.key,
        title: doc.title,
        authors: doc.authorName,
        publishYear: doc.firstPublishYear,
        coverUrl: doc.coverId != null 
            ? _apiService.getCoverUrl(doc.coverId!)
            : null,
      );
    }).toList();
  }

  @override
  Future<Book> getBookDetails(Book bookItem) async {
    final details = await _apiService.getBookDetails(bookItem.id);
    final isFavorite = await isBookFavorite(bookItem.id);
   return  bookItem.copyWith(
      description: details['description'] != null &&  details['description']  is String
          ? details['description']
          : details['description']?['value'],
      isFavorite: isFavorite,
    );
  }

  @override
  Future<void> saveBook(Book book) async {
    final db = await _database.database;
    await db.insert('favorites', {
      'id': book.id,
      'title': book.title,
      'authors': book.authors.join(','),
      'publishYear': book.publishYear,
      'coverUrl': book.coverUrl,
      'description': book.description,
      'isbns': book.isbns?.join(','),
      'savedAt': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> removeBook(String bookId) async {
    final db = await _database.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [bookId]);
  }

  @override
  Future<List<Book>> getFavoriteBooks() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    
    return maps.map((map) {
      return Book(
        id: map['id'],
        title: map['title'],
        authors: map['authors'].split(','),
        publishYear: map['publishYear'],
        coverUrl: map['coverUrl'],
        description: map['description'],
        isbns: map['isbns']?.split(','),
        isFavorite: true,
      );
    }).toList();
  }

  @override
  Future<bool> isBookFavorite(String bookId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [bookId],
    );
    return maps.isNotEmpty;
  }
}