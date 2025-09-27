
# 📱 Book Finder Mobile Application
A Flutter-based mobile application that allows users to search for books using the Open Library API, view detailed information, and save favorites locally.

---

## 1. 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (version 2.17.0 or higher)
- Android Studio/VSCode with Flutter extension
- Android Emulator or physical device

### Installation Steps
##### Step 1: Clone the Project
```bash
git clone <repository-url>
cd book_finder_app
```

##### Step 2: Install Dependencies
```bash
flutter pub get
```

##### Step 3: Run the Application
```bash
flutter run
```

##### Step 4: Build for Production
```bash
flutter build apk --release
# or for iOS
flutter build ios --release
```

### Required Dependencies
The app uses the following key packages:
- `http`: For API calls
- `sqflite`: For local SQLite database
- `cached_network_image`: For efficient image loading and caching
- `shimmer`: For loading animations
- `provider`: For state management

---

## 2. 📁 Project Structure

```
lib/
├── main.dart               # Application entry point
├── data/                   # Data layer implementation
│   ├── local/              # Local data sources
│   │   ├── database/       # SQLite database setup
│   │   └── entities/       # Local data models
│   ├── remote/             # Remote data sources
│   │   ├── api/            # API service classes
│   │   └── models/         # API response models
│   └── repositories/       # Repository implementations
├── domain/                 # Business logic layer
│   ├── entities/           # Core business objects
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
└── presentation/           # UI layer
    ├── splash/             # Splash screen
    ├── book_search/        # Search functionality
    ├── book_detail/        # Book details screen
    └── common/             # Shared UI components
```
---

## 3. 🏗️ Architecture Explanation

MVVM + Clean Architecture Approach
The app follows a multi-layer architecture ensuring separation of concerns and testability:

### Layer 1: Presentation Layer (MVVM)
Views: UI components (Widgets)

ViewModels: Business logic for specific screens

State Management: Using Provider with ChangeNotifier

### Layer 2: Domain Layer (Business Logic)
Entities: Core business objects (Book, User, etc.)

Repositories: Abstract interfaces defining data operations

Use Cases: Application-specific business rules

### Layer 3: Data Layer (Data Sources)
Repositories: Concrete implementations of domain interfaces

Data Sources: Local (SQLite) and Remote (API) data providers

### Data Flow
UI → calls → ViewModel

ViewModel → uses → Use Cases

Use Cases → interact with → Repositories

Repositories → fetch from → Data Sources (Local/Remote)

### Benefits of This Architecture
Testability: Each layer can be tested independently

Maintainability: Clear separation of concerns

Scalability: Easy to add new features

Flexibility: Easy to switch data sources

## 4. 🌐 API Integration

- **Search Books:**  
  `https://openlibrary.org/search.json?title={query}&limit=20&page={page}`

- **Book Cover:**  
  `https://covers.openlibrary.org/b/id/{cover_id}-M.jpg`

- **Book Details:**  
  `https://openlibrary.org/works/{work_id}.json`



## 5. ✨ Features

### 🔍 Search Screen

-`Real-time Search`: Instant search with 3-character minimum validation.

-`Infinite Scrolling`: Pagination for seamless browsing.

-`Shimmer Loading`: Beautiful loading animations during API calls

-`Pull-to-Refresh`: Refresh functionality with smooth animations

-`List View`: Responsive book results display

-`Error Handling`: Comprehensive error states and empty states

### 📖 Book Details Screen

-`Detailed Information`: Title, author, publication year, description

-`Animated Book Cover`: Smooth rotation animation (-45° to +45°)

-`Favorite System`: Save/unsave books to local storage

-`SQLite Database`: Persistent local storage for favorites

-`Loading States`: Elegant loading and error handling

---

## 👨‍💻 Author
Developed by **Saravana Kumar** as part of assignment/project.
