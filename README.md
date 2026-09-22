# Student Desktop

## Project Technical Summary

Student Desktop is a Flutter-based Windows desktop application for a
student learning environment. The project uses a feature-first
architecture with a clean architecture style and an offline-first
foundation.

------------------------------------------------------------------------

## 1. Technology Stack

  -----------------------------------------------------------------------
  Layer                   Technology              Purpose
  ----------------------- ----------------------- -----------------------
  Language                Dart 3.12.2             Main programming
                                                  language

  Framework               Flutter 3.44.6          UI and application
                                                  framework

  Platform                Windows Desktop         Primary target platform

  State Management        Riverpod 2.6.1          Application state
                                                  management

  Routing                 go_router               Navigation and routing

  Networking              Dio                     HTTP/API communication

  Database                Drift + SQLite          Local/offline database

  Cache                   Hive                    Key-value and API
                                                  response cache

  Connectivity            connectivity_plus       Online/offline
                                                  detection

  Window Management       window_manager          Desktop window controls

  Responsive UI           responsive_framework    Responsive desktop
                                                  layouts

  Code Generation         build_runner +          Generated code/database
                          drift_dev               support
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 2. Languages

### Dart

Dart is the primary programming language used for the application and
Flutter UI.

### SQL / SQLite

SQLite is the local database engine, accessed through Drift.

### YAML

YAML is used for Flutter project configuration and dependency
management, mainly through `pubspec.yaml`.

### PowerShell

PowerShell is used for Windows development commands such as running and
building the application.

------------------------------------------------------------------------

## 3. Database & Local Storage

### Primary Database: Drift + SQLite

Drift provides the application database layer while SQLite provides the
underlying local database engine.

Main purposes:

-   Local application data
-   Offline-first support
-   Pending operations
-   Synchronization queue
-   Future API synchronization

### Current Important Table

``` text
sync_queue
├── id
├── entity
├── action
├── payload
├── status
├── retryCount
├── lastError
├── createdAt
└── lastAttemptAt
```

### Cache: Hive

Hive is used for:

-   Key-value storage
-   API response caching
-   TTL-based cache management

### Authentication Storage

`flutter_secure_storage` is planned for sensitive authentication
information such as access and refresh tokens.

------------------------------------------------------------------------

## 4. Folder Structure

``` text
student_desktop/
│
├── assets/
│   └── images/
│
├── lib/
│   │
│   ├── main.dart
│   │
│   ├── app/
│   │   ├── app.dart
│   │   ├── router.dart
│   │   └── splash_screen.dart
│   │
│   ├── core/
│   │   ├── cache/
│   │   ├── connectivity/
│   │   ├── constants/
│   │   ├── database/
│   │   │   ├── tables/
│   │   │   └── daos/
│   │   ├── di/
│   │   ├── errors/
│   │   ├── network/
│   │   │   └── interceptors/
│   │   ├── sync/
│   │   ├── theme/
│   │   └── utils/
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── courses/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   └── dashboard/
│   │       └── presentation/
│   │
│   └── shared/
│       ├── models/
│       └── widgets/
│
├── windows/
├── macos/
├── linux/
├── pubspec.yaml
└── analysis_options.yaml
```

------------------------------------------------------------------------

## 5. Architecture

The project follows a **Feature-First + Clean Architecture style**.

### Main Flow

``` text
Presentation / UI
       ↓
Riverpod State
       ↓
Domain
       ↓
Data
       ↓
API / Database / Cache
```

### Architecture Responsibilities

#### `app/`

Application-level configuration:

-   App startup
-   Router
-   Splash screen
-   MaterialApp configuration

#### `core/`

Application-wide infrastructure:

-   Database
-   Network
-   Cache
-   Connectivity
-   Error handling
-   Sync engine
-   Theme
-   Utilities
-   Dependency injection

#### `features/`

Business/application features:

-   Authentication
-   Courses
-   Dashboard
-   Settings

Each feature can contain:

``` text
data/
domain/
presentation/
```

#### `shared/`

Reusable components shared across multiple features:

-   Buttons
-   Text fields
-   Cards
-   Loading states
-   Empty states
-   Error states

------------------------------------------------------------------------

## 6. UI & Design System

The project has a centralized theme/design system.

``` text
core/theme/
├── app_colors.dart
├── app_spacing.dart
├── app_radius.dart
├── app_typography.dart
└── app_theme.dart
```

### Theme Modes

-   Light
-   Dark
-   Auto/System

### Reusable UI Components

``` text
AppButton
AppTextField
AppCard
LoadingView
EmptyView
ErrorView
```

------------------------------------------------------------------------

## 7. Main Screens

### Splash

Contains:

-   Application logo
-   "Student Desktop" title
-   Loading indicator
-   Automatic transition

### Login

Contains:

-   Email field
-   Password field
-   Form validation
-   Sign In button

### Dashboard

Contains:

-   Greeting
-   Statistics cards
-   Continue Learning
-   Recent Activity

### Courses

Contains:

-   Search bar
-   Filter chips
-   Course grid
-   Progress bars
-   Status badges

### Settings

Contains:

-   Light / Auto / Dark theme selection
-   Sign out option

------------------------------------------------------------------------

## 8. Networking

The application uses **Dio** for HTTP/API communication.

Network structure:

``` text
core/network/
├── Dio Client
└── interceptors/
    ├── Auth
    ├── Logging
    └── Error
```

The UI is separated from direct network communication. API-related logic
belongs in the appropriate data/network layers.

------------------------------------------------------------------------

## 9. Offline-First Architecture

The application has an offline-first foundation.

``` text
User Action
     ↓
Local Drift / SQLite Write
     ↓
Sync Queue
     ↓
Internet Available?
     ↓
API Sync
     ↓
Success → Queue Clear
Failure → Retry
```

### Connectivity

`connectivity_plus` is used to detect online/offline connectivity.

### Sync

The sync engine provides the foundation for processing queued operations
when connectivity is available.

------------------------------------------------------------------------

## 10. Important Engineering Features

The current project foundation includes:

-   Typed error handling
-   Centralized theme/design tokens
-   Reusable widgets
-   Local database
-   Hive caching
-   Offline sync foundation
-   Connectivity detection
-   Centralized routing
-   Responsive desktop layout
-   Riverpod state management
-   Dio networking
-   Static analysis/linting

------------------------------------------------------------------------

## 11. Important Dependencies

``` yaml
flutter_riverpod
go_router
dio
drift
sqlite3_flutter_libs
hive
connectivity_plus
window_manager
responsive_framework
intl
```

### Development Dependencies

``` yaml
build_runner
drift_dev
flutter_lints
```

------------------------------------------------------------------------

## 12. Platforms

### Primary Platform

``` text
Windows Desktop
```

### Platform Folders

``` text
windows/
macos/
linux/
```

Windows is currently the primary development and deployment target.

------------------------------------------------------------------------

## 13. Essential Commands

### Install Dependencies

``` powershell
flutter pub get
```

### Run Windows Application

``` powershell
flutter run -d windows
```

### Analyze Project

``` powershell
flutter analyze
```

### Generate Code

``` powershell
dart run build_runner build
```

### Build Windows Release

``` powershell
flutter build windows --release
```

------------------------------------------------------------------------

## 14. Project Snapshot

  Item               Current Setup
  ------------------ ---------------------------------------------
  Project            Student Desktop
  Type               Flutter Windows Desktop Application
  Main Language      Dart
  Framework          Flutter
  Architecture       Feature-First + Clean Architecture style
  State Management   Riverpod
  Routing            go_router
  API Client         Dio
  Database           Drift + SQLite
  Cache              Hive
  Connectivity       connectivity_plus
  Primary Platform   Windows
  Theme              Light / Dark / Auto
  Main Screens       Splash, Login, Dashboard, Courses, Settings

------------------------------------------------------------------------

## 15. Quick Architecture Map

``` text
Student Desktop
│
├── Flutter + Dart
│
├── Presentation
│   ├── Splash
│   ├── Login
│   ├── Dashboard
│   ├── Courses
│   └── Settings
│
├── State
│   └── Riverpod
│
├── Routing
│   └── go_router
│
├── Data
│   ├── Dio
│   ├── Drift + SQLite
│   └── Hive
│
├── Core
│   ├── Network
│   ├── Database
│   ├── Cache
│   ├── Sync
│   ├── Connectivity
│   ├── Errors
│   └── Theme
│
└── Shared
    └── Reusable Widgets
```

------------------------------------------------------------------------

## 16. Summary

Student Desktop is a **Flutter + Dart Windows desktop application**
built around a **Feature-First + Clean Architecture style**.

The core stack is:

``` text
Flutter
   +
Dart
   +
Riverpod
   +
go_router
   +
Dio
   +
Drift / SQLite
   +
Hive
```

The project has a structured `core/`, `features/`, and `shared/`
architecture, a centralized design system, reusable UI components, local
database support, caching, connectivity detection, and an offline-first
synchronization foundation.
