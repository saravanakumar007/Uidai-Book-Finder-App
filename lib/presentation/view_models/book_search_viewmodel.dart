import 'package:flutter/material.dart';
import 'package:uidai/domain/entities/book.dart';
import 'package:uidai/domain/repositories/book_repository.dart';

class BookSearchViewModel with ChangeNotifier {
  final BookRepository _bookRepository;
  
  List<Book> _books = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _searchQuery = '';
  int _currentPage = 1;
  bool _hasMore = true;
  String? _error;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String get searchQuery => _searchQuery;
  bool get hasMore => _hasMore;
  String? get error => _error;

  BookSearchViewModel(this._bookRepository);

  Future<void> searchBooks(String query, {bool isRefresh = false}) async {
    if (query.isEmpty) {
      _books = [];
      _hasMore = false;
      _currentPage = 1;
      notifyListeners();
      return;
    }

    if (isRefresh) {
      _currentPage = 1;
      _hasMore = true;
      _isLoading = true;
    } else if (_currentPage == 1) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    
    _searchQuery = query;
    _error = null;
    notifyListeners();

    try {
      final results = await _bookRepository.searchBooks(query, _currentPage);
      
      if (isRefresh || _currentPage == 1) {
        _books = results;
      } else {
        _books.addAll(results);
      }
      
      _hasMore = results.length == 20;
      
    } catch (e) {
      _error = e.toString();
      if (_currentPage == 1) {
        _books = [];
      }
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreBooks() async {
    if (_isLoadingMore || !_hasMore || _searchQuery.isEmpty) return;
    
    _currentPage++; 
    await searchBooks(_searchQuery);
  }

  Future<void> refreshBooks() async {
    if (_searchQuery.isEmpty) return;
    await searchBooks(_searchQuery, isRefresh: true);
  }

  void resetSearch() {
    _books = [];
    _searchQuery = '';
    _currentPage = 1;
    _hasMore = true;
    _error = null;
    notifyListeners();
  }
}