import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uidai/domain/entities/book.dart';
import 'package:uidai/domain/repositories/book_repository.dart';
import 'package:uidai/presentation/views/book_detail_screen.dart';

class MockBookRepository extends Mock implements BookRepository {}

void main() {
  group('BookDetailScreen Widget Tests', () {
    late MockBookRepository mockRepository;
    final testBook = Book(
      id: 'OL123W',
      title: 'Flutter Complete Guide',
      authors: ['Google', 'Dart Team'],
      publishYear: 2023,
      description: 'A complete guide to Flutter development',
      coverUrl: 'https://test.com/cover.jpg',
    );

    setUp(() {
      mockRepository = MockBookRepository();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(home: BookDetailScreen(bookItem: testBook));
    }

    testWidgets('displays loading indicator initially', (
      WidgetTester tester,
    ) async {
      when(
        mockRepository.getBookDetails(testBook),
      ).thenAnswer((_) async => testBook);

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays book details after loading', (
      WidgetTester tester,
    ) async {
      when(
        mockRepository.getBookDetails(testBook),
      ).thenAnswer((_) async => testBook);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Wait for loading to complete

      expect(find.text('Flutter Complete Guide'), findsOneWidget);
      expect(find.text('By Google, Dart Team'), findsOneWidget);
      expect(find.text('Published: 2023'), findsOneWidget);
      expect(
        find.text('A complete guide to Flutter development'),
        findsOneWidget,
      );
    });

    testWidgets('toggles favorite status', (WidgetTester tester) async {
      when(
        mockRepository.getBookDetails(testBook),
      ).thenAnswer((_) async => testBook);
      when(mockRepository.saveBook(testBook)).thenAnswer((_) async => null);
      when(
        mockRepository.removeBook(testBook.id),
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      verify(mockRepository.saveBook(testBook)).called(1);
    });

    testWidgets('shows error message when loading fails', (
      WidgetTester tester,
    ) async {
      when(
        mockRepository.getBookDetails(testBook),
      ).thenThrow(Exception('Book not found'));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Error:'), findsOneWidget);
    });
  });
}
