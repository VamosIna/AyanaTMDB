# 📝 TODO.md — Flutter Engineer Assignment (Netflix-like UI + TMDB)
> API: The Movie Database (TMDB)  
> Arsitektur: Clean Architecture (feature-per-folder) + BLoC  
> Caching: Hive (cache-first)  
> Target: Android minSdk 29, iOS 12.0, Web (bonus)  
> Deadline: 2 hari

---

## Ringkasan objective (harus terpenuhi)
- Konsumsi data dari TMDB (popular, search, movie detail, recommendations, videos)
- Tampilkan gambar + info dengan UI mirip Netflix (hero/backdrop, horizontal carousels, big posters)
- Implementasi search + filtering
- State management: BLoC (lebih disukai)
- Cache-first dengan Hive
- Push ke GitHub, README, dan unit tests minimal

---

## Prioritas Harian

### Day 1 — Core + Netflix-like Home + Detail dasar (PRIORITAS TERTINGGI)
**Goal:** Aplikasi sudah running, menampilkan Home dengan tampilan ala Netflix (hero + beberapa horizontal carousels), bisa lihat detail film.

#### Setup & infra
- [x] Aktifkan null-safety + strict lints (very_good_analysis / flutter_lints)
- [x] Inisialisasi repo & branch `feat/bootstrap`
- [x] Set Android minSdk 29 & iOS deployment target 12.0
- [x] Tambah dependency utama (lihat `pubspec` pada project)
- [x] `flutter pub get`

#### Project skeleton
- [x] Struktur feature-per-folder + core (lihat struktur di repo)
- [x] Setup DI (`get_it`) & bootstrap (Hive init, register adapters)
- [x] Setup `dio` + interceptor untuk TMDB (auth query / bearer based if needed)
- [x] Setup `go_router` dan routes: `/`, `/search`, `/movie/:id`, `/favorites`

#### Data & Usecases minimal
- [ ] Implement data models & retrofit/retrofit_generator interfaces:
  - [x] GET /movie/popular
  - [x] GET /movie/now_playing (opsional)
  - [x] GET /movie/upcoming (opsional)
  - [x] GET /search/movie
  - [x] GET /movie/{id}
  - [x] GET /movie/{id}/recommendations
  - [x] GET /movie/{id}/videos (untuk trailer)
- [ ] Implement repository (cache-first): cek Hive box → kalau expired/empty panggil API → simpan cache
- [ ] Implement usecases: `GetPopularMovies`, `GetMovieDetail`, `SearchMovies`, `GetRecommendations`, `ToggleFavorite`, `GetFavorites`

#### Presentation — Netflix-like Home
- [ ] **HomePage (Netflix style)**:
  - [ ] Hero / Backdrop carousel di bagian atas (large backdrop image + gradient overlay + title + short actions: Play (open trailer), My List)
  - [ ] Multiple horizontal carousels (each as `ListView` horizontal):
    - Popular Movies
    - Trending (day/week) or Now Playing
    - Upcoming / Top Rated / Recommendations
  - [ ] Each carousel item = `MovieCard` with big poster, hover/scale effect on web, rounded corners, subtle shadow
  - [ ] Sticky top appbar (logo + search icon + avatar) — minimal Netflix feel
  - [ ] Bottom navigation (Home, Search, My List, Profile) — persistent

- [ ] **Animations & polish**:
  - [ ] Smooth scroll + parallax effect for hero/backdrop
  - [ ] Hero animation (poster → detail)
  - [ ] Fade-in images + placeholder (shimmer)
  - [ ] Hover card scale & show quick actions on web

#### Detail Page (basic)
- [ ] Detail page layout Netflix-like:
  - Big poster/backdrop with gradient overlay
  - Title, year, runtime, genres, rating badge
  - Action buttons: Play (open trailer modal), My List (toggle favorite), Share (optional)
  - Overview (scrollable), cast row (horizontal), recommendations carousel
- [ ] Play trailer modal (Youtube embed or webview) — optional for Day1 (if time)

#### Wire main & run
- [x] Wire `main.dart` → show `HomePage` and verify app builds

**End Day 1 expectation:** App runs, Home page shows hero + at least one horizontal carousel (popular), tapping item opens Detail page.

---

### Day 2 — Search, Favorites, Caching, Tests, Polish (PRIORITAS TINGGI → MEDIUM)
**Goal:** Lengkapi search + favorites (Hive), polish Netflix-like interactions, unit tests, README.

#### Search & Filtering
- [ ] Implement `SearchMoviesBloc`:
  - Debounce 400ms (pakai `stream_transform` / `restartable` transformer)
  - Show suggestions & recent searches (persist recent queries locally)
- [ ] UI SearchPage:
  - Big search input top (full-width), results in vertical list + horizontal suggestions
  - Filter options (genre, year) as chips / bottom sheet (basic)

#### Favorites (My List)
- [ ] Hive setup:
  - Boxes: `popular_cache`, `movie_detail_cache`, `favorites` (store entire minimal model or ids)
  - Register adapters & open boxes at bootstrap
- [ ] Implement `FavoritesBloc` (BLoC, bukan Cubit):
  - Toggle favorite
  - Get favorites list (display in My List page as grid)
- [ ] UI My List page: grid of saved movies, empty state illustration

#### Caching behavior & offline UX
- [ ] Cache-first strategy for lists & details (TTL e.g., 1 hour)
- [ ] Show cached content immediately then refresh in background
- [ ] Offline banner (if no network and using cached data)

#### UX polish — Netflix feel
- [ ] Theme tweaks: dark-first palette, large typography, rounded cards
- [ ] Poster aspect ratio consistent (2:3), backdrops full width
- [ ] Quick Peek: long-press / hover shows small overlay with Play & Info
- [ ] Adaptive grid for web/tablet (more columns) and responsive margins

#### Testing & i18n
- [ ] Unit tests:
  - At least 1 BLoC test for `PopularMoviesBloc` (happy path + error)
  - At least 1 repository test (mock remote + local)
- [ ] Add `app_en.arb` & `app_id.arb` for key UI strings and wire `intl`
- [ ] Lint & format: `flutter analyze`, `flutter format .`

#### CI & README
- [ ] GitHub Actions: run format, analyze, test on PR
- [ ] README: setup (dart-define), features, architecture, screenshots/GIFs of Netflix-like UI

**End Day 2 expectation:** Search + favorites working, cache-first behavior in place, Home + Detail polished to Netflix-like look, minimal tests pass, README ready.

---

## UI Component Checklist (Netflix-like specifics)
- [ ] `HeroCarousel` (top): large backdrop, auto-scroll/auto-play toggle, manual swipe
- [ ] `HorizontalCarousel` widget (reusable): title + horizontal `MovieCard` list + left/right chevrons
- [ ] `MovieCard`:
  - big poster
  - title overlay (on hover for web)
  - rating badge top-left
  - rounded corners + elevation
- [ ] `QuickActionsOverlay` (on hover or long-press): Play, My List, Info
- [ ] `DetailHeader` with poster + gradient + actions
- [ ] `TrailerModal` (playback)
- [ ] `BottomNavBar` (Home, Search, My List, Profile)
- [ ] `ShimmerPlaceholder` for loading states

---

## Technical constraints & notes (must follow assignment)
- [ ] Minimum Android SDK 29 & iOS 12.0 (verifikasi gradle & Podfile)
- [ ] Use TMDB API only (no scraping); store API key securely (`--dart-define` or .env not committed)
- [ ] Cache-first approach with Hive (do not store API key in repo)
- [ ] Use Bloc as primary state manager
- [ ] Keep project single-repo (no melos unless you intentionally want monorepo)
- [ ] Provide instructions in README to generate code (build_runner) & run app

---

## Deliverables & submission
- [ ] Public GitHub repository (link)
- [ ] README with run instructions:
  - `flutter pub get`
  - `flutter pub run build_runner build --delete-conflicting-outputs`
  - `flutter run --dart-define=TMDB_API_KEY=your_key_here`
- [ ] Screenshots / demo GIF (Home, Detail, My List, Search)
- [ ] At least 1 unit test under `test/` and passing on CI

---

## Helpful implementation tips (quick)
- Hero carousel: use `PageView` with `PageController` + auto-scroll timer + `AnimatedOpacity` for title overlay
- Horizontal carousel: use `ListView.separated` horizontal + snap physics (PageSnapping false)
- Image loading: `CachedNetworkImage` with `placeholder` = `Shimmer` & `fadeInDuration`
- Debounce search: `stream_transform.debounce` or `Rx`/bloc transformer `debounceTime`
- Cache TTL: store timestamp alongside cached JSON; invalidate when `now - timestamp > TTL`
- Trailer: use TMDB `/movie/{id}/videos` → get YouTube key → open in `youtube_player_flutter` or `url_launcher` for mobile

---

## Minimal example run commands
```bash
# install deps
flutter pub get

# generate code (json_serializable / retrofit / hive adapters)
flutter pub run build_runner build --delete-conflicting-outputs

# run (set your TMDB key)
flutter run --dart-define=TMDB_API_KEY=your_real_key_here
