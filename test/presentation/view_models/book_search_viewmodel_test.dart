import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uidai/domain/entities/book.dart';
import 'package:uidai/domain/repositories/book_repository.dart';
import 'package:uidai/presentation/view_models/book_search_viewmodel.dart';

class MockBookRepository extends Mock implements BookRepository {}

void main() {
  group('BookSearchViewModel Tests', () {
    late BookSearchViewModel viewModel;
    late MockBookRepository mockRepository;
    late List<Book> testBooks;

    setUp(() {
      mockRepository = MockBookRepository();
      viewModel = BookSearchViewModel(mockRepository);

      testBooks = [
        Book(
          id: 'OL1W',
          title: 'Book 1',
          authors: ['Author 1'],
          publishYear: 2020,
        ),
        Book(
          id: 'OL2W',
          title: 'Book 2',
          authors: ['Author 2'],
          publishYear: 2021,
        ),
      ];
    });

    test('initial state is correct', () {
      expect(viewModel.books, isEmpty);
      expect(viewModel.isLoading, false);
      expect(viewModel.hasMore, true);
      expect(viewModel.error, isNull);
    });

    test('searchBooks updates state correctly on success', () async {
      when(
        mockRepository.searchBooks('test', 1),
      ).thenAnswer((_) async => testBooks);

      await viewModel.searchBooks('test');
      expect(viewModel.books.length, 2);
      expect(viewModel.isLoading, false);
      expect(viewModel.error, isNull);
      expect(viewModel.searchQuery, 'test');
    });

    test('searchBooks handles errors correctly', () async {
      when(
        mockRepository.searchBooks('test', 1),
      ).thenThrow(Exception('Network error'));

      await viewModel.searchBooks('test');
      expect(viewModel.books, isEmpty);
      expect(viewModel.error, isNotNull);
      expect(viewModel.isLoading, false);
    });

    test('loadMoreBooks increments page and loads more books', () async {
      when(
        mockRepository.searchBooks('test', 1),
      ).thenAnswer((_) async => testBooks);
      when(mockRepository.searchBooks('test', 2)).thenAnswer(
        (_) async => [
          Book(id: 'OL3W', title: 'Book 3', authors: ['Author 3']),
        ],
      );
      await viewModel.searchBooks('test');

      await viewModel.loadMoreBooks();
      expect(viewModel.books.length, 3);
      verify(mockRepository.searchBooks('test', 2)).called(1);
    });

    test('refreshBooks resets state and reloads', () async {
      when(
        mockRepository.searchBooks('test', 1),
      ).thenAnswer((_) async => testBooks);

      await viewModel.searchBooks('test');

      await viewModel.refreshBooks();

      expect(viewModel.books.length, 2);
      verify(mockRepository.searchBooks('test', 1)).called(2);
    });

    test('resetSearch clears all state', () async {
      when(
        mockRepository.searchBooks('test', 1),
      ).thenAnswer((_) async => testBooks);

      await viewModel.searchBooks('test');

      viewModel.resetSearch();

      expect(viewModel.books, isEmpty);
      expect(viewModel.searchQuery, '');
      expect(viewModel.error, isNull);
    });
  });
}
