import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uidai/presentation/views/book_search_screen.dart';

class BookCoversSplashScreen extends StatefulWidget {
  @override
  _BookCoversSplashScreenState createState() => _BookCoversSplashScreenState();
}

class _BookCoversSplashScreenState extends State<BookCoversSplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentCoverIndex = 0;
  
  final List<String> _bookCovers = [
    'https://covers.openlibrary.org/b/id/8259447-L.jpg',
    'https://covers.openlibrary.org/b/id/8397243-L.jpg',
    'https://covers.openlibrary.org/b/id/8907847-L.jpg',
    'https://covers.openlibrary.org/b/id/9255566-L.jpg',
  ];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
   
    _startCoverAnimation();
    
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BookSearchScreen()),
      );
    });
  }

  void _startCoverAnimation() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _currentCoverIndex = (_currentCoverIndex + 1) % _bookCovers.length;
        });
        _startCoverAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
    
          AnimatedSwitcher(
            duration: Duration(milliseconds: 800),
            child: Container(
              key: ValueKey(_currentCoverIndex),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(_bookCovers[_currentCoverIndex]),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
       
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _fadeAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_stories,
                      size: 50,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                
                  Text(
                    'Book Finder',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                
                  Text(
                    'Your Gateway to Infinite Stories',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  
                  SizedBox(height: 40),
                  
                 
                  Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}