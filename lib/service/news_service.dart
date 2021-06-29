import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:stemnews/model/news.dart';

class NewsService{
  static String BASE_URL = "https://newsapi.org/v2/everything?q=";
  getNewsList(String query) async {
    var response = await http.get(Uri.parse(BASE_URL+query+"&apiKey=8fe3da1ef8994caea528de567ad78130"));
    if(response.statusCode==200){
      List<News> newsList;
      var finalResult = json.decode(response.body);
      newsList = (finalResult['articles'] as List).map((i) => News.fromJson(i)).toList();

      return newsList;
    }else{
      log('an error occured');

    }
  }

}