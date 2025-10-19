GitConnect — Showcase Project Summary

Quick summary

GitConnect is a Flutter Web showcase app that demonstrates modern Flutter architecture and tooling. It focuses on Riverpod for state management, Clean Architecture (MVVM flavor), Dio for HTTP, Freezed + JsonSerializable for immutable models, Drift for local SQL caching (web-friendly), and get_it + injectable for DI. The app uses the GitHub REST API to fetch user profiles, repositories, followers, and issues. Some write actions (e.g., starring) are simulated and stored locally.

⸻

Goals
	•	Learn and demonstrate Riverpod (async providers, Notifiers, StreamProviders).
	•	Model immutable domain objects using Freezed and JsonSerializable.
	•	Implement a robust networking layer with Dio (interceptors, error handling, retries).
	•	Add local SQL caching with Drift (suitable for Flutter Web).
	•	Keep code clean and SOLID using Clean Architecture layered approach and dependency injection (get_it + injectable).
	•	Deliver a responsive Flutter Web UI showcasing cross-device layout.

⸻

Tech stack
	•	Flutter (target: Web)
	•	Riverpod (v3+)
	•	Dio (HTTP client)
	•	Freezed + JsonSerializable (immutable models)
	•	Drift (local SQL database)
	•	get_it + injectable (DI)
	•	logger / sentry (optional for error logging)
	•	GitHub REST API v3

⸻

High-level architecture (Clean + MVVM flavor)
	•	Presentation layer: Widgets + Riverpod providers / Notifiers (acts like ViewModels)
	•	Application layer: Use cases / services that implement business logic
	•	Domain layer: Entities and repository interfaces
	•	Data layer: Remote and local data sources + concrete repository implementations
	•	DI layer: get_it + injectable module that wires everything

⸻

Step-by-step to start building (practical)
	1.	Create project & basic config
	•	flutter create gitconnect --web (or create with your usual template)
	•	Initialize git and create remote repo
	•	Add recommended files: .gitignore, README.md, .vscode / launch settings
	2.	Add dependencies
	•	Add packages to pubspec.yaml: flutter_riverpod, dio, freezed_annotation, build_runner, freezed, json_serializable, get_it, injectable, drift, drift_dev, sqlite3_flutter_libs (if needed), logger, flutter_hooks (optional), url_launcher (optional)
	3.	Set up DI with get_it + injectable
	•	Create lib/di/ and lib/di/injection.dart
	•	Annotate injectable modules and run flutter pub run build_runner build to generate code
	4.	Create networking core
	•	Implement ApiClient using Dio with interceptors for logging, auth header injection, and error handling.
	•	Add github_api_client.dart for GitHub-specific endpoints (users, repos, issues).
	5.	Design models using Freezed
	•	Create lib/domain/models/ with user.dart, repository.dart, issue.dart using Freezed + JsonSerializable.
	•	Run build_runner to generate code.
	6.	Define repositories & data sources
	•	Domain: abstract class UserRepository { Future<User> getUser(String login); ... }
	•	Data: RemoteUserDataSource (Dio), LocalUserDataSource (Drift)
	•	Implement UserRepositoryImpl that composes remote + local sources and coordinates caching.
	7.	Local database (Drift)
	•	Create lib/data/local/ and Drift schema for tables: users, repositories, favorites.
	•	Implement DAOs and mapping to/from Freezed models.
	8.	State management (Riverpod)
	•	For read operations use FutureProvider or AutoDisposeFutureProvider.
	•	For more complex flows use AsyncNotifier or Notifier (acts like ViewModel).
	•	For live DB streams use StreamProvider hooked to Drift query streams.
	9.	UI shell and routing
	•	Build a responsive layout: left sidebar (search/filter), main content (profile/repos), right panel (details). For web prefer LayoutBuilder and Responsive breakpoints.
	•	Use go_router or beamer (optional) for web-friendly routing.
	10.	Simulated write operations
	•	Implement local-only actions like starring a repository — update Drift and update providers to reflect the change.
	11.	Testing & QA
	•	Unit tests for repositories and Freezed models.
	•	Widget tests for key screens.
	•	Integration tests for main flows.
	12.	Deployment
	•	Build for web: flutter build web and host on Firebase Hosting, Netlify, or Vercel.

⸻

Folder structure suggestion

lib/
├─ src/
│  ├─ core/
│  │  ├─ network/
│  │  │  ├─ api_client.dart
│  │  │  └─ dio_interceptors.dart
│  │  ├─ error/
│  │  └─ di/
│  │     └─ injection.dart
│  ├─ domain/
│  │  ├─ models/
│  │  │  ├─ user.dart
│  │  │  ├─ repository.dart
│  │  │  └─ issue.dart
│  │  └─ repositories/
│  │     └─ user_repository.dart (abstract)
│  ├─ data/
│  │  ├─ remote/
│  │  │  └─ github_api_client.dart
│  │  ├─ local/
│  │  │  └─ drift_database.dart
│  │  └─ repository_impl/
│  │     └─ user_repository_impl.dart
│  ├─ app/
│  │  ├─ providers/
│  │  │  └─ user_providers.dart
│  │  ├─ viewmodels/
│  │  └─ routes.dart
│  └─ presentation/
│     ├─ pages/
│     │  ├─ home_page.dart
│     │  ├─ profile_page.dart
│     │  └─ repo_page.dart
│     └─ widgets/
│        ├─ repo_tile.dart
│        └─ mini_profile.dart


⸻

Minimal initial tasks (first coding day)
	•	Initialize project and git repo
	•	Add dependencies to pubspec.yaml
	•	Create DI bootstrap (injection.dart) and run build_runner
	•	Implement ApiClient with Dio and basic GET to GitHub public user endpoint
	•	Create Freezed model for User and test parsing a sample GitHub user JSON
	•	Create a simple FutureProvider that fetches a user and a minimal UI to show name/avatar

⸻

Notes & tips
	•	Why Dio? It’s the de facto standard in Flutter apps for advanced HTTP needs (interceptors, cancel tokens, file uploads). It will give you the most industry-relevant experience.
	•	Why Drift (SQL) instead of Isar? Isar has limited web support. Drift (with sqlite3_wasm where needed) is more web-friendly and teaches SQL concepts valuable for many employers.
	•	Riverpod streams: Drift queries expose streams. Use StreamProvider.autoDispose to connect DB changes directly to the UI and keep it reactive.
	•	Freezed sealed classes: Great for modeling API response states and union types (e.g., Result<T> with Success, Failure, Loading).

⸻

Next steps I can help with (pick one)
	•	Generate pubspec.yaml dependency list + versions to paste into the project.
	•	Scaffold the DI + ApiClient + a sample Freezed model and a minimal Riverpod provider + tiny UI proof-of-concept.
	•	Produce starter unit tests for repositories and providers.

⸻

Created for Cristian — concise, practical, and ready to code.