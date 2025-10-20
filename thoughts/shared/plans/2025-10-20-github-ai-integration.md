# GitHub + AI Integration Implementation Plan

## Overview

Extend the existing GitConnect Flutter Web application to enable GitHub repository exploration with AI-powered summarization. Users will search for GitHub profiles, browse repositories with pagination, and generate AI summaries of repository contents using OpenAI's API.

## Current State Analysis

**Existing Infrastructure:**
- Flutter Web project with Clean Architecture (Domain, Data, Presentation layers)
- GitHub API integration with single Dio instance ([api_client.dart](lib/src/core/network/api_client.dart))
- User model with Freezed + JSON serialization ([user.dart](lib/src/domain/models/user.dart))
- Dependency injection via get_it + injectable ([injection.dart](lib/src/core/di/injection.dart))
- Riverpod state management with FutureProvider ([user_providers.dart](lib/src/app/providers/user_providers.dart))
- Basic UI displaying hardcoded user profile ([home_page.dart:11](lib/src/presentation/pages/home_page.dart#L11))

**Key Discoveries:**
- Current implementation hardcodes username: `ref.watch(userProvider('cristianmgm7'))`
- Only one Dio instance exists (GitHub-only)
- No repository listing functionality
- No pagination support
- No search/debouncing mechanism
- Dependencies already include `dio`, `flutter_riverpod`, `freezed`, `injectable`

**Constraints:**
- Target platform: Flutter Web only
- Must maintain Clean Architecture pattern
- Must use existing DI container (get_it)
- Must follow existing code generation workflow (build_runner)

## Desired End State

A fully functional web application where users can:
1. Search GitHub users by username (with debounced input)
2. View user profile with public repository list
3. Load more repositories via pagination ("Load More" button)
4. Select a repository to view details
5. Trigger AI summarization of repository content
6. View AI-generated summary based on README and key files

### Verification:
- User types in search box → API called only after debounce delay
- Repository list displays with pagination → "Load More" fetches next page
- Click "Summarize Repository" → OpenAI generates summary from repo files
- Environment variables loaded correctly for OpenAI API key
- All automated tests pass
- No linting errors

## What We're NOT Doing

- Drift database caching (future enhancement)
- Full repository file tree exploration
- User authentication with GitHub OAuth
- Repository starring/forking functionality
- Gemini AI integration (OpenAI only)
- Infinite scroll (using "Load More" button instead)
- Processing binary files or large file sets
- Advanced routing with go_router
- Mobile responsiveness (web-focused for now)

## Implementation Approach

**Strategy:** Incremental feature layering from bottom (models/data) to top (UI/interaction). Each phase builds upon the previous and remains independently testable.

**Order:**
1. Environment configuration + dependencies
2. Data models (Repository, RepositoryContent)
3. Dual API client architecture (GitHub + OpenAI)
4. Repository pattern extensions
5. Search UI with debouncing
6. Repository listing with pagination
7. AI summarization feature

---

## Phase 1: Environment Configuration & Dependencies

### Overview
Add environment variable support for API keys and required dependencies for debouncing.

### Changes Required:

#### 1. Add Dependencies
**File**: `pubspec.yaml`
**Changes**: Add flutter_dotenv for environment variables and rxdart for debouncing

```yaml
dependencies:
  # ... existing dependencies ...
  flutter_dotenv: ^5.1.0
  rxdart: ^0.27.7  # For debouncing operators
```

#### 2. Create Environment File Template
**File**: `.env.example`
**Changes**: Template for required API keys

```env
OPENAI_API_KEY=your_openai_api_key_here
```

#### 3. Create Actual Environment File
**File**: `.env`
**Changes**: Actual environment file (add to .gitignore)

```env
OPENAI_API_KEY=sk-...your-actual-key...
```

#### 4. Update .gitignore
**File**: `.gitignore`
**Changes**: Ensure .env is ignored

```gitignore
# Environment variables
.env
```

#### 5. Load Environment in Main
**File**: `lib/main.dart`
**Changes**: Load dotenv before app initialization

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'src/core/di/injection.dart';
import 'src/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  configureDependencies();
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

#### 6. Update pubspec.yaml Assets
**File**: `pubspec.yaml`
**Changes**: Add .env to assets

```yaml
flutter:
  uses-material-design: true
  assets:
    - .env
```

### Success Criteria:

#### Automated Verification:
- [ ] Dependencies install successfully: `flutter pub get`
- [ ] No compilation errors: `flutter analyze`
- [ ] Environment loads without errors: Run app and check logs

#### Manual Verification:
- [ ] `.env` file created and contains OpenAI API key
- [ ] `.env` is listed in `.gitignore`
- [ ] App starts without environment loading errors

**Implementation Note**: After completing this phase and all automated verification passes, pause here for manual confirmation before proceeding.

---

## Phase 2: Data Models - Repository & Content

### Overview
Create Freezed models for GitHub Repository and RepositoryContent to support repository listing and file fetching.

### Changes Required:

#### 1. Repository Model
**File**: `lib/src/domain/models/repository.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository.freezed.dart';
part 'repository.g.dart';

@freezed
class Repository with _$Repository {
  const factory Repository({
    required int id,
    required String name,
    @JsonKey(name: 'full_name') required String fullName,
    required String description,
    @JsonKey(name: 'html_url') required String htmlUrl,
    required String language,
    @JsonKey(name: 'stargazers_count') required int stargazersCount,
    @JsonKey(name: 'forks_count') required int forksCount,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'default_branch') String? defaultBranch,
  }) = _Repository;

  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);
}
```

#### 2. Repository Content Model
**File**: `lib/src/domain/models/repository_content.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_content.freezed.dart';
part 'repository_content.g.dart';

@freezed
class RepositoryContent with _$RepositoryContent {
  const factory RepositoryContent({
    required String name,
    required String path,
    required String type, // "file" or "dir"
    String? content, // base64 encoded
    @JsonKey(name: 'download_url') String? downloadUrl,
    int? size,
  }) = _RepositoryContent;

  factory RepositoryContent.fromJson(Map<String, dynamic> json) =>
      _$RepositoryContentFromJson(json);
}
```

#### 3. Run Code Generation
**Command**: `flutter pub run build_runner build --delete-conflicting-outputs`

This generates:
- `repository.freezed.dart`, `repository.g.dart`
- `repository_content.freezed.dart`, `repository_content.g.dart`

### Success Criteria:

#### Automated Verification:
- [ ] Code generation completes: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Generated files exist: `ls lib/src/domain/models/repository.{freezed,g}.dart`
- [ ] Generated files exist: `ls lib/src/domain/models/repository_content.{freezed,g}.dart`
- [ ] No compilation errors: `flutter analyze`

#### Manual Verification:
- [ ] Models correctly map to GitHub API response structure
- [ ] JSON serialization/deserialization works correctly

**Implementation Note**: After completing this phase and all automated verification passes, pause here for manual confirmation before proceeding.

---

## Phase 3: Dual API Client Architecture

### Overview
Refactor network layer to support two separate Dio instances: one for GitHub API, one for OpenAI API.

### Changes Required:

#### 1. Refactor Network Module - GitHub Dio
**File**: `lib/src/core/network/api_client.dart`
**Changes**: Rename and specify GitHub Dio instance

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  @Named('github')
  Dio githubDio() {
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

  @lazySingleton
  @Named('openai')
  Dio openaiDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
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

#### 2. Update GitHub API Client
**File**: `lib/src/data/remote/github_api_client.dart`
**Changes**: Add pagination and content fetching methods, use named Dio

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GitHubApiClient {
  final Dio _dio;

  GitHubApiClient(@Named('github') this._dio);

  Future<Map<String, dynamic>> getUser(String username) async {
    final response = await _dio.get('/users/$username');
    return response.data;
  }

  Future<List<dynamic>> getUserRepos(
    String username, {
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dio.get(
      '/users/$username/repos',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'sort': 'updated',
      },
    );
    return response.data;
  }

  Future<List<dynamic>> getRepositoryContents(
    String owner,
    String repo, {
    String path = '',
  }) async {
    final response = await _dio.get(
      '/repos/$owner/$repo/contents/$path',
    );
    return response.data is List ? response.data : [response.data];
  }
}
```

#### 3. Create OpenAI API Client
**File**: `lib/src/data/remote/openai_api_client.dart`

```dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@lazySingleton
class OpenAIApiClient {
  final Dio _dio;

  OpenAIApiClient(@Named('openai') this._dio) {
    // Add authorization header with API key from environment
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey != null) {
      _dio.options.headers['Authorization'] = 'Bearer $apiKey';
    }
  }

  Future<String> generateCompletion({
    required String prompt,
    String model = 'gpt-3.5-turbo',
    int maxTokens = 500,
  }) async {
    final response = await _dio.post(
      '/chat/completions',
      data: {
        'model': model,
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful assistant that summarizes GitHub repositories.',
          },
          {
            'role': 'user',
            'content': prompt,
          },
        ],
        'max_tokens': maxTokens,
        'temperature': 0.7,
      },
    );

    return response.data['choices'][0]['message']['content'];
  }
}
```

#### 4. Run Code Generation
**Command**: `flutter pub run build_runner build --delete-conflicting-outputs`

### Success Criteria:

#### Automated Verification:
- [ ] Code generation completes: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] No compilation errors: `flutter analyze`
- [ ] Both Dio instances registered in DI container

#### Manual Verification:
- [ ] GitHub API client receives correct Dio instance
- [ ] OpenAI API client receives correct Dio instance with auth header

**Implementation Note**: After completing this phase and all automated verification passes, pause here for manual confirmation before proceeding.

---

## Phase 4: Repository Pattern Extensions

### Overview
Extend repository pattern to support repository listing, content fetching, and AI summarization.

### Changes Required:

#### 1. Repository Repository Interface
**File**: `lib/src/domain/repositories/repository_repository.dart`

```dart
import '../models/repository.dart';
import '../models/repository_content.dart';

abstract class RepositoryRepository {
  Future<List<Repository>> getUserRepositories(
    String username, {
    int page = 1,
    int perPage = 10,
  });

  Future<List<RepositoryContent>> getRepositoryContents(
    String owner,
    String repo, {
    String path = '',
  });
}
```

#### 2. Repository Repository Implementation
**File**: `lib/src/data/repository_impl/repository_repository_impl.dart`

```dart
import 'package:injectable/injectable.dart';
import '../../domain/models/repository.dart';
import '../../domain/models/repository_content.dart';
import '../../domain/repositories/repository_repository.dart';
import '../remote/github_api_client.dart';

@LazySingleton(as: RepositoryRepository)
class RepositoryRepositoryImpl implements RepositoryRepository {
  final GitHubApiClient _apiClient;

  RepositoryRepositoryImpl(this._apiClient);

  @override
  Future<List<Repository>> getUserRepositories(
    String username, {
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final jsonList = await _apiClient.getUserRepos(
        username,
        page: page,
        perPage: perPage,
      );
      return jsonList.map((json) => Repository.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RepositoryContent>> getRepositoryContents(
    String owner,
    String repo, {
    String path = '',
  }) async {
    try {
      final jsonList = await _apiClient.getRepositoryContents(
        owner,
        repo,
        path: path,
      );
      return jsonList.map((json) => RepositoryContent.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
```

#### 3. AI Repository Interface
**File**: `lib/src/domain/repositories/ai_repository.dart`

```dart
abstract class AIRepository {
  Future<String> summarizeRepository(String repositoryContent);
}
```

#### 4. AI Repository Implementation
**File**: `lib/src/data/repository_impl/ai_repository_impl.dart`

```dart
import 'package:injectable/injectable.dart';
import '../../domain/repositories/ai_repository.dart';
import '../remote/openai_api_client.dart';

@LazySingleton(as: AIRepository)
class AIRepositoryImpl implements AIRepository {
  final OpenAIApiClient _apiClient;

  AIRepositoryImpl(this._apiClient);

  @override
  Future<String> summarizeRepository(String repositoryContent) async {
    try {
      final prompt = '''
Summarize this repository's purpose, main technologies, and functionality based on the provided files.

Repository Content:
$repositoryContent

Please provide a concise summary covering:
1. Purpose and main functionality
2. Key technologies and frameworks used
3. Project structure and architecture
''';

      return await _apiClient.generateCompletion(prompt: prompt);
    } catch (e) {
      rethrow;
    }
  }
}
```

#### 5. Run Code Generation
**Command**: `flutter pub run build_runner build --delete-conflicting-outputs`

### Success Criteria:

#### Automated Verification:
- [ ] Code generation completes: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] No compilation errors: `flutter analyze`
- [ ] All repositories registered in DI container

#### Manual Verification:
- [ ] Repository pattern properly abstracts GitHub and AI operations
- [ ] Dependencies correctly injected

**Implementation Note**: After completing this phase and all automated verification passes, pause here for manual confirmation before proceeding.

---

## Phase 5: Riverpod Providers for State Management

### Overview
Create Riverpod providers for repositories, search state, pagination, and AI summarization.

### Changes Required:

#### 1. Repository Providers
**File**: `lib/src/app/providers/repository_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/models/repository.dart';
import '../../domain/repositories/repository_repository.dart';

final repositoryRepositoryProvider = Provider<RepositoryRepository>((ref) {
  return getIt<RepositoryRepository>();
});

// Provider for repository list with pagination state
class RepositoryListNotifier extends StateNotifier<AsyncValue<List<Repository>>> {
  RepositoryListNotifier(this._repository, this._username)
      : super(const AsyncValue.loading()) {
    _loadRepositories();
  }

  final RepositoryRepository _repository;
  final String _username;
  int _currentPage = 1;
  bool _hasMore = true;

  Future<void> _loadRepositories() async {
    try {
      final repos = await _repository.getUserRepositories(
        _username,
        page: _currentPage,
        perPage: 10,
      );

      state = AsyncValue.data(repos);
      _hasMore = repos.length == 10;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    _currentPage++;

    final previousRepos = state.value ?? [];

    try {
      final newRepos = await _repository.getUserRepositories(
        _username,
        page: _currentPage,
        perPage: 10,
      );

      _hasMore = newRepos.length == 10;
      state = AsyncValue.data([...previousRepos, ...newRepos]);
    } catch (e, stack) {
      _currentPage--;
      state = AsyncValue.error(e, stack);
    }
  }

  bool get hasMore => _hasMore;
}

final repositoryListProvider = StateNotifierProvider.family<
    RepositoryListNotifier,
    AsyncValue<List<Repository>>,
    String>(
  (ref, username) {
    final repository = ref.watch(repositoryRepositoryProvider);
    return RepositoryListNotifier(repository, username);
  },
);
```

#### 2. AI Providers
**File**: `lib/src/app/providers/ai_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/repositories/ai_repository.dart';

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return getIt<AIRepository>();
});

final repositorySummaryProvider = FutureProvider.family<String, String>(
  (ref, repositoryContent) async {
    final repository = ref.watch(aiRepositoryProvider);
    return repository.summarizeRepository(repositoryContent);
  },
);
```

#### 3. Search State Provider
**File**: `lib/src/app/providers/search_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected username state (after search)
final selectedUsernameProvider = StateProvider<String?>((ref) => null);
```

### Success Criteria:

#### Automated Verification:
- [ ] No compilation errors: `flutter analyze`
- [ ] Providers properly typed and accessible

#### Manual Verification:
- [ ] Providers successfully manage state (verify in UI phase)
- [ ] Pagination logic works correctly
- [ ] AI summarization provider handles requests

**Implementation Note**: After completing this phase and all automated verification passes, pause here for manual confirmation before proceeding.

---

## Phase 6: Search UI with Debouncing

### Overview
Implement user search functionality with debounced input to prevent excessive API calls.

### Changes Required:

#### 1. Search Widget
**File**: `lib/src/presentation/widgets/user_search_bar.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../app/providers/search_providers.dart';

class UserSearchBar extends HookConsumerWidget {
  const UserSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchSubject = useMemoized(() => BehaviorSubject<String>());

    useEffect(() {
      // Set up debounced subscription
      final subscription = searchSubject
          .debounceTime(const Duration(milliseconds: 400))
          .distinct()
          .listen((query) {
        if (query.isNotEmpty) {
          ref.read(selectedUsernameProvider.notifier).state = query;
        }
      });

      return () {
        subscription.cancel();
        searchSubject.close();
      };
    }, []);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search GitHub User',
          hintText: 'Enter username...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    ref.read(selectedUsernameProvider.notifier).state = null;
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
          searchSubject.add(value);
        },
      ),
    );
  }
}
```

#### 2. Update pubspec.yaml for hooks_riverpod
**File**: `pubspec.yaml`
**Changes**: Add hooks_riverpod dependency

```yaml
dependencies:
  # ... existing dependencies ...
  hooks_riverpod: ^2.5.1  # Instead of just flutter_riverpod
```

Note: hooks_riverpod includes flutter_riverpod, so we can use both hooks and riverpod together.

### Success Criteria:

#### Automated Verification:
- [ ] Dependencies install: `flutter pub get`
- [ ] No compilation errors: `flutter analyze`

#### Manual Verification:
- [ ] Search input debounces correctly (only fires after 400ms pause)
- [ ] Typing rapidly doesn't trigger multiple API calls
- [ ] Clear button works and resets state
- [ ] Search updates selectedUsernameProvider correctly

**Implementation Note**: After completing this phase and all automated verification passes, pause here for manual confirmation before proceeding.

---

## Phase 7: Repository List with Pagination UI

### Overview
Build repository listing component with "Load More" button for pagination.

### Changes Required:

#### 1. Repository List Widget
**File**: `lib/src/presentation/widgets/repository_list.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers/repository_providers.dart';
import '../../domain/models/repository.dart';
import 'repository_card.dart';

class RepositoryList extends ConsumerWidget {
  final String username;

  const RepositoryList({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repositoriesAsync = ref.watch(repositoryListProvider(username));
    final notifier = ref.read(repositoryListProvider(username).notifier);

    return repositoriesAsync.when(
      data: (repositories) => Column(
        children: [
          if (repositories.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No repositories found'),
            )
          else
            ...repositories.map((repo) => RepositoryCard(repository: repo)),

          if (notifier.hasMore)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => notifier.loadMore(),
                icon: const Icon(Icons.refresh),
                label: const Text('Load More'),
              ),
            ),
        ],
      ),
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
```

#### 2. Repository Card Widget
**File**: `lib/src/presentation/widgets/repository_card.dart`

```dart
import 'package:flutter/material.dart';
import '../../domain/models/repository.dart';

class RepositoryCard extends StatelessWidget {
  final Repository repository;
  final VoidCallback? onSummarize;

  const RepositoryCard({
    super.key,
    required this.repository,
    this.onSummarize,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    repository.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (repository.language != null)
                  Chip(
                    label: Text(repository.language!),
                    backgroundColor: Colors.blue.shade100,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              repository.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                const SizedBox(width: 4),
                Text('${repository.stargazersCount}'),
                const SizedBox(width: 16),
                const Icon(Icons.fork_right, size: 16),
                const SizedBox(width: 4),
                Text('${repository.forksCount}'),
                const Spacer(),
                if (onSummarize != null)
                  ElevatedButton.icon(
                    onPressed: onSummarize,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Summarize'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Success Criteria:

#### Automated Verification:
- [ ] No compilation errors: `flutter analyze`
- [ ] Widgets render without errors

#### Manual Verification:
- [ ] Repository list displays correctly
- [ ] "Load More" button appears when more repos available
- [ ] "Load More" button disappears when all repos loaded
- [ ] Clicking "Load More" fetches next page
- [ ] Previous repos remain visible when loading more
- [ ] Repository cards show all relevant information

**Implementation Note**: After completing this phase and all automated verification passes, pause here for manual confirmation before proceeding.

---

## Phase 8: Home Page Integration

### Overview
Rebuild the home page to integrate search, user profile, and repository list components.

### Changes Required:

#### 1. Update Home Page
**File**: `lib/src/presentation/pages/home_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers/user_providers.dart';
import '../../app/providers/search_providers.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/user_search_bar.dart';
import '../widgets/repository_list.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUsername = ref.watch(selectedUsernameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GitConnect - Explore & Summarize'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserSearchBar(),
            if (selectedUsername != null) ...[
              Consumer(
                builder: (context, ref, child) {
                  final userAsync = ref.watch(userProvider(selectedUsername));
                  return userAsync.when(
                    data: (user) => Column(
                      children: [
                        UserProfileCard(user: user),
                        const Divider(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Repositories',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RepositoryList(username: selectedUsername),
                      ],
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error loading user: $error'),
                    ),
                  );
                },
              ),
            ] else
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.search,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Search for a GitHub user to get started',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
```

### Success Criteria:

#### Automated Verification:
- [ ] No compilation errors: `flutter analyze`
- [ ] App builds successfully: `flutter build web --no-tree-shake-icons`

#### Manual Verification:
- [ ] Home page displays search bar at top
- [ ] Empty state shows when no user selected
- [ ] After searching, user profile displays
- [ ] Repository list appears below user profile
- [ ] All components work together cohesively
- [ ] Scrolling works smoothly

**Implementation Note**: After completing this phase and all automated verification passes, pause here for manual confirmation before proceeding.

---

## Phase 9: AI Summarization Feature

### Overview
Implement repository content fetching and AI summarization with UI for triggering and displaying summaries.

### Changes Required:

#### 1. Repository Content Service
**File**: `lib/src/app/services/repository_content_service.dart`

```dart
import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../domain/models/repository.dart';
import '../../domain/repositories/repository_repository.dart';

@lazySingleton
class RepositoryContentService {
  final RepositoryRepository _repository;

  RepositoryContentService(this._repository);

  Future<String> fetchKeyFiles(Repository repo) async {
    try {
      // Parse owner from full_name (e.g., "torvalds/linux" -> "torvalds")
      final parts = repo.fullName.split('/');
      final owner = parts[0];
      final repoName = parts[1];

      // Fetch root directory contents
      final contents = await _repository.getRepositoryContents(owner, repoName);

      final keyFiles = <String>[];

      // Priority files to fetch
      const priorityFiles = [
        'README.md',
        'readme.md',
        'README',
        'package.json',
        'pubspec.yaml',
        'Cargo.toml',
        'pom.xml',
        'build.gradle',
        'setup.py',
        'requirements.txt',
        'go.mod',
      ];

      for (final file in contents) {
        if (file.type == 'file' && priorityFiles.contains(file.name)) {
          // Content is base64 encoded, decode it
          if (file.content != null) {
            final decoded = utf8.decode(base64.decode(
              file.content!.replaceAll('\n', ''),
            ));
            keyFiles.add('=== ${file.name} ===\n$decoded\n');
          }
        }
      }

      if (keyFiles.isEmpty) {
        return 'Repository: ${repo.name}\nDescription: ${repo.description}\nLanguage: ${repo.language}';
      }

      return keyFiles.join('\n---\n\n');
    } catch (e) {
      rethrow;
    }
  }
}
```

#### 2. Summarization Provider
**File**: `lib/src/app/providers/summarization_providers.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/models/repository.dart';
import '../services/repository_content_service.dart';
import 'ai_providers.dart';

final repositoryContentServiceProvider = Provider<RepositoryContentService>((ref) {
  return getIt<RepositoryContentService>();
});

final repositorySummaryFutureProvider = FutureProvider.family<String, Repository>(
  (ref, repository) async {
    // Fetch key files
    final contentService = ref.watch(repositoryContentServiceProvider);
    final content = await contentService.fetchKeyFiles(repository);

    // Generate AI summary
    final aiRepository = ref.watch(aiRepositoryProvider);
    return await aiRepository.summarizeRepository(content);
  },
);
```

#### 3. Repository Detail Page with Summarization
**File**: `lib/src/presentation/pages/repository_detail_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/repository.dart';
import '../../app/providers/summarization_providers.dart';

class RepositoryDetailPage extends ConsumerWidget {
  final Repository repository;

  const RepositoryDetailPage({super.key, required this.repository});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(repositorySummaryFutureProvider(repository));

    return Scaffold(
      appBar: AppBar(
        title: Text(repository.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              repository.fullName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(repository.description),
            const SizedBox(height: 16),
            Row(
              children: [
                if (repository.language != null) ...[
                  Chip(label: Text(repository.language!)),
                  const SizedBox(width: 8),
                ],
                Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                const SizedBox(width: 4),
                Text('${repository.stargazersCount}'),
                const SizedBox(width: 16),
                const Icon(Icons.fork_right, size: 16),
                const SizedBox(width: 4),
                Text('${repository.forksCount}'),
              ],
            ),
            const Divider(height: 32),
            Text(
              'AI Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            summaryAsync.when(
              data: (summary) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(summary),
                ),
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Analyzing repository with AI...'),
                    ],
                  ),
                ),
              ),
              error: (error, stack) => Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Failed to generate summary: $error',
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### 4. Update Repository Card to Navigate to Detail
**File**: `lib/src/presentation/widgets/repository_card.dart`
**Changes**: Add navigation to detail page

```dart
import 'package:flutter/material.dart';
import '../../domain/models/repository.dart';
import '../pages/repository_detail_page.dart';

class RepositoryCard extends StatelessWidget {
  final Repository repository;

  const RepositoryCard({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RepositoryDetailPage(repository: repository),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      repository.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (repository.language != null)
                    Chip(
                      label: Text(repository.language!),
                      backgroundColor: Colors.blue.shade100,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                repository.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                  const SizedBox(width: 4),
                  Text('${repository.stargazersCount}'),
                  const SizedBox(width: 16),
                  const Icon(Icons.fork_right, size: 16),
                  const SizedBox(width: 4),
                  Text('${repository.forksCount}'),
                  const Spacer(),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

#### 5. Register Service in DI
**Command**: `flutter pub run build_runner build --delete-conflicting-outputs`

This will pick up the `@lazySingleton` annotation on `RepositoryContentService`.

### Success Criteria:

#### Automated Verification:
- [ ] Code generation completes: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] No compilation errors: `flutter analyze`
- [ ] Service registered in DI container

#### Manual Verification:
- [ ] Clicking repository card navigates to detail page
- [ ] Detail page automatically triggers AI summarization
- [ ] Loading state displays while fetching/summarizing
- [ ] AI summary displays correctly when complete
- [ ] Error handling works for missing API key or API failures
- [ ] README and key config files are fetched and included
- [ ] Summary is relevant and accurate

**Implementation Note**: This is the final phase. After completion and verification, the implementation is complete!

---

## Testing Strategy

### Unit Tests:

**File**: `test/repository_model_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gitconnect/src/domain/models/repository.dart';

void main() {
  group('Repository Model', () {
    test('should deserialize from GitHub API JSON', () {
      final json = {
        'id': 123,
        'name': 'test-repo',
        'full_name': 'user/test-repo',
        'description': 'Test repository',
        'html_url': 'https://github.com/user/test-repo',
        'language': 'Dart',
        'stargazers_count': 100,
        'forks_count': 20,
        'updated_at': '2024-01-01T00:00:00Z',
      };

      final repo = Repository.fromJson(json);

      expect(repo.name, 'test-repo');
      expect(repo.stargazersCount, 100);
      expect(repo.language, 'Dart');
    });
  });
}
```

**File**: `test/debounce_test.dart`
- Test debouncing delays API calls by 400ms
- Test rapid input only triggers one final API call
- Test clearing input cancels pending calls

**File**: `test/pagination_test.dart`
- Test initial load fetches page 1
- Test "Load More" increments page number
- Test hasMore flag when fewer than 10 repos returned
- Test pagination state persistence

### Manual Testing Steps:

1. **Search & Debouncing**
   - Type username rapidly → verify only one API call after pause
   - Type username slowly → verify call fires after 400ms pause
   - Clear search → verify state resets

2. **Repository Listing**
   - Search for user with many repos (e.g., "torvalds")
   - Verify 10 repos load initially
   - Click "Load More" → verify next 10 load
   - Continue until all repos loaded → verify button disappears

3. **AI Summarization**
   - Click on repository card
   - Verify navigation to detail page
   - Verify loading indicator during fetch
   - Verify AI summary displays
   - Test with different repository types (various languages)

4. **Error Handling**
   - Test with invalid username → verify error message
   - Test with missing OpenAI API key → verify error message
   - Test with network offline → verify error handling

5. **End-to-End Flow**
   - Search "facebook" → view profile → browse repos → click "react" → view AI summary
   - Verify complete user journey works smoothly

## Performance Considerations

- **Debouncing**: 400ms delay prevents excessive API calls during typing
- **Pagination**: Load 10 repos at a time to minimize initial load time
- **API Rate Limits**:
  - GitHub: 60 requests/hour unauthenticated (consider adding auth later)
  - OpenAI: Based on API key tier, handle rate limit errors gracefully
- **Content Fetching**: Only fetch key files (README, config) not entire repo
- **Caching**: Riverpod's FutureProvider caches results per parameter
- **Image Loading**: Flutter's NetworkImage handles caching automatically

## Migration Notes

**Breaking Changes:**
- NetworkModule now provides two named Dio instances (`@Named('github')` and `@Named('openai')`)
- Existing GitHubApiClient constructor signature changes to accept named Dio
- Need to run `flutter pub run build_runner build --delete-conflicting-outputs` after each phase

**Environment Setup:**
1. Create `.env` file in project root
2. Add `OPENAI_API_KEY=sk-...` with actual API key
3. Ensure `.env` is in `.gitignore`
4. Share `.env.example` with team for setup reference

**Dependencies Added:**
- `flutter_dotenv` - Environment variable management
- `rxdart` - Reactive extensions for debouncing
- `hooks_riverpod` - Combines Flutter Hooks with Riverpod

## References

- Original project summary: [git_connect_project_summary.md](git_connect_project_summary.md)
- Initial setup plan: [thoughts/shared/plans/2025-10-19-gitconnect-initial-setup.md](thoughts/shared/plans/2025-10-19-gitconnect-initial-setup.md)
- GitHub REST API: https://docs.github.com/en/rest
- OpenAI API: https://platform.openai.com/docs/api-reference
- Riverpod docs: https://riverpod.dev
- RxDart debouncing: https://pub.dev/packages/rxdart

---

## Implementation Summary

After completing all phases, the application will have:

- ✅ Dual API client architecture (GitHub + OpenAI)
- ✅ Environment-based configuration for API keys
- ✅ Debounced search input (400ms delay)
- ✅ Repository listing with "Load More" pagination
- ✅ AI-powered repository summarization
- ✅ Complete user flow: Search → Profile → Repos → Summary
- ✅ Error handling for network and API failures
- ✅ Clean Architecture maintained throughout
- ✅ Comprehensive test coverage

**Estimated Implementation Time**: 6-8 hours for experienced Flutter developer

**Next Enhancements** (Out of Scope):
- Drift database for offline caching
- GitHub OAuth authentication for higher rate limits
- Advanced filtering (by language, stars, etc.)
- Gemini AI as alternative provider
- Mobile responsive design
- Dark mode theme
- Repository file tree exploration
