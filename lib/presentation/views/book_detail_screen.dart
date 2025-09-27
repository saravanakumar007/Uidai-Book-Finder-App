import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uidai/data/local/database/app_database.dart';
import 'package:uidai/data/remote/api/book_api_service.dart';
import 'package:uidai/data/repositories/book_repository_impl.dart';
import 'package:uidai/domain/entities/book.dart';
import 'package:uidai/domain/repositories/book_repository.dart';
import 'package:http/http.dart' as http;

class BookDetailScreen extends StatefulWidget {

  final Book bookItem;

  const BookDetailScreen({super.key, required this.bookItem });

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  
  final BookRepository _repository = BookRepositoryImpl(
    BookApiService(http.Client()),
    AppDatabase(),
  );
  Book? _book;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);
    
    
    _rotationAnimation = Tween<double>(
      begin: -45.0,
      end: 45.0,    
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _loadBookDetails();
  }

  Future<void> _loadBookDetails() async {
    try {
      _book = await _repository.getBookDetails(widget.bookItem);
    } catch (e) {
      _error = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_book == null) return;

    setState(() {
      _book = _book!.copyWith(isFavorite: !_book!.isFavorite);
    });

    if (_book!.isFavorite) {
      await _repository.saveBook(_book!);
    } else {
      await _repository.removeBook(_book!.id);
    }
  }

  Widget _buildAnimatedCover() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        final angleInRadians = _rotationAnimation.value * (3.14159 / 180.0);     
        return Transform.rotate(
          angle: angleInRadians,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: _book?.coverUrl != null
            ? CachedNetworkImage(
                imageUrl: _book!.coverUrl!,
                width: 200,
                height: 300,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 200,
                  height: 300,
                  color: Colors.grey[300],
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 200,
                  height: 300,
                  color: Colors.grey,
                  child: Icon(Icons.broken_image, size: 50, color: Colors.white),
                ),
              )
            : Container(
                width: 200,
                height: 300,
                color: Colors.grey,
                child: Icon(Icons.book, size: 50, color: Colors.white),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
        actions: [
          IconButton(
            icon: Icon(_book?.isFavorite == true 
                ? Icons.favorite 
                : Icons.favorite_border),
            onPressed: _toggleFavorite,
            color: _book?.isFavorite == true ? Colors.red : null,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _book == null
                  ? Center(child: Text('Book not found'))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Center(child: 
                          _buildAnimatedCover()),
                          SizedBox(height: 30),
                          Text(
                            _book!.title,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'By ${_book!.authors.join(', ')}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_book!.publishYear != null) ...[
                            SizedBox(height: 10),
                            Text(
                              'Published: ${_book!.publishYear}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                          if (_book!.description != null) ...[
                            SizedBox(height: 30),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                _book!.description!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}