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
lib/
 ├── app/                # App entry, router, theme, env
 ├── core/               # Core utilities, DI, network, error handling
 ├── features/movies/    # Movies feature (data, domain, presentation)
 │   ├── data/           # Models, datasources, repositories
 │   ├── domain/         # Entities, repositories, usecases
 │   └── presentation/   # Blocs, pages, widgets
 ├── l10n/               # Localization files
 └── main.dart           # Entry point
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

You can download the latest built APK from the repository’s **Releases** section:  
👉 [Download AyanaTMDB APK](https://github.com/VamosIna/AyanaTMDB/releases)

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
