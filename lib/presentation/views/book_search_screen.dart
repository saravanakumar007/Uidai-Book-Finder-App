import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uidai/data/local/database/app_database.dart';
import 'package:uidai/data/remote/api/book_api_service.dart';
import 'package:uidai/data/repositories/book_repository_impl.dart';
import 'package:uidai/domain/entities/book.dart';
import 'package:uidai/presentation/view_models/book_search_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:uidai/presentation/views/book_detail_screen.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final BookSearchViewModel _viewModel = BookSearchViewModel(
    BookRepositoryImpl(BookApiService(http.Client()), AppDatabase()),
  );

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChange);
    _scrollController.addListener(_onScroll);
  }

  void _onViewModelChange() {
    setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _viewModel.loadMoreBooks();
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      _viewModel.resetSearch();
    } else {
      _viewModel.searchBooks(query);
    }
  }

  Future<void> _onRefresh() async {
    if (_viewModel.searchQuery.isNotEmpty) {
      await _viewModel.refreshBooks();
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for books...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _viewModel.resetSearch();
                  },
                )
              : null,
        ),
        onChanged: _performSearch,
      ),
    );
  }

  Widget _buildBookItem(Book book) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: book.coverUrl != null
            ? CachedNetworkImage(
                imageUrl: book.coverUrl!,
                width: 50,
                height: 70,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(width: 50, height: 70, color: Colors.white),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50,
                  height: 70,
                  color: Colors.grey,
                  child: Icon(Icons.broken_image, color: Colors.white),
                ),
              )
            : Container(
                width: 50,
                height: 70,
                color: Colors.grey,
                child: Icon(Icons.book, color: Colors.white),
              ),
        title: Text(
          book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.authors.isNotEmpty)
              Text(
                'By ${book.authors.join(', ')}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (book.publishYear != null)
              Text('Published: ${book.publishYear}'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(bookItem: book),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: Container(width: 50, height: 70, color: Colors.white),
            title: Container(height: 16, color: Colors.white),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, color: Colors.white),
                SizedBox(height: 4),
                Container(height: 12, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Error: ${_viewModel.error}',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_viewModel.searchQuery.isNotEmpty) {
                _viewModel.searchBooks(_viewModel.searchQuery);
              }
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            _searchController.text.length < 3
                ? 'Enter the characters to search'
                : 'No books found for "${_viewModel.searchQuery}"',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_viewModel.error != null && _viewModel.books.isEmpty) {
      return _buildErrorWidget();
    }

    if (_viewModel.isLoading && _viewModel.books.isEmpty) {
      return _buildShimmerLoading();
    }

    if (_viewModel.books.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _viewModel.books.length + (_viewModel.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _viewModel.books.length) {
            return _buildLoadingMoreIndicator();
          }
          return _buildBookItem(_viewModel.books[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Finder'), backgroundColor: Colors.blue),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
