# Flutter News App

A modern news application built with Flutter that provides users with the latest news articles from various sources.

## Features

- **User Authentication**: Secure login system with email validation
- **News Feed**: Display of latest news articles with images and descriptions
- **Search Functionality**: Search for specific news topics
- **Article View**: Read full articles within the app using WebView
- **Pull to Refresh**: Update news feed with the latest articles
- **Error Handling**: Graceful handling of API errors with fallback to sample data
- **Responsive Design**: Works on various screen sizes and orientations
- **Light/Dark Mode**: Automatically adapts to system theme settings


## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extension
- Android Emulator / iOS Simulator or physical device

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/flutter_news_app.git
cd flutter_news_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Replace the News API key:
   Navigate to `lib/providers/news_providers.dart` and replace the placeholder API key with your own:
```dart
final String _apiKey = 'your_newsapi_org_key_here';
```

4. Run the app:
```bash
flutter run
```

## API Configuration

This app uses the [News API](https://newsapi.org/) to fetch real-time news data. To use this app with live data:

1. Sign up for a free API key at [newsapi.org](https://newsapi.org/register)
2. Replace the placeholder API key in the code with your own key

Note: The app includes a fallback mechanism with sample data if the API is unavailable or returns an error.

## Code Structure

- `main.dart` - Entry point of the application and core functionality
- `MyApp` - Main application widget with theme configuration
- `LoginPage` - User authentication screen
- `NewsFeedPage` - Displays the list of news articles
- `NewsCard` - Individual news article card widget
- `ArticleWebView` - WebView for reading full articles
- `NewsProvider` - State management for news data using Provider pattern
- `Article` & `Source` - Data models for news content

## Dependencies

- **flutter**: Framework for building native applications
- **provider**: State management
- **http**: Making HTTP requests
- **webview_flutter**: Displaying web content within the app

## Future Enhancements

- User registration functionality
- Save favorite articles
- Offline reading capability
- Customizable news categories
- Share articles with others
- Push notifications for breaking news

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Flutter](https://flutter.dev/) for the amazing framework
- [News API](https://newsapi.org/) for providing the news data
- [Unsplash](https://unsplash.com/) for sample images used in fallback data
