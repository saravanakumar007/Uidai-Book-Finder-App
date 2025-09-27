
import 'package:uidai/domain/entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> searchBooks(String query, int page);
  Future<Book> getBookDetails(Book bookItem);
  Future<List<Book>> getFavoriteBooks();
  Future<void> saveBook(Book book);
  Future<void> removeBook(String bookId);
  Future<bool> isBookFavorite(String bookId);
}