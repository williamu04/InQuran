# InQuran (MTQMNUNS)

> **Suarakan Niat · Dengarkan Ayat · Dekap Hidayah**
> Read and understand the meaning of the Holy verses easily, anytime and anywhere.

InQuran is a **fully offline** cross-platform **Al-Qur'an application** built with Flutter, developed for **Universitas Sebelas Maret (UNS)**. It bundles the entire Qur'an, juz boundaries, and a collection of du'a locally inside the app, and adds voice-command navigation, audio recitation, prayer times, and a Qibla compass — with **accessibility (TalkBack/VoiceOver)** as a first-class concern so the app can be used by people with visual impairments. Quranic content and favorites are stored on the device; **no accounts are required and no data leaves the device** except for optional live-content features (prayer-time lookups, Mushaf page images, and recitation audio streams).

The app targets Android and iOS as the primary platforms.

---

## Table of Contents

- [Features](#features)
- [Reading Modes](#reading-modes)
- [Accessibility](#accessibility)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Code Generation](#code-generation)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [How Data Flows](#how-data-flows)
- [External Services](#external-services)
- [Building & Releasing](#building--releasing)
- [Testing](#testing)
- [Known Caveats](#known-caveats)
- [Roadmap Ideas](#roadmap-ideas)
- [Contributing](#contributing)
- [Disclaimer](#disclaimer)

---

## Features

### Qur'an Reading
- **All 114 Surahs** with Arabic text, Latin romanization, Indonesian translation, ayah-by-ayah audio, and juz/page metadata bundled offline in a SQLite database.
- **Three reading modes** (switched from the settings drawer):
  - **Normal mode** — scrollable ayah cards with Arabic + translation and per-ayah controls.
  - **Memorize mode (Hafalan)** — Arabic text hidden by default; tap an ayah to reveal it.
  - **Mushaf mode** — page-by-page Uthmani mushaf image rendering (fetched from a CDN, cached locally).
- **Surah and Juz navigation** with seamless **infinite scroll**: overscroll at the top/bottom loads the previous/next surah or juz without leaving the screen.
- **Jump navigation** by page (1–604), by juz, or "open at the page containing ayah X" (used by Mushaf mode).
- **Search & filter** for surahs and juz (latin name, Arabic name, revelation place, number).

### Audio
- Per-ayah **audio recitation** playback (`just_audio`) with play / pause / resume and **auto-advance** to the next ayah on completion.
- Stream-safe handling for network audio links stored in the local database.

### Ayah Actions
- **Share** any ayah (Arabic + translation) via the system share sheet.
- **Favorite/bookmark** ayahs — stored **locally on the device** (works fully offline, no login required).

### Daily Helper Tools
- **Prayer times (Waktu Salat)** — fetched live from the Aladhan API based on the device location (with **Jakarta fallback** when location is unavailable), with the ability to paginate through dates.
- **Qibla compass (Arah Kiblat)** — live compass bearing toward the Kaaba computed from the device's GPS position.

### Du'a Collection (Koleksi Doa-Doa)
- Bundled collection of **doa categorized** collection (e.g., doa for parents, entering home, before sleep, etc.), rendered as ayah-based cards with Arabic and translation.

### Voice Command Mode (Mode Voice Command)
A dedicated hands-free mode designed for **users with visual impairments**:
- Speech-to-text (Indonesian locale) with live transcription shown on screen.
- **Fuzzy command matching** (fuzzywuzzy) so natural language maps to actions:
  - "surah al-fatihah" → open that surah
  - "doa tentang ..." → open a du'a category
  - "qibla / kiblat / arah kiblat" → Qibla screen
  - "waktu sholat / prayer time / jadwal" → Prayer times screen
- Automatic retry on network errors.

### Onboarding & Settings
- **Onboarding**: animated splash → first-launch intro where the user chooses Normal mode or Voice Command mode.
- **Settings**: reading-mode switching, voice-command toggling, and utility drawers — all persisted locally.

> **No accounts.** Earlier versions shipped email/Google authenticated logins, a synced profile, and a favorites backend. All of that has been removed — the app is 100% account-free and works offline.

### Accessibility (TalkBack / Screen Reader)
- Extensive `Semantics` annotations (labels, hints, headers, live regions, `ExcludeSemantics` for decorative content) across home, menu, du'a categories, voice screens, and more.
- Large touch targets, no-splash/highlight suppression, and readable typography.

---

## Tech Stack

| Area            | Technology                                                            |
| --------------- | --------------------------------------------------------------------- |
| Framework       | Flutter (Dart SDK `^3.7.0`, Flutter `3.44.0-stable` via `.tool-versions`) |
| State           | `provider` (ChangeNotifier) + custom `StatefulViewModel` with sealed `state` classes |
| Routing         | `go_router` (declarative `AppRoutes` registry + `ShellRoute`)          |
| Local DB        | `drift` / `sqlite3` (bundled `assets/databases/quran.db`)              |
| Local cache     | `shared_preferences` (favorites cache, app config)                     |
| Networking      | `http` (prayer times — optional live feature)                         |
| Audio           | `just_audio`                                                          |
| Speech          | `speech_to_text` + `fuzzywuzzy` (STT command matching)                |
| Location        | `geolocator`, `geocoding`, `flutter_compass`, `permission_handler`    |
| Misc            | `share_plus`, `cached_network_image`, `intl`, `auto_size_text`, `scrollable_positioned_list`, `vibration`, `lucide_icons_flutter` |
| Codegen         | `build_runner` + `drift_dev` (tables/DAOs)                             |
| Linting         | `flutter_lints` (`analysis_options.yaml`)                             |

---

## Architecture

The project follows a **layered architecture** with a clear one-way dependency flow:

```
Screens (lib/screens)  ──►  ViewModels (lib/viewmodel)  ──►  Repositories (lib/repositories)
     │                              │                              │
     │ uses provider                │ sealed state (lib/state)     │ maps DTOs (lib/dto)
     │                              ▼                              ▼
     └── reusable widgets    Services (lib/services)      Data
     (lib/components, common)       │                    lib/data/local (drift)
                                     ▼                    lib/data/entity (tables)
                               external APIs              lib/data/local/dao
                                                         lib/data/local/cache
                                                         lib/data/aggregate
```

- **`lib/data/entity`** — Drift table definitions (`Surah`, `Ayah`, `Doa`, `DoaCategory`).
- **`lib/data/local/dao`** — Database accessors implementing the SQL queries (see `ayah_dao.dart` for the range queries: pages, juz, next/previous ranges).
- **`lib/data/local/cache`** — `SharedPreferences` persistence (favorites list used by the favorites feature).
- **`lib/data/aggregate`** — Read models that join entities (e.g., `SurahWithAyahs`, `AyahWithSurah`, `JuzInfo`, `CompleteDoaData`).
- **`lib/dto`** — Pure data-transfer objects with entity→DTO converters.
- **`lib/repositories`** — The only layer screens/view-models talk to; implements all queries against the local database.
- **`lib/services`** — Stateless infrastructure (audio player, STT, prayer times, location, geocoding, Qibla math, surah filtering).
- **`lib/viewmodel`** — `StatefulViewModel<S>` subclasses (sealed-state) that expose a typed `state` and `setState()` with `notifyListeners()`.
- **`lib/state`** — **sealed** state classes representing every UI state (loading/success/error/empty/…) plus the `StatefulViewModel` base, UI toggle controllers, and the disclosure-button model/action family.
- **`lib/screens`** — Page widgets, one file per route.
- **`lib/components`** — Reusable UI widgets (drawers, popups, top bar, bottom nav, mic button, cards, buttons).
- **`lib/common`** — Non-widget shared code (colors, navigation helpers, snackbar helper, du'a-category translator).
- **`lib/routes`** — Declarative route registry + GoRouter builder.
- **`lib/config`** — `GlobalConfig` (app-wide settings incl. voice mode & reading mode).
- **`lib/models`** — Pure domain models (e.g., `PrayerTime`).

### State management pattern

Every feature view-model extends `StatefulViewModel<SomeState>` and holds exactly one immutable state object out of a `sealed` family. Screens `Consumer` the view-model and `switch` over the sealed states (exhaustive) rendering loading/error/empty/success widgets. There are **no setState view-models for feature screens** — success/failure payloads (e.g., `SuccessOrFail<T>`) are used for one-shot operations.

---

## Getting Started

### Prerequisites

- **Flutter** 3.44.0 stable (Dart ^3.7.0). Compatible with `fvm`/`asdf` (see `.tool-versions`).
- An Android device/emulator or iOS simulator for the primary targets. Desktop/web targets exist but are not the primary use case.
- No API keys, accounts, or server setup are required. Network is only needed for the **optional** live features (prayer times, Mushaf page images, and recitation audio streaming); the core reading experience is fully local.

### Install & run

```bash
flutter pub get              # install dependencies
flutter run                  # launch on the connected device (defaults to Android)
```

To target a specific platform:

```bash
flutter run -d android       # Android
flutter run -d ios           # iOS (macOS host only)
```

### Environment

There is **no backend and no environment configuration**. The app ships its data and logic entirely on-device; there are no API keys, base URLs, or `.env` files to configure. (The historical `lib/config/env.dart` was removed together with the backend.)

---

## Code Generation

Drift tables and DAOs are generated; never edit the `*.g.dart` files by hand.

```bash
dart run build_runner build --delete-conflicting-outputs   # one-shot
dart run build_runner watch                                # watch mode (recommended while developing)
```

After **adding or changing** a Drift `Table` (`lib/data/entity/*.dart`) or a `@DriftAccessor` DAO you must:
1. Register the table/DAO in `@DriftDatabase(...)` in `lib/data/local/db/app_database.dart`.
2. Re-run `build_runner` to regenerate `app_database.g.dart` and the `*_dao.g.dart` files.
3. Provide the new DAO in the provider tree in `lib/main.dart`.

---

## Configuration

### App-wide settings (`lib/config/global.dart` — `GlobalConfig`)

A singleton `ChangeNotifier` persisted in `SharedPreferences`:

| Setting               | Key            | Values                     |
| --------------------- | -------------- | -------------------------- |
| Reading mode          | `quranMode`    | `normal` \| `memorize` \| `mushaf` |
| Voice command mode    | `isVoiceMode`  | `bool`                     |
| First launch flag     | `isFirstLaunch`| `bool` (clears intro)      |

`GlobalConfig.markLaunched()` is called by the intro screen and resets the mode to `normal`.

### Database (`lib/data/local/db/app_database.dart`)

Singleton `AppDatabase` backed by `assets/databases/quran.db` (bundled with the app). On every cold start the existing `db.sqlite` in the app documents folder is **deleted and re-copied** from assets. This keeps the onboard data immutable and guarantees schema/first-launch consistency. **User data is never written to SQLite** — favorites persist in `SharedPreferences` via `FavoriteCache` (see below), so they survive across restarts.

---

## Project Structure

```
.
├── assets/
│   ├── databases/quran.db      # Bundled Qur'an SQLite (surah, ayah, doa, doa_category)
│   ├── fonts/                  # Plus Jakarta, Arab Typesetting, Al Jazeera, Amiri Quran, Uthmani(HAFS)
│   └── img/                    # logos, basmala, heart, arrow, star
├── lib/
│   ├── main.dart               # Bootstrap + global MultiProvider tree + app shell
│   ├── common/                 # non-widget shared code (colors, navigation, snackbar, du'a translator)
│   ├── components/             # UI widgets (bottom nav, drawers, popups, top bar, mic button, cards)
│   ├── config/                 # GlobalConfig (reading mode, voice mode, first-launch flag)
│   ├── data/
│   │   ├── aggregate/          # joined read models (SurahWithAyahs, JuzInfo, CompleteDoaData, …)
│   │   ├── entity/             # drift tables: Surah, Ayah, Doa, DoaCategory
│   │   └── local/
│   │       ├── cache/          # SharedPreferences caches (favorites)
│   │       ├── dao/            # SurahDao, AyahDao, JuzDao, DoaDao  (+ *.g.dart)
│   │       └── db/             # AppDatabase + drift codegen
│   ├── dto/                    # favorites, juz, surah DTOs
│   ├── models/                 # pure domain models (prayer)
│   ├── repositories/           # surah, ayah, juz, doa, stt
│   ├── routes/                 # AppRoutes registry + GoRouter config
│   ├── screens/                # one widget per route
│   ├── services/               # audio, stt, prayer, geocode, qibla, surah_filter
│   ├── state/                  # sealed state families + stateful_viewmodel base + UI controllers
│   └── viewmodel/              # StatefulViewModel<S> subclasses
├── android/ ios/ linux/ macos/ web/ windows/   # Flutter platform shells
├── test/widget_test.dart       # splash smoke test
├── analysis_options.yaml       # flutter_lints
├── build.yaml                  # drift_dev options (camelCase)
├── pubspec.yaml                # package `inquran`
└── .tool-versions              # flutter 3.44.0-stable
```

---

## How Data Flows

### Reading a surah (offline-first)

1. `SurahListScreen` → `SurahListViewModel` lazily loads all surahs + juz info from the local DB (`SurahDao`, `JuzDao`); search is applied in memory by `SurahFilterService`.
2. Tapping a surah/juz builds a query-string URL (`navigateToSurah`/`navigateToJuz` in `lib/common/navigation.dart`) and pushes `/surah?startSurahId=…&endSurahAyah=…&loadType=…`.
3. `SurahScreen` parses the query params, ensures `SurahViewModel` caches **all ayahs** into memory (`initializeCache`), then calls `loadSurah(...)`, `loadByPage(...)` or `loadPageByJuz(...)`.
4. `NormalSurahScreen` / `MushafSurahScreen` render the current `SurahSuccess` state; overscroll triggers `append/prependBySurah/Juz` which filter the in-memory cache.

### Favorites (local-only)

- `FavoritesViewModel` owns the favorites list in memory, persisted through `FavoriteCache` (`SharedPreferences`) — **no login and no network needed**.
- `FavoriteScreen` renders the favorited ayahs from the `FavoritesLoaded` state, which the view-model populates by looking up the local `AyahDao` (`getAyahsFromFavorites`).
- The heart icon on reading screens adds/removes entries via `FavoritesViewModel.addFavorite` / `deleteFavorite`, immediately reflected in the favorites tab.

### Voice commands

`MicButton` → `SttViewModel` (listens via `SttService`) → `SttRepository.processTranscription(text)` runs fuzzy matchers against surah names, du'a categories, and command keywords, returning a navigation callback executed by the screen.

---

## External Services

| Service                                  | Purpose                        | Where                                  |
| ---------------------------------------- | ------------------------------ | -------------------------------------- |
| Mushaf CDN (`https://media.halonopal.space/static/mushaf/page/`) | Page images for Mushaf mode | `lib/screens/surah_mushaf.dart`        |
| Aladhan API (`http://api.aladhan.com/v1/timings`) | Prayer times                 | `lib/services/prayer.dart`             |

None of the app's own data (Qur'an text, translations, du'a, favorites) depends on these services — they only power optional live content. All required services run on the device.

---

## Building & Releasing

```bash
flutter build apk --release          # Android APK
flutter build appbundle --release    # Android AAB (Play Store)
flutter build ios --release          # iOS (macOS host)
flutter build windows / linux / macos / web   # desktop/web (secondary targets)
```

Versioning is handled in `pubspec.yaml` (`version: 1.0.0+1`).

Before a release, remember to:

- Rename the Android application label (`android:label` in `AndroidManifest.xml`, currently `inquran`) and bundle ID (`com.mtqmn.inquran`) to production values.

---

## Testing

```bash
flutter test
```

`test/widget_test.dart` is a smoke test that pumps `SplashScreen` and asserts the app title renders. Unit/widget/integration tests for the repositories, view-models, STT matching, and Qibla math are planned and welcome.

---

## Known Caveats

- **Database reset on every launch** — `AppDatabase._openConnection()` deletes and re-copies `quran.db` from assets on each start (also forces the app to use the bundled SQLite schema). Any writes to SQLite will be lost; persist user data through `SharedPreferences` instead.
- **Favorites live outside SQLite** — because the DB is rebuilt each launch, favorites intentionally persist via `FavoriteCache` (SharedPreferences), not in the `ayah.favorite` column.
- **Prayer times & Mushaf images are online-only** — these live features need network; the rest of the app works fully offline.
- **STT error strings** are matched literally (`'error_network'`, `'error_network_timeout'`) — tied to the plugin's message values.
- The app label/package id are still Flutter placeholders (`inquran` / `com.mtqmn.inquran`).

---

## Roadmap Ideas

- Formal unit tests for fuzzy STT matching, ayah range queries, and Qibla bearing math.
- Bundle prayer-time data for fully offline scheduling (no live request needed).
- Download/stream recitation caching and offline playback queue.
- Search across whole Qur'an text and translations.
- i18n for translations beyond Indonesian (UI strings are currently hardcoded in Indonesian).

---

## Contributing

1. Fork the repository and create a feature branch (`git checkout -b feat/xxx`).
2. Follow the layered architecture: entity → DAO → repository → view-model (sealed state) → screen.
3. Keep generated files out of edits; re-run `build_runner` when touching Drift.
4. Verify with `flutter analyze` before opening a PR.
5. Commit messages follow the existing conventional style seen in `git log` (e.g., `feat: …`, `fix: …`, `refactor: …`).

---

## Disclaimer

InQuran is an open, community-built Qur'an application and is **not an authoritative religious reference**. Quranic text, translations, du'a content, and recitation audio are stored as bundled data served as-is. Always cross-check content against a certified mushaf and qualified religious authorities, and ensure any distributed copy has the rights to the Arabic/translation/font/audio assets it contains.

---

_License: see the repository for license information._
