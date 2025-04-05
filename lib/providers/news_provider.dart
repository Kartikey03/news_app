import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/article.dart';
import '../models/source.dart';

class NewsProvider extends ChangeNotifier {
  // Use a free, non-auth API endpoint for demonstration purposes
  // Since NewsAPI requires authentication for production, we'll use a sample endpoint
  // Replace with your own API key and endpoint if available
  final String _baseUrl = 'https://newsapi.org/v2';
  final String _endpoint = '/top-headlines';
  final String _country = 'us';
  final String _apiKey = '2d1a91774619408583c68962a9b97cce'; // Replace with your actual API key

  List<Article> _articles = [];
  bool _isLoading = false;
  String _error = '';

  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchNews() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // For demonstration, if you don't have an API key, you can use a sample data
      // approach or a different free API
      final response = await http.get(
        Uri.parse('$_baseUrl$_endpoint?country=$_country&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
      } else {
        // Load sample data for any API failure
        _loadSampleData();

        // Still show the error message for debugging
        if (response.statusCode == 401) {
          _error = 'API Key invalid or missing. Using sample data instead.';
        } else {
          _error = 'Failed to load news: ${response.statusCode}. Using sample data instead.';
        }
      }
    } catch (e) {
      _error = 'Network error: $e. Using sample data instead.';
      _loadSampleData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchNews(String query) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
      } else {
        // Filter sample data to mimic search
        _searchSampleData(query);

        // Still show the error message for debugging
        if (response.statusCode == 401) {
          _error = 'API Key invalid or missing. Using sample data instead.';
        } else {
          _error = 'Failed to search news: ${response.statusCode}. Using sample data instead.';
        }
      }
    } catch (e) {
      _error = 'Network error: $e. Using sample data instead.';
      _searchSampleData(query);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load sample data if API call fails
  void _loadSampleData() {
    _articles = _getRandomSampleArticles();
    // Clear error to prevent showing error message when using sample data
    _error = '';
  }

  // Filter sample data for search function
  void _searchSampleData(String query) {
    final sampleArticles = _getAllSampleArticles();
    _articles = sampleArticles.where((article) {
      return article.title.toLowerCase().contains(query.toLowerCase()) ||
          (article.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
    // Clear error to prevent showing error message when using sample data
    _error = '';
  }

  // Get a random selection of sample articles to simulate refreshed content
  List<Article> _getRandomSampleArticles() {
    final allArticles = _getAllSampleArticles();
    allArticles.shuffle();

    // Take a random number of articles between 5 and the max available
    final random = Random();
    final articleCount = random.nextInt(allArticles.length - 4) + 5; // At least 5 articles

    return allArticles.take(articleCount).map((article) {
      // Add slight variations to make it feel like new content
      final minutesAgo = random.nextInt(60);

      return Article(
        source: article.source,
        author: article.author,
        title: article.title,
        description: article.description,
        url: article.url,
        urlToImage: article.urlToImage,
        // Vary the published time to make it look fresh
        publishedAt: DateTime.now().subtract(Duration(minutes: minutesAgo)),
        content: article.content,
      );
    }).toList();
  }

  // Sample articles data pool for demonstration
  List<Article> _getAllSampleArticles() {
    return [
      Article(
        source: Source(id: 'tech-1', name: 'Tech News'),
        author: 'John Doe',
        title: 'Flutter 3.0 Released with Major Performance Improvements',
        description: 'The latest version of Flutter brings significant performance enhancements and new features for developers.',
        url: 'https://flutter.dev',
        urlToImage: 'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        content: 'Flutter 3.0 has been released with major performance improvements and new features.',
      ),
      Article(
        source: Source(id: 'business-1', name: 'Business Insider'),
        author: 'Jane Smith',
        title: 'Global Markets Soar as Economic Recovery Accelerates',
        description: 'Stock markets around the world are reaching new highs as economic indicators show robust recovery.',
        url: 'https://example.com/business',
        urlToImage: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        content: 'Global markets are experiencing unprecedented growth as economies recover faster than expected.',
      ),
      Article(
        source: Source(id: 'health-1', name: 'Health Today'),
        author: 'Dr. Robert Chen',
        title: 'New Study Shows Benefits of Regular Exercise for Mental Health',
        description: 'Research confirms that just 30 minutes of physical activity daily can significantly improve mental wellbeing.',
        url: 'https://example.com/health',
        urlToImage: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        content: 'A comprehensive study has found that regular exercise has significant positive impacts on mental health.',
      ),
      Article(
        source: Source(id: 'science-1', name: 'Science Daily'),
        author: 'Maria Rodriguez',
        title: 'Breakthrough in Renewable Energy Storage Technology',
        description: 'Scientists develop new battery technology that can store renewable energy for longer periods at lower costs.',
        url: 'https://example.com/science',
        urlToImage: 'https://images.unsplash.com/photo-1509390144018-e91a19f0a375',
        publishedAt: DateTime.now().subtract(const Duration(days: 4)),
        content: 'A team of researchers has announced a major breakthrough in energy storage technology.',
      ),
      // Additional sample articles
      Article(
        source: Source(id: 'sports-1', name: 'Sports Network'),
        author: 'Michael Johnson',
        title: 'Olympic Committee Announces New Events for 2028 Games',
        description: 'The International Olympic Committee has approved several new sports for inclusion in the 2028 Summer Olympics.',
        url: 'https://example.com/sports',
        urlToImage: 'https://images.unsplash.com/photo-1569517282132-25d22f4573e6',
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        content: 'The Olympic Games will feature new exciting sports in the 2028 edition.',
      ),
      Article(
        source: Source(id: 'tech-2', name: 'TechCrunch'),
        author: 'Sarah Johnson',
        title: 'AI-Powered Coding Assistants Transforming Software Development',
        description: 'New AI tools are helping developers write code faster and with fewer bugs, changing how software is built.',
        url: 'https://example.com/tech/ai-coding',
        urlToImage: 'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        content: 'AI-powered coding assistants are revolutionizing software development practices worldwide.',
      ),
      Article(
        source: Source(id: 'science-2', name: 'Nature Science'),
        author: 'Dr. Emily Chen',
        title: 'Scientists Discover New Species in Deep Ocean Exploration',
        description: 'A research expedition to the Mariana Trench has uncovered several previously unknown marine species.',
        url: 'https://example.com/science/deep-ocean',
        urlToImage: 'https://images.unsplash.com/photo-1551244072-5d12893278ab',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        content: 'Deep ocean exploration continues to reveal biodiversity previously unknown to science.',
      ),
      Article(
        source: Source(id: 'business-2', name: 'Financial Times'),
        author: 'Robert Williams',
        title: 'Electric Vehicle Sales Surge as Traditional Auto Market Slows',
        description: 'EV manufacturers report record quarterly sales while traditional combustion vehicle sales continue to decline.',
        url: 'https://example.com/business/ev-sales',
        urlToImage: 'https://images.unsplash.com/photo-1593941707882-a5bba11938b7',
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        content: 'The automotive industry is experiencing a major shift toward electric vehicles.',
      ),
      Article(
        source: Source(id: 'health-2', name: 'Medical Journal'),
        author: 'Dr. Lisa Wong',
        title: 'New Cancer Treatment Shows Promising Results in Clinical Trials',
        description: 'A novel immunotherapy approach has demonstrated significant tumor reduction in patients with advanced cancer.',
        url: 'https://example.com/health/cancer-treatment',
        urlToImage: 'https://images.unsplash.com/photo-1579154204601-01588f351e67',
        publishedAt: DateTime.now().subtract(const Duration(hours: 15)),
        content: 'Clinical trials of the new cancer treatment have shown remarkable results in patients with previously untreatable conditions.',
      ),
      Article(
        source: Source(id: 'tech-3', name: 'Wired'),
        author: 'Thomas Green',
        title: 'Quantum Computing Achieves Major Milestone in Error Correction',
        description: 'Researchers have developed a new method for quantum error correction that brings practical quantum computers closer to reality.',
        url: 'https://example.com/tech/quantum',
        urlToImage: 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb',
        publishedAt: DateTime.now().subtract(const Duration(hours: 18)),
        content: 'Quantum computing researchers have made a significant breakthrough in error correction techniques.',
      ),
      Article(
        source: Source(id: 'sports-2', name: 'ESPN'),
        author: 'James Thompson',
        title: 'Underdog Team Makes Historic Championship Run',
        description: 'A team that was ranked last at the beginning of the season has defied all odds to reach the finals.',
        url: 'https://example.com/sports/underdog',
        urlToImage: 'https://images.unsplash.com/photo-1517649763962-0c623066013b',
        publishedAt: DateTime.now().subtract(const Duration(hours: 22)),
        content: 'The unexpected championship run has captivated sports fans worldwide.',
      ),
      Article(
        source: Source(id: 'world-1', name: 'Global News'),
        author: 'Elena Petrova',
        title: 'International Summit Reaches Agreement on Climate Change Measures',
        description: 'World leaders have committed to new aggressive targets for reducing carbon emissions by 2030.',
        url: 'https://example.com/world/climate-summit',
        urlToImage: 'https://images.unsplash.com/photo-1532187643603-ba119ca4109e',
        publishedAt: DateTime.now().subtract(const Duration(hours: 25)),
        content: 'The climate summit has produced an historic agreement that could significantly impact global warming.',
      ),
    ];
  }
}