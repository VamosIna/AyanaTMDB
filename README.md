# AyanaTMDB 🎬

A Flutter application inspired by Netflix UI, powered by [The Movie Database (TMDB)](https://www.themoviedb.org/) API.  
Features include browsing popular and trending movies, searching, adding to favorites (My List), offline support, and multi-language (EN/ID).

---

## 🚀 Features
- **HomePage Netflix-style**
  - Hero carousel with backdrop, title, and quick actions
  - Horizontal carousels: Popular, Trending (Now Playing), Watchlist
  - Bottom navigation (Home, Search, My List, Profile)
- **Search**
  - Search movies with debounce
  - Recent searches
- **Favorites (My List)**
  - Add/remove movies to favorites
  - Persistent storage with Hive
- **Detail Page**
  - Movie details, overview, recommendations
- **Offline Support**
  - Cache-first strategy with Hive
  - Offline banner when no internet
- **Internationalization (i18n)**
  - English 🇺🇸 and Indonesian 🇮🇩
- **State Management**
  - BLoC (flutter_bloc)
- **Dependency Injection**
  - get_it + RepositoryProvider

---

## 🛠️ Tech Stack
- **Flutter** (Dart)
- **BLoC** for state management
- **Hive** for local storage & caching
- **Dio** for networking
- **GetIt** for dependency injection
- **GoRouter** for navigation
- **Connectivity Plus** for offline detection
- **Intl** for i18n

---

## 📂 Project Structure
```
ayana_tmdb/
 ├── android/                        # Android native project
 ├── ios/                            # iOS native project
 ├── assets/                         # Static assets (fonts, images, translations)
 │   ├── fonts/
 │   ├── images/
 │   └── translations/
 ├── lib/
 │   ├── app/                        # App entry, router, theme, env
 │   │   ├── app.dart
 │   │   ├── config.dart
 │   │   ├── env.dart
 │   │   ├── router.dart
 │   │   └── theme.dart
 │   ├── bootstrap.dart              # App bootstrap
 │   ├── core/                       # Core utilities, DI, network, error handling
 │   │   ├── constants/              # API constants, UI constants
 │   │   ├── di/                     # Dependency injection setup
 │   │   ├── error/                  # Failures, exceptions
 │   │   ├── network/                # Dio client, interceptors
 │   │   ├── utils/                  # Helpers (date formats, debounce, result)
 │   │   └── widgets/                # Shared widgets (loading, error, empty state, offline banner)
 │   ├── features/                   # Feature-based modules
 │   │   └── movies/                 # Movies feature
 │   │       ├── data/               # Data layer
 │   │       │   ├── datasources/    # Local (Hive) & remote (API) datasources
 │   │       │   ├── models/         # Data models (Movie, Genre, MovieDetail, etc.)
 │   │       │   └── repositories/   # Repository implementations
 │   │       ├── domain/             # Domain layer
 │   │       │   ├── entities/       # Core entities (Movie, MovieDetail, Genre)
 │   │       │   ├── repositories/   # Repository contracts
 │   │       │   └── usecases/       # Use cases (GetPopularMovies, SearchMovies, etc.)
 │   │       └── presentation/       # Presentation layer
 │   │           ├── blocs/          # BLoC state management
 │   │           │   ├── detail/
 │   │           │   ├── favorite/
 │   │           │   ├── now_playing/
 │   │           │   ├── popular/
 │   │           │   └── search/
 │   │           ├── pages/          # Screens (HomePage, DetailPage, SearchPage, FavoritesPage)
 │   │           └── widgets/        # UI components (HeroCarousel, MovieCard, Section lists, etc.)
 │   ├── l10n/                       # Localization files (.arb)
 │   └── main.dart                   # App entry point
 ├── scripts/                        # Utility scripts (format, codegen)
 ├── test/                           # Unit & widget tests
 │   ├── movies_repository_test.dart
 │   └── widget_test.dart
 ├── pubspec.yaml                    # Flutter dependencies
 ├── analysis_options.yaml            # Linting rules
 ├── README.md
 └── app-release.apk                 # Built APK (copied for convenience)
```

---

## ⚙️ Setup & Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart (>=3.0.0)
- Android Studio / Xcode for mobile builds

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/VamosIna/AyanaTMDB.git
   cd AyanaTMDB
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Add your TMDB API key:
   - Create `.env` or use `--dart-define`:
     ```bash
     flutter run --dart-define=API_KEY=your_tmdb_api_key
     ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## 📦 Build APK
To generate a release APK:
```bash
flutter build apk --release
```

The generated APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

For convenience, the APK is also copied to the project root:  
👉 [Download AyanaTMDB APK](./app-release.apk)

---

## 🧪 Testing
Run unit and widget tests:
```bash
flutter test
```

Example test: `test/movies_repository_test.dart`

---

## 🤖 CI/CD
GitHub Actions workflow runs:
- `flutter format .`
- `flutter analyze`
- `flutter test`

---

## 📸 Screenshots / Demo GIF
| HomePage | Search | Detail | Favorites |
|----------|--------|--------|-----------|
| ![Home](assets/screenshots/home.png) | ![Search](assets/screenshots/search.png) | ![Detail](assets/screenshots/detail.png) | ![Favorites](assets/screenshots/favorites.png) |

*(Add your screenshots in `assets/screenshots/`)*

---

## 📦 Deliverables
- ✅ Public GitHub repository: [AyanaTMDB](https://github.com/VamosIna/AyanaTMDB)
- ✅ README with setup, features, architecture, screenshots
- ✅ Screenshots/demo GIFs
- ✅ Minimal 1 unit test in `test/` and passing in CI
- ✅ Release APK build instructions + download link

---

## 📜 License
MIT License © 2025 VamosIna
