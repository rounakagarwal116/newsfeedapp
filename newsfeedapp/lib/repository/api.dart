import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsfeedapp/confidential.dart';
import 'package:newsfeedapp/models/news_model.dart';

class NewsProvider extends ChangeNotifier {
  NewsModel? _newsModel;
  bool _isLoading = false;

  NewsModel? get newsModel => _newsModel;
  bool get isLoading => _isLoading;

  Future<void> fetchNews(String countryCode) async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=$countryCode&apiKey=$newsApiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _newsModel = NewsModel.fromJson(data);
    } else {
      throw Exception('Failed to load news');
    }

    _isLoading = false;
    notifyListeners();
  }
}
