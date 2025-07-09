# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**trippath** is a Flutter-based trip/travel planning application using Clean Architecture principles for cross-platform mobile development (iOS and Android).

## Development Commands

### Essential Commands
- `flutter pub get` - Install/update dependencies
- `flutter run` - Run the app on connected device/emulator
- `flutter analyze` - Run static analysis to check for issues
- `flutter test` - Run all tests

### Build Commands
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (macOS required)
- `flutter build apk --release` - Build release APK
- `flutter clean` - Clean build artifacts when encountering build issues

### Testing Commands
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run specific test file
- `flutter test --coverage` - Run tests with coverage report

### Development Workflow
- `flutter doctor` - Check Flutter installation and dependencies
- Hot reload: Save file or press 'r' in terminal during `flutter run`
- Hot restart: Press 'R' in terminal during `flutter run`

## Code Architecture

The project follows **Clean Architecture** with feature-based organization:

```
lib/
├── core/                    # Core functionality shared across features
│   ├── constants/          # App-wide constants (colors, strings, dimensions)
│   ├── themes/            # Theme configurations and styling
│   └── utils/             # Utility functions and helpers
├── features/              # Feature modules
│   ├── auth/             # Authentication feature
│   │   ├── data/         # Data layer (repositories, data sources, models)
│   │   ├── domain/       # Domain layer (entities, use cases, repository interfaces)
│   │   └── presentation/ # Presentation layer (pages, widgets, state management)
│   └── home/             # Home feature
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/               # Shared components
│   ├── services/        # Shared services (API, storage, etc.)
│   └── widgets/         # Reusable UI components
└── main.dart            # Application entry point
```

### Architecture Principles

1. **Clean Architecture Layers**:
   - **Domain**: Business logic, entities, use cases (no external dependencies)
   - **Data**: Repository implementations, data sources, DTOs
   - **Presentation**: UI components, pages, state management

2. **Dependency Rule**: Dependencies point inward (Presentation → Domain ← Data)

3. **Feature-First**: Each feature is self-contained with its own layers

## Key Technical Details

- Flutter SDK: 3.32.5
- Dart SDK: ^3.8.1
- Linting: flutter_lints package with default rules
- Android: Kotlin with Gradle KTS, targets Java 11
- Package ID: com.tripkits.trippath.trippath

## Dependencies

### Production Dependencies
- **get_it**: ^7.6.0 - Dependency injection
- **injectable**: ^2.3.0 - Automatic setup for get_it
- **go_router**: ^13.0.0 - Routing and navigation
- **dio**: ^5.8.0+1 - HTTP networking client
- **flutter_riverpod**: ^2.6.1 - State management
- **cupertino_icons**: ^1.0.8 - iOS style icons

### Development Dependencies
- **build_runner**: ^2.4.0 - Code generation
- **freezed**: ^2.4.0 - Immutable model classes and unions
- **json_serializable**: ^6.7.0 - JSON serialization code generation
- **flutter_gen**: ^5.3.0 - Asset code generation
- **flutter_lints**: ^5.0.0 - Lint rules

## Important Development Guidelines

1. **Feature Development**: When adding new features, create a new folder under `features/` with data, domain, and presentation subdirectories

2. **State Management**: The project uses Riverpod for state management in the presentation layer

3. **Dependencies**: The project uses get_it with injectable for dependency injection. Add feature-specific dependencies carefully to maintain clean architecture boundaries

4. **Testing**: Create tes1t files mirroring the lib structure under test/

5. **Shared Code**: Place reusable widgets in `shared/widgets/` and common services in `shared/services/`

6. **Code Generation**: Run `flutter pub run build_runner build` after modifying files that use code generation (freezed, json_serializable, injectable)

7. **Routing**: Use go_router for navigation between screens

## Next Implementation Steps

1. Set up Riverpod providers structure
2. Add necessary packages for local storage (hive, sqflite)
3. Create base classes for repositories, use cases, and data sources
4. Implement authentication feature
5. Configure go_router for navigation