import 'package:flutter/material.dart';

class MovieModel{
  int _page;
  int _total_results;
  int _total_pages;
  List<Result> _results = [];

  MovieModel.fromJson(Map<String, dynamic> parsedJson){
    print(parsedJson['results'].length);
    _page = parsedJson['page'];
    _total_results = parsedJson['total_results'];
    _total_pages = parsedJson['total_pages'];
    List<Result> temp = [];
    for(int i = 0; i < parsedJson['results'].length; i++){
      Result result = Result(parsedJson['results'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<Result> get results => _results;

  int get total_pages => _total_pages;

  int get total_results => _total_results;

  int get page => _page;
}

class Result{
  int _id;
  var _vote_average;
  String _title;
  String posterPath;
  String _overview;
  String _release_date;

  Result(result){
    _id = result['id'];
    _vote_average = result['vote_average'];
    _title = result['title'];
    posterPath = result['poster_path'];
    /*for (int i = 0; i < result['genre_ids'].length; i++) {
      _genre_ids.add(result['genre_ids'][i]);
    }*/
    _overview = result['overview'];
    _release_date = result['release_date'];
  }

  String get release_date => _release_date;
  String get overview => _overview;
  String get title => _title;
  double get vote_average => _vote_average;
  int get id => _id;
  String get PosterPath => posterPath;
}