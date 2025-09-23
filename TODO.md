# Flutter Engineer Assignment – TODO

> API: **The Movie Database (TMDB)**  url("https://api.themoviedb.org/3/authentication") dan (header : "Authorization", "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZjk1MWFmNzNjYTNkNGIxNTJkOTJkY2M5NzExN2Y4ZiIsIm5iZiI6MTY0MDk3OTgzMS43NTQsInN1YiI6IjYxY2Y1ZDc3N2I3YjRkMDA5NGY3YTYxYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Nw8gBb3P8oEE-FsHKdv0yXm4OSbG7_PTFlQIbWjL5Yg")
> Arsitektur: **Clean Architecture per fitur** + **BLoC** (cache-first dengan Hive)  
> Target: **Android minSdk 29**, **iOS 12.0**, **Web (bonus)**  
> Deadline: **2 hari**

## 0. Persiapan Proyek
- [x] Aktifkan null-safety & lints ketat (flutter_lints / very_good_analysis)
- [x] Siapkan Git repo + initial commit (https://github.com/VamosIna/AyanaTMDB.git)
- [x] Buat branch `feat/bootstrap`
## 1. Dependencies
- [x] Tambah dependencies:
  - State: `flutter_bloc`, `equatable`, `stream_transform`, `bloc_concurrency`
  - HTTP: `dio`, `retrofit`, `json_annotation`, `pretty_dio_logger`
  - Codegen: `build_runner`, `json_serializable`, `retrofit_generator`, `freezed`, `freezed_annotation`
  - Cache: `hive`, `hive_flutter`
  - Images: `cached_network_image`
  - Routing: `go_router`
  - i18n: `flutter_localizations`, `intl`
  - Testing: `bloc_test`, `mocktail`
- [x] `flutter pub get`

## 2. Struktur Folder (Clean Architecture)
.
├─ analysis_options.yaml            # lints ketat (very_good_analysis / flutter_lints)
├─ pubspec.yaml
├─ README.md
├─ .gitignore
├─ .github/
│  └─ workflows/ci.yml              # format+analyze+test
├─ scripts/
│  ├─ gen.sh                        # wrapper build_runner
│  └─ format.sh
├─ assets/
│  ├─ fonts/
│  ├─ images/
│  └─ translations/                 # jika tidak pakai l10n default
├─ ios/                             # iOS target 12
├─ android/                         # minSdk 29
├─ web/                             # favicon, index.html meta
└─ lib/
   ├─ main.dart
   ├─ bootstrap.dart                # runZoned, init DI/Hive, guard
   ├─ app/
   │  ├─ app.dart                   # MaterialApp + delegates
   │  ├─ router.dart                # go_router declarative routes
   │  ├─ theme.dart                 # light/dark theme, typography
   │  ├─ env.dart                   # baca --dart-define (TMDB_API_KEY, BASE_URL)
   │  └─ config.dart                # constants app-level (paging size, ttl)
   ├─ core/                         # lintas fitur, tidak tahu domain spesifik
   │  ├─ constants/
   │  │  ├─ api_constants.dart      # base urls, image sizes
   │  │  └─ ui_constants.dart       # paddings, radii, durations
   │  ├─ error/
   │  │  ├─ exceptions.dart         # server/cache exceptions
   │  │  └─ failures.dart           # domain Failures
   │  ├─ network/
   │  │  ├─ dio_client.dart         # create Dio instance
   │  │  └─ interceptors/
   │  │     ├─ auth_interceptor.dart
   │  │     └─ logging_interceptor.dart
   │  ├─ di/
   │  │  └─ injector.dart           # get_it registrations
   │  ├─ utils/
   │  │  ├─ date_formats.dart
   │  │  ├─ debounce.dart
   │  │  └─ result.dart             # Either/Result util (opsional)
   │  └─ widgets/                   # benar2 generic (boleh dipakai semua fitur)
   │     ├─ app_loading.dart
   │     ├─ app_error.dart
   │     └─ empty_state.dart
   ├─ common/                       # komponen UI reusable tapi opiniated untuk app
   │  ├─ atoms/
   │  ├─ molecules/
   │  └─ organisms/
   ├─ l10n/
   │  ├─ app_en.arb
   │  └─ app_id.arb
   └─ features/
      └─ movies/                    # ← modul fitur (TMDB)
         ├─ data/
         │  ├─ models/              # DTO untuk (de)serialisasi JSON
         │  │  ├─ movie_model.dart
         │  │  ├─ movie_detail_model.dart
         │  │  └─ genre_model.dart
         │  ├─ datasources/
         │  │  ├─ movies_remote_ds.dart   # retrofit interfaces
         │  │  └─ movies_local_ds.dart    # Hive boxes
         │  └─ repositories/
         │     └─ movies_repository_impl.dart
         ├─ domain/
         │  ├─ entities/
         │  │  ├─ movie.dart
         │  │  ├─ movie_detail.dart
         │  │  └─ genre.dart
         │  ├─ repositories/
         │  │  └─ movies_repository.dart  # abstract contract
         │  └─ usecases/
         │     ├─ get_popular_movies.dart
         │     ├─ search_movies.dart
         │     ├─ get_movie_detail.dart
         │     ├─ get_recommendations.dart
         │     ├─ toggle_favorite.dart
         │     └─ get_favorites.dart
         └─ presentation/
            ├─ blocs/
            │  ├─ popular/
            │  │  ├─ popular_bloc.dart
            │  │  ├─ popular_event.dart
            │  │  └─ popular_state.dart
            │  ├─ search/
            │  │  └─ search_bloc.dart
            │  │  └─ search_event.dart
            │  │  └─ search_state.dart
            │  ├─ detail/
            │  │  └─ detail_bloc.dart
            │  │  └─ detail_state.dart
            │  │  └─ detail_event.dart
            │  ├─ favorite/
            │  │  ├─ favorite_bloc.dart        # <-- Ubah menjadi BLoC
            │  │  ├─ favorite_state.dart       # <-- Hapus Cubit
            │  │  └─ favorite_event.dart       # <-- Hapus Cubit
            |       
            ├─ pages/
            │  ├─ home_page.dart
            │  ├─ search_page.dart
            │  ├─ detail_page.dart
            │  └─ favorites_page.dart
            └─ widgets/
               ├─ movie_card.dart
               ├─ movie_grid.dart
               └─ rating_badge.dart

## 3. Konfigurasi Platform
- [x] Android: `android/app/build.gradle` → `minSdkVersion 29`
- [x] iOS: `ios/Podfile` → `platform :ios, '12.0'`
- [ ] Web: `index.html` meta theme-color, responsive viewport

## 4. Konfigurasi API & Environment
- [x] Tambah `TMDB_API_KEY` via `--dart-define`
- [x] `core/constants/api_constants.dart` (baseUrl, imageBaseUrl)
- [x] `auth_interceptor.dart` menambahkan query `api_key` ke setiap request

## 5. Bootstrap Aplikasi
- [x] `dio_client.dart` + interceptors (auth + logger)
- [x] Setup `Hive` dan registrasi adapter (kalau pakai model/adapter spesifik)
- [x] Service locator sederhana (get_it) di `core/di/injector.dart`
- [x] `go_router` routes: `/`, `/search`, `/movie/:id`, `/favorites`
- [x] `app/theme.dart` + light/dark theme
- [x] Integrasi `MaterialApp` + `FlutterLocalizations`

## 6. Layer Data
- [x] Retrofit interface untuk TMDB:
  - [x] `GET /movie/popular`
  - [x] `GET /search/movie`
  - [x] `GET /movie/{movie_id}`
  - [x] `GET /movie/{movie_id}/recommendations`
- [x] Local DS (Hive):
  - [x] Box: `popular_movies` (cache+timestamp)
  - [x] Box: `movie_detail_{id}` (per item cache)
  - [x] Box: `favorites` (set<int>)
- [x] Mapper: `MovieModel ↔ Movie` (entity), dst.
- [x] Repository impl: strategi **cache-first**:
  - [x] baca cache (valid TTL) → kalau tidak ada/expired, hit API lalu simpan

## 7. Layer Domain
- [x] Entities (immutable + equatable)
- [x] Repos abstract
- [x] Usecases (callable classes) dengan return `Either<Failure, T>`

## 8. Layer Presentation
- [ ] BLoC Popular (pagination, pull-to-refresh)
- [ ] BLoC Search (debounce 400ms + cancelable events)
- [ ] BLoC Detail (detail + recommendations)
- [ ] BLoC Favorite (toggle, list) - **pastikan menggunakan BLoC, bukan Cubit**
- [ ] UI Pages:
  - [ ] HomePage: grid Popular, filter (genre/year), FAB ke Favorites
  - [ ] SearchPage: search field debounced, empty/loading/error states
  - [ ] DetailPage: poster, rating, genres, overview, favorite button, recs
  - [ ] FavoritesPage: grid/empty state
- [ ] Widgets: `movie_card`, `movie_grid`, `rating_badge`, `app_error`, `app_loading`
- [ ] Gambar via `cached_network_image` (placeholder + fadeIn)

## 9. i18n
- [ ] `app_en.arb` & `app_id.arb` (strings kunci UI)
- [ ] Format tanggal/angka pakai `intl` sesuai locale
- [ ] Toggle bahasa (opsional) di Settings/Overflow

## 10. Performance & UX
- [ ] Search debounced + `restartable()` transformer
- [ ] Infinite scroll (Popular) + prefetch threshold
- [ ] Hero animation poster → detail
- [ ] Image cache size yang sehat
- [ ] Graceful offline: tampilkan cache + banner “offline”

## 11. Testing
- [ ] Unit test usecase (happy/error)
- [ ] Unit test repo (mock remote/local ds)
- [ ] BLoC test (popular/search/detail/favorite)
- [ ] (Opsional) Golden test `movie_card`

## 12. CI & Kualitas Kode
- [ ] GitHub Actions: `flutter format --set-exit-if-changed`, `flutter analyze`, `flutter test`
- [ ] Pre-commit hook (opsional)

## 13. README
- [ ] Deskripsi pendek + arsitektur
- [ ] Cara run:
  - [ ] `flutter pub get`
  - [ ] `flutter pub run build_runner build --delete-conflicting-outputs`
  - [ ] `flutter run --dart-define=TMDB_API_KEY=...`
- [ ] Fitur, struktur folder, keputusan teknis
- [ ] Screenshots (setelah selesai)

## 14. Finishing
- [ ] Review aksesibilitas (semantics, contrast)
- [ ] QA cepat: mode gelap, offline, rotate, kecilkan font, web layout
- [ ] Push branch → PR → merge → tag release

---

### Snippets Referensi (ringkas)

**Dart-define (run):**
```bash
flutter run --dart-define=TMDB_API_KEY=your_key_here
