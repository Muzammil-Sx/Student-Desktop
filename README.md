# Student Desktop

> An offline-first, enterprise-grade Flutter desktop application for student learning management. Built with **Bloc**, **Drift**, **Dio**, and **get_it** — designed for scalability, testability, and long-term maintainability.

![Flutter](https://img.shields.io/badge/Flutter-3.44.6-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.12.2-blue?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)
![License](https://img.shields.io/badge/License-Private-red)

---

## 📖 Overview

**Student Desktop** is a Flutter desktop application that helps students track their enrolled courses, monitor learning progress, and manage their learning workflow — with **offline-first** capabilities.

The project follows an **enterprise architecture** with:

- **Feature-first folder structure** — every feature is self-contained
- **Strict layering** — Data → Domain → Presentation, no cross-layer leaks
- **Bloc state management** — event-driven, traceable, testable
- **Service locator DI** — via `get_it`, no global singletons
- **Offline-first sync** — local DB writes + sync queue
- **Design tokens** — centralized colors, spacing, radius, typography
- **Light + Dark themes** — properly distinct, persisted across restarts

---

## 🛠️ Tech Stack

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| **Language** | Dart | 3.12.2 | App language |
| **Framework** | Flutter | 3.44.6 (stable) | UI + logic |
| **State Management** | [flutter_bloc](https://pub.dev/packages/flutter_bloc) | 9.1.1 | Event-driven state |
| **DI** | [get_it](https://pub.dev/packages/get_it) | 8.3.0 | Service locator |
| **Routing** | [go_router](https://pub.dev/packages/go_router) | 14.8.1 | Declarative routing |
| **Networking** | [Dio](https://pub.dev/packages/dio) | 5.7.0 | HTTP client with interceptors |
| **Local DB** | [Drift](https://pub.dev/packages/drift) | 2.22.1 | SQLite ORM |
| **Cache** | [Hive](https://pub.dev/packages/hive) | 2.2.3 | Key-value cache with TTL |
| **Connectivity** | [connectivity_plus](https://pub.dev/packages/connectivity_plus) | 6.1.5 | Online/offline detection |
| **Window** | [window_manager](https://pub.dev/packages/window_manager) | 0.4.3 | Desktop window control |
| **Models** | [freezed](https://pub.dev/packages/freezed) + json_serializable | latest | Immutable models |
| **Lint** | [flutter_lints](https://pub.dev/packages/flutter_lints) | 5.0.0 | Static analysis |

---

## 📁 Project Structure

```
student_desktop/
├── assets/
│   └── images/                       # Static images
│
├── lib/
│   ├── main.dart                     # Entry point + bootstrap
│   │
│   ├── app/                          # App-level setup
│   │   ├── app.dart                  # MaterialApp.router + themes
│   │   ├── router.dart               # go_router config
│   │   └── splash_screen.dart        # Initial loading screen
│   │
│   ├── core/                         # Shared infrastructure
│   │   ├── cache/                    # Hive wrapper with TTL
│   │   ├── connectivity/             # Online/offline service
│   │   ├── constants/                # App-wide constants + URLs
│   │   ├── database/                 # Drift setup
│   │   │   ├── tables/               # DB schemas
│   │   │   └── daos/                 # Query helpers
│   │   ├── di/                       # get_it service locator
│   │   ├── errors/                   # AppException, Failure, ErrorMapper
│   │   ├── network/                  # Dio + interceptors
│   │   │   └── interceptors/         # Auth, Logging, Error
│   │   ├── sync/                     # Sync engine + queue
│   │   ├── theme/                    # Design system
│   │   │   ├── app_colors.dart
│   │   │   ├── app_spacing.dart
│   │   │   ├── app_radius.dart
│   │   │   ├── app_typography.dart
│   │   │   ├── app_theme.dart
│   │   │   └── bloc/                 # ThemeBloc
│   │   └── utils/                    # Logger, validators, extensions
│   │
│   ├── features/                     # Feature modules
│   │   ├── auth/
│   │   │   ├── data/                 # (ready for API + models)
│   │   │   ├── domain/               # (ready for entities + usecases)
│   │   │   └── presentation/
│   │   │       ├── login_screen.dart
│   │   │       └── bloc/             # (to be added in Phase 5)
│   │   │
│   │   ├── courses/
│   │   │   ├── data/
│   │   │   │   ├── mock_courses.dart
│   │   │   │   └── repositories/
│   │   │   │       └── courses_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── course.dart
│   │   │   │   └── repositories/
│   │   │   │       └── courses_repository.dart
│   │   │   └── presentation/
│   │   │       ├── courses_page.dart
│   │   │       ├── bloc/             # CoursesBloc
│   │   │       └── widgets/
│   │   │           └── course_card.dart
│   │   │
│   │   └── dashboard/
│   │       └── presentation/
│   │           ├── dashboard_shell.dart
│   │           ├── dashboard_page.dart
│   │           ├── settings_page.dart
│   │           └── widgets/
│   │               ├── stat_card.dart
│   │               ├── continue_learning_card.dart
│   │               └── activity_tile.dart
│   │
│   └── shared/                       # Cross-feature widgets
│       └── widgets/
│           ├── app_button.dart
│           ├── app_text_field.dart
│           ├── app_card.dart
│           └── state_views/
│               ├── loading_view.dart
│               ├── empty_view.dart
│               └── error_view.dart
│
├── windows/                          # Native Windows wrapper
├── macos/                            # Native macOS wrapper
├── linux/                            # Native Linux wrapper
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter 3.27+** (tested on 3.44.6)
- **Dart 3.5+** (tested on 3.12.2)
- **Windows 10+** (primary), macOS 12+, or Linux
- **Visual Studio 2022** (Windows desktop development workload)

### Installation

```bash
# 1. Clone the repository
git clone <repository-url>
cd student_desktop

# 2. Enable desktop support (one-time)
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

# 3. Get dependencies
flutter pub get

# 4. Generate database + model code
dart run build_runner build

# 5. Run the app
flutter run -d windows
```

### Custom API Base URL

Pass a custom base URL at build time:

```bash
flutter run -d windows --dart-define=API_BASE_URL=https://your-api.example.com
```

Default: `https://jsonplaceholder.typicode.com` (placeholder).

---

## 🧪 Development Commands

| Command | Purpose |
|---------|---------|
| `flutter run -d windows` | Run on Windows |
| `flutter run -d macos` | Run on macOS |
| `flutter run -d linux` | Run on Linux |
| `flutter analyze` | Static analysis |
| `dart run build_runner build` | Generate DB + models |
| `dart run build_runner watch` | Auto-regenerate on change |
| `flutter test` | Run tests |
| `flutter build windows --release` | Release build |

---

## 🏗️ Architecture

### Layering

```
┌─────────────────────────────────────┐
│         Presentation (UI)           │  ← Widgets, Blocs
├─────────────────────────────────────┤
│         Domain (Business)           │  ← Entities, UseCases, abstract repos
├─────────────────────────────────────┤
│         Data (Implementation)       │  ← Repos, Datasources, DTOs
├─────────────────────────────────────┤
│  Network / Database / Cache         │  ← Dio, Drift, Hive
└─────────────────────────────────────┘
```

**Rules enforced:**

- ✅ UI never talks to network directly
- ✅ Data layer never imports UI
- ✅ Every feature is isolated — no cross-feature imports
- ✅ Cross-cutting code lives in `core/`
- ✅ Repository interfaces in `domain/`, implementations in `data/`

### State Management — Bloc

Every feature follows the same pattern:

```
Event → Bloc → State
```

**Blocs currently implemented:**

| Feature | Bloc | Events | States |
|---------|------|--------|--------|
| Theme | `ThemeBloc` | `LoadTheme`, `SetThemeMode`, `ToggleTheme` | `ThemeState(mode)` |
| Courses | `CoursesBloc` | `CoursesLoadRequested`, `CoursesFilterChanged`, `CoursesSearchChanged`, `CoursesFiltersCleared` | `CoursesState(status, courses, filter, search)` |

**Blocs planned:**

| Feature | Bloc | Purpose |
|---------|------|---------|
| Auth | `LoginBloc` | Handle login flow |
| Auth | `AuthBloc` | Global session state |
| Dashboard | `DashboardBloc` | Dashboard-specific data |

### Dependency Injection — get_it

All services registered in `core/di/service_locator.dart`:

```dart
serviceLocator.registerSingleton<CacheService>(cache);
serviceLocator.registerSingleton<ConnectivityService>(connectivity);
serviceLocator.registerSingleton<AppDatabase>(database);
serviceLocator.registerLazySingleton<ApiClient>(...);
serviceLocator.registerFactory<ThemeBloc>(...);
serviceLocator.registerFactory<CoursesBloc>(...);
```

`setupServiceLocator()` is called once in `main()` before `runApp()`.

### Error Handling

**Two-layer model:**

```
AppException (data layer)
       ↓ ErrorMapper
Failure (domain layer)
       ↓
UI displays typed message
```

- `AppException` — sealed class with typed variants (NetworkException, TimeoutException, etc.)
- `Failure` — domain-layer counterpart with the same variants
- `ErrorMapper.toFailure(error)` — single source of truth

### Offline-First Sync

```
User Action
    ↓
Local DB write (Drift) + Sync Queue push
    ↓
UI updates optimistically
    ↓
Online? → SyncEngine.processQueue()
              ↓ success → queue clear
              ↓ fail    → retry with backoff
```

**Queue states:** `pending` → `syncing` → `synced` / `failed`
**Max retries:** 5 (configurable in `app_constants.dart`)
**Batch size:** 50

---

## 🔒 Security

| Aspect | Implementation |
|--------|---------------|
| **Logger** | Redacts `password`, `token`, `authorization`, `email` |
| **Error mapping** | No raw Dio exceptions leak to UI |
| **Storage** | `flutter_secure_storage` for tokens (Phase 5) |
| **Secrets** | `--dart-define` only — never hardcoded |
| **HTTPS** | Enforced for production APIs |
| **Logging** | Disabled in release builds (except fatal errors) |

---

## 🎨 Design System

All design tokens centralized in `core/theme/`:

| File | Contains |
|------|----------|
| `app_colors.dart` | Brand, semantic, light/dark palette |
| `app_spacing.dart` | 4px grid scale: `xxs / xs / sm / md / lg / xl / xxl / xxxl / huge` |
| `app_radius.dart` | Radius tokens: `xs / sm / md / lg / xl / pill` |
| `app_typography.dart` | Text styles with weights |
| `app_theme.dart` | `ThemeData` builder for light + dark |

**Never hardcode:**
- ❌ Colors (use `Theme.of(context).colorScheme`)
- ❌ Spacing (use `AppSpacing.*`)
- ❌ Radius (use `AppRadius.*`)

---

## 🎯 Features

### ✅ Implemented

- Splash screen
- Login form (UI + validation)
- Dashboard with stats + activity
- Courses grid with search + filter
- Settings (theme switch + sign out)
- Light / Auto / Dark theme (persisted)
- Sidebar navigation (desktop)
- Offline sync queue skeleton
- Network layer (Dio + interceptors)
- Local database (Drift + sync_queue)
- Cache layer (Hive with TTL)
- Connectivity detection

### 🚧 In Progress

- Auth end-to-end (login → token → navigate)
- Route guards (unauthenticated → login)
- Auto-login on app restart

### 📋 Planned

- Course details page
- Progress tracking
- Sync engine handlers (per entity)
- Register / Forgot password
- Notifications
- Tests (unit + widget + integration)
- CI/CD pipeline
- macOS + Linux release builds

---

## 📚 Documentation

- **Architecture decision records** — `docs/adr/` (planned)
- **API documentation** — `docs/api/` (planned)
- **Contribution guide** — `CONTRIBUTING.md` (planned)

---

## 🧭 Migration History

This project **started with Riverpod** and migrated to **Bloc** for enterprise requirements.

### Migration Phases

| Phase | What | Status |
|-------|------|--------|
| 1 | Add Bloc + get_it (no removals) | ✅ Done |
| 2 | Migrate Theme → `ThemeBloc` | ✅ Done |
| 3 | Migrate Courses → `CoursesBloc` | ✅ Done |
| 4 | Remove Riverpod entirely | ✅ Done |
| 5 | Auth feature end-to-end | 🚧 In Progress |

### Why Bloc Over Riverpod?

For **enterprise** projects with:
- **Large teams** (10+ developers)
- **Complex multi-step workflows** (auth, payment, onboarding)
- **Strict PR review requirements**
- **Long-term maintainability** (5+ years)

Bloc provides:
- Explicit event → state traceability
- Predictable patterns for onboarding
- Better PR review (reviewer sees event → state mapping)
- Time-travel debugging via BlocObserver

---

## 🤝 Contributing

1. **Branch naming:** `feature/<name>`, `fix/<name>`, `refactor/<name>`
2. **Commit messages:** Follow [Conventional Commits](https://www.conventionalcommits.org/)
   ```
   feat(auth): add login bloc
   fix(courses): resolve filter reset bug
   docs: update README
   ```
3. **Before PR:**
   - `flutter analyze` → 0 issues
   - `flutter test` → all pass
   - Follow existing patterns (search first!)
   - No dead code, no `print`, no commented-out blocks

---

## 📄 License

Private — internal use only. © 2026 Muzammil Hussain.

---

## 👤 Author

**Muzammil Hussain**
Flutter Desktop Application — Enterprise Edition

---

## 🔗 Links

- [Flutter Documentation](https://docs.flutter.dev/)
- [Bloc Library](https://bloclibrary.dev/)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [get_it Package](https://pub.dev/packages/get_it)
- [go_router](https://pub.dev/packages/go_router)
