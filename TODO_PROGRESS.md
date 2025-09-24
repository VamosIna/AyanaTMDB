# Progress Checklist — AyanaTMDB

## Fitur/Requirement yang BELUM dikerjakan (berdasarkan TODO.md)

### Data & Usecases
- [x] Implement repository (cache-first): cek Hive box → kalau expired/empty panggil API → simpan cache
- [x] Implement usecases: `GetPopularMovies`, `GetMovieDetail`, `SearchMovies`, `GetRecommendations`, `ToggleFavorite`, `GetFavorites`

### Presentation — Netflix-like Home
- [ ] HomePage (Netflix style):
  - [x] Hero / Backdrop carousel di bagian atas (large backdrop image + gradient overlay + title + short actions: Play (open trailer), My List)
  - [x] Multiple horizontal carousels (Popular, Trending/Now Playing, Upcoming/Top Rated/Recommendations)
  - [ ] MovieCard dengan big poster, hover/scale effect, rounded corners, shadow
  - [ ] Sticky top appbar (logo + search icon + avatar)
  - [ ] Bottom navigation (Home, Search, My List, Profile)

- [ ] Animations & polish:
  - [ ] Smooth scroll + parallax effect for hero/backdrop
  - [ ] Hero animation (poster → detail)
  - [ ] Fade-in images + placeholder (shimmer)
  - [ ] Hover card scale & show quick actions on web

### Detail Page (basic)
- [ ] Detail page layout Netflix-like (poster, overlay, info, actions, overview, cast, recommendations)
- [ ] Play trailer modal (Youtube embed/webview) — optional

### Search & Filtering
- [ ] Implement `SearchMoviesBloc` (debounce, suggestions, recent searches)
- [ ] UI SearchPage (input, results, filter options)

### Favorites (My List)
- [ ] Hive setup: boxes untuk cache & favorites
- [ ] Implement `FavoritesBloc` (toggle, get list)
- [ ] UI My List page (grid, empty state)

### Caching & Offline UX
- [ ] Cache-first strategy (TTL, show cache, refresh background)
- [ ] Offline banner

### UX polish
- [ ] Theme tweaks (dark, typography, rounded cards)
- [ ] Poster aspect ratio, backdrops full width
- [ ] Quick Peek (long-press/hover overlay)
- [ ] Adaptive grid for web/tablet

### Testing & i18n
- [ ] Unit tests: minimal 1 BLoC test, 1 repository test
- [ ] Add `app_en.arb` & `app_id.arb` for key UI strings and wire `intl`
- [ ] Lint & format: `flutter analyze`, `flutter format .`

### CI & README
- [ ] GitHub Actions: run format, analyze, test on PR
- [ ] README: setup, features, arsitektur, screenshots/GIFs

### UI Component Checklist
- [ ] HeroCarousel (top)
- [ ] HorizontalCarousel widget (reusable)
- [ ] MovieCard (poster, overlay, rating, rounded, elevation)
- [ ] QuickActionsOverlay (Play, My List, Info)
- [ ] DetailHeader (poster, gradient, actions)
- [ ] TrailerModal (playback)
- [ ] BottomNavBar
- [ ] ShimmerPlaceholder

### Technical constraints & notes
- [ ] Verifikasi minSdk Android & iOS
- [ ] Store API key securely (`--dart-define`)
- [ ] Cache-first dengan Hive
- [ ] Bloc sebagai state manager utama
- [ ] README: instruksi generate code & run app

### Deliverables
- [ ] Public GitHub repository (link)
- [ ] README dengan run instructions
- [ ] Screenshots/demo GIF
- [ ] Minimal 1 unit test di `test/` dan passing di CI
