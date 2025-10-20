# GitConnect Showcase

A Flutter Web application demonstrating modern architecture with Riverpod, Clean Architecture, and GitHub API integration with AI-powered repository summarization.

## 🚀 Live Demo

**[View Live App](https://cristianmgm7.github.io/GitConnect_Showcase/)**

## ✨ Features

- **GitHub User Search** - Search for any GitHub user with debounced input
- **User Profile Display** - View user information, avatar, bio, and stats
- **Repository Listing** - Browse user repositories with pagination
- **AI Summarization** - Get AI-powered summaries of repository contents
- **Modern UI** - Clean Material Design interface
- **Responsive Design** - Optimized for web browsers

## 🏗️ Architecture

- **Clean Architecture** - Domain, Data, and Presentation layers
- **Riverpod** - State management with providers
- **Dependency Injection** - GetIt + Injectable
- **Freezed** - Immutable data models
- **Dio** - HTTP client for API calls
- **Flutter Hooks** - React-like hooks for Flutter

## 🛠️ Tech Stack

- **Flutter Web** - Cross-platform web development
- **GitHub API** - User and repository data
- **OpenAI API** - AI-powered repository summarization
- **RxDart** - Reactive programming for debouncing

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.24.0 or higher)
- Dart SDK
- OpenAI API Key (for AI features)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/cristianmgm7/GitConnect_Showcase.git
cd GitConnect_Showcase
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create environment file:
```bash
cp .env.example .env
# Add your OpenAI API key to .env
```

4. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. Run the app:
```bash
flutter run -d chrome
```

## 📱 Usage

1. **Search Users** - Type any GitHub username in the search bar
2. **View Profile** - See user information and statistics
3. **Browse Repositories** - Scroll through user's repositories
4. **Load More** - Click "Load More" to fetch additional repositories
5. **AI Summaries** - Click on repository cards to get AI-powered summaries

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the project root:

```env
OPENAI_API_KEY=your_openai_api_key_here
```

### API Keys

- **GitHub API** - No key required (rate limited to 60 requests/hour)
- **OpenAI API** - Required for AI summarization features

## 📦 Build for Production

```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GitHub for the comprehensive API
- OpenAI for AI capabilities
- Riverpod for state management