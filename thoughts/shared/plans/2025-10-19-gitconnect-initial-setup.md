# GitConnect Initial Setup - Day 1 Implementation Plan

## Overview

Set up the GitConnect showcase Flutter Web project from scratch with foundational architecture: Clean Architecture layers, Riverpod state management, Dio networking, Freezed models, and get_it dependency injection. Deliver a working proof-of-concept that fetches and displays a GitHub user profile.

## Current State Analysis

- Fresh git repository with only README.md and project summary
- No Flutter project structure exists yet
- No dependencies configured
- Target platform: Flutter Web

### What We're NOT Doing

- Drift database integration (Phase 2)
- Repository/Issue listing features (Phase 2)
- Simulated write operations (Phase 3)
- Advanced routing with go_router (Phase 2)
- Comprehensive testing suite (Phase 2)
- Production deployment (Phase 3)

## Desired End State

A working Flutter Web application that:
- Fetches a GitHub user profile via the GitHub API
- Displays user name and avatar in a minimal UI
- Demonstrates the complete architectural stack functioning together
- Has all code generation working (Freezed, injectable)
- Follows the planned folder structure

### Verification:
- Run `flutter run -d chrome` and see a GitHub user profile displayed
- Code generation completes without errors
- DI container initializes successfully
- API call to GitHub succeeds and parses correctly

## Implementation Approach

Bottom-up layered approach: Start with infrastructure (DI, networking), build data layer (models, API client), then application layer (providers), finally presentation layer (UI). This ensures each layer can be tested as we build up.

---

## Phase 1: Project Initialization & Dependencies

### Overview
Create the Flutter project structure and configure all required dependencies.

### Changes Required:

#### 1. Flutter Project Creation
**Command**: `flutter create gitconnect --platforms=web`
**Changes**: Creates standard Flutter project structure targeting web platform

#### 2. Configure pubspec.yaml
**File**: `pubspec.yaml`
**Changes**: Add all required dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  dio: ^5.4.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  get_it: ^7.6.7
  injectable: ^2.3.2
  logger: ^2.0.2+1
  flutter_hooks: ^0.20.5

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.8
  freezed: ^2.4.6
  json_serializable: ^6.7.1
  injectable_generator: ^2.4.1
  flutter_lints: ^3.0.1
```

#### 3. Create Folder Structure
**Directories to create**:
```
lib/src/
├── core/
│   ├── network/
│   ├── error/
│   └── di/
├── domain/
│   ├── models/
│   └── repositories/
├── data/
│   ├── remote/
│   └── repository_impl/
├── app/
│   └── providers/
└── presentation/
    ├── pages/
    └── widgets/
```

### Success Criteria:

#### Automated Verification:
- [ ] Flutter project exists: `ls lib/main.dart`
- [ ] Dependencies resolve: `flutter pub get`
- [ ] Project structure matches plan: `ls -R lib/src/`
- [ ] No analysis errors: `flutter analyze`

#### Manual Verification:
- [ ] Default Flutter app runs in Chrome: `flutter run -d chrome`

**Implementation Note**: After completing this phase and all automated verification passes, pause for confirmation before proceeding.

---

## Phase 2: Dependency Injection Setup

### Overview
Configure get_it + injectable for dependency injection with code generation.

### Changes Required:

#### 1. Create DI Module
**File**: `lib/src/core/di/injection.dart`

```dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
}
```

#### 2. Create Injectable Config
**File**: `build.yaml`

```yaml
targets:
  $default:
    builders:
      injectable_generator:injectable_builder:
        enabled: true
```

#### 3. Run Code Generation
**Command**: `flutter pub run build_runner build --delete-conflicting-outputs`

### Success Criteria:

#### Automated Verification:
- [ ] Code generation completes: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Generated file exists: `ls lib/src/core/di/injection.config.dart`
- [ ] No compilation errors: `flutter analyze`

#### Manual Verification:
- [ ] DI initialization works (verify in next phase)

---

## Phase 3: Networking Layer (Dio + API Client)

### Overview
Implement Dio-based API client with interceptors for GitHub API communication.

### Changes Required:

#### 1. API Client with Dio
**File**: `lib/src/core/network/api_client.dart`

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.github.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => Logger().d(obj),
    ));

    return dio;
  }
}
```

#### 2. GitHub API Client
**File**: `lib/src/data/remote/github_api_client.dart`

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GitHubApiClient {
  final Dio _dio;

  GitHubApiClient(this._dio);

  Future<Map<String, dynamic>> getUser(String username) async {
    final response = await _dio.get('/users/$username');
    return response.data;
  }

  Future<List<dynamic>> getUserRepos(String username) async {
    final response = await _dio.get('/users/$username/repos');
    return response.data;
  }
}
```

#### 3. Error Handling
**File**: `lib/src/core/error/exceptions.dart`

```dart
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message (code: $statusCode)';
}
```

### Success Criteria:

#### Automated Verification:
- [ ] Code generation succeeds: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] No compilation errors: `flutter analyze`
- [ ] No linting issues: `flutter analyze`

#### Manual Verification:
- [ ] Dio client initializes (verify in next phase when calling API)

---

## Phase 4: Domain Models with Freezed

### Overview
Create immutable User model using Freezed + JsonSerializable for GitHub user data.

### Changes Required:

#### 1. User Model
**File**: `lib/src/domain/models/user.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String login,
    @JsonKey(name: 'avatar_url') required String avatarUrl,
    String? name,
    String? bio,
    @JsonKey(name: 'public_repos') int? publicRepos,
    int? followers,
    int? following,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

#### 2. Run Code Generation
**Command**: `flutter pub run build_runner build --delete-conflicting-outputs`

This generates:
- `user.freezed.dart` (immutable class implementation)
- `user.g.dart` (JSON serialization)

### Success Criteria:

#### Automated Verification:
- [ ] Code generation completes: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Generated files exist: `ls lib/src/domain/models/user.{freezed,g}.dart`
- [ ] No compilation errors: `flutter analyze`
- [ ] Model serialization works: Create unit test parsing sample JSON

#### Manual Verification:
- [ ] User model correctly represents GitHub API response structure

---

## Phase 5: Repository Pattern Implementation

### Overview
Implement repository interface and concrete implementation for user data fetching.

### Changes Required:

#### 1. Repository Interface
**File**: `lib/src/domain/repositories/user_repository.dart`

```dart
import '../models/user.dart';

abstract class UserRepository {
  Future<User> getUser(String username);
}
```

#### 2. Repository Implementation
**File**: `lib/src/data/repository_impl/user_repository_impl.dart`

```dart
import 'package:injectable/injectable.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../remote/github_api_client.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final GitHubApiClient _apiClient;

  UserRepositoryImpl(this._apiClient);

  @override
  Future<User> getUser(String username) async {
    try {
      final json = await _apiClient.getUser(username);
      return User.fromJson(json);
    } catch (e) {
      rethrow;
    }
  }
}
```

### Success Criteria:

#### Automated Verification:
- [ ] Code generation includes repository: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] No compilation errors: `flutter analyze`
- [ ] Repository registered in DI container

#### Manual Verification:
- [ ] Repository pattern properly abstracts data access

---

## Phase 6: Riverpod State Management

### Overview
Create Riverpod provider to fetch user data and manage state.

### Changes Required:

#### 1. User Provider
**File**: `lib/src/app/providers/user_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return getIt<UserRepository>();
});

final userProvider = FutureProvider.family<User, String>((ref, username) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser(username);
});
```

### Success Criteria:

#### Automated Verification:
- [ ] No compilation errors: `flutter analyze`
- [ ] Provider properly typed and accessible

#### Manual Verification:
- [ ] Provider successfully fetches and provides user data (verify in UI phase)

---

## Phase 7: Minimal UI Implementation

### Overview
Create a simple UI to display GitHub user profile demonstrating the complete stack working.

### Changes Required:

#### 1. Update Main Entry Point
**File**: `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/di/injection.dart';
import 'src/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitConnect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
```

#### 2. Home Page
**File**: `lib/src/presentation/pages/home_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers/user_providers.dart';
import '../widgets/user_profile_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider('torvalds')); // Example: Linus Torvalds

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitConnect Showcase'),
      ),
      body: Center(
        child: userAsync.when(
          data: (user) => UserProfileCard(user: user),
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }
}
```

#### 3. User Profile Card Widget
**File**: `lib/src/presentation/widgets/user_profile_card.dart`

```dart
import 'package:flutter/material.dart';
import '../../domain/models/user.dart';

class UserProfileCard extends StatelessWidget {
  final User user;

  const UserProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            const SizedBox(height: 16),
            Text(
              user.name ?? user.login,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('@${user.login}'),
            if (user.bio != null) ...[
              const SizedBox(height: 8),
              Text(user.bio!),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem('Repos', user.publicRepos ?? 0),
                _StatItem('Followers', user.followers ?? 0),
                _StatItem('Following', user.following ?? 0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;

  const _StatItem(this.label, this.count);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(label),
      ],
    );
  }
}
```

### Success Criteria:

#### Automated Verification:
- [ ] No compilation errors: `flutter analyze`
- [ ] No linting warnings: `flutter analyze`
- [ ] App builds successfully: `flutter build web --no-tree-shake-icons`

#### Manual Verification:
- [ ] App runs in Chrome: `flutter run -d chrome`
- [ ] User profile displays correctly with avatar, name, and stats
- [ ] Loading state shows while fetching data
- [ ] Error handling displays if network fails
- [ ] All architectural layers working together (DI → Repository → Provider → UI)

**Implementation Note**: This is the final phase. After completion and verification, the Day 1 setup is complete!

---

## Testing Strategy

### Unit Tests:
- User model JSON parsing with sample GitHub API response
- Repository mock tests for error handling
- Provider state transitions

### Manual Testing Steps:
1. Run app and verify Linus Torvalds profile loads
2. Check browser DevTools Network tab for API call
3. Test with different usernames by modifying code
4. Verify error handling by testing with invalid username
5. Check responsive layout at different browser widths

## Performance Considerations

- Dio connection pooling enabled by default
- FutureProvider.family caches results per username
- Image loading handled by Flutter's network image cache
- Web build optimizations with `--web-renderer canvaskit` for better performance

## References

- Project summary: `git_connect_project_summary.md`
- Flutter Web docs: https://docs.flutter.dev/platform-integration/web
- Riverpod docs: https://riverpod.dev
- GitHub API v3: https://docs.github.com/en/rest

---

## Success Summary

After completing all phases, you will have:
- ✅ Flutter Web project initialized
- ✅ Clean Architecture folder structure
- ✅ DI with get_it + injectable working
- ✅ Dio networking layer configured
- ✅ Freezed models with JSON serialization
- ✅ Repository pattern implemented
- ✅ Riverpod state management
- ✅ Working UI displaying GitHub user profile

**Next session goals**: Add Drift database for local caching, implement repository listing, build responsive layout with search functionality.
