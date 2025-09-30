import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:uidai/domain/entities/book.dart';
import 'package:uidai/presentation/view_models/book_search_viewmodel.dart';
import 'package:uidai/presentation/views/book_search_screen.dart';
import '../../domain/repositories/book_repository_test.mocks.dart';

void main() {
  group('BookSearchScreen Widget Tests', () {
    late MockBookRepository mockRepository;
    late BookSearchViewModel viewModel;

    setUp(() {
      mockRepository = MockBookRepository();
      viewModel = BookSearchViewModel(mockRepository);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ChangeNotifierProvider<BookSearchViewModel>.value(
          value: viewModel,
          child: BookSearchScreen(),
        ),
      );
    }

    testWidgets('displays initial empty state', (WidgetTester tester) async {
      
      when(mockRepository.searchBooks('test', 1))
          .thenAnswer((_) async => []);

      
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Book Finder'), findsOneWidget);
      expect(find.text('Search for books...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows loading indicator when searching', (WidgetTester tester) async {
      
    when(mockRepository.searchBooks('test', 1))
          .thenAnswer((_) async => []);

      
      await tester.pumpWidget(createWidgetUnderTest());
  
      await tester.enterText(find.byType(TextField), 'flutter');
      await tester.pump(); 

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays book results', (WidgetTester tester) async {
      
      final testBooks = [
        Book(
          id: 'OL1W',
          title: 'Flutter Guide',
          authors: ['Google'],
          publishYear: 2023,
        ),
      ];

      
      when(mockRepository.searchBooks('test', 1))
          .thenAnswer((_) async => testBooks);

      
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), 'flutter');
      await tester.pumpAndSettle();

      expect(find.text('Flutter Guide'), findsOneWidget);
      expect(find.text('By Google'), findsOneWidget);
    });

    testWidgets('navigates to book details on tap', (WidgetTester tester) async {
      
      final testBooks = [
        Book(
          id: 'OL1W',
          title: 'Test Book',
          authors: ['Test Author'],
        ),
      ];
      
      when(mockRepository.searchBooks('test', 1))
          .thenAnswer((_) async => testBooks);

      
      await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider<BookSearchViewModel>.value(
          value: viewModel,
          child: BookSearchScreen(),
        ),
        routes: {
          '/book_detail': (context) => Scaffold(body: Text('Book Detail Screen')),
        },
      ));
      
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      
      await tester.tap(find.text('Test Book'));
      await tester.pumpAndSettle();

     
      expect(find.text('Book Detail Screen'), findsOneWidget);
    });

    testWidgets('shows error message when search fails', (WidgetTester tester) async {
      
      when(mockRepository.searchBooks('test', 1))
          .thenThrow(Exception('Network error'));

      
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();


      expect(find.text('Error:'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}