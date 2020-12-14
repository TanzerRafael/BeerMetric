import 'package:flutter/material.dart';

class EntryModel{
  List<Entry> _results = [];

  EntryModel.fromJson(List<dynamic> parsedJson){
    List<Entry> temp = [];
    for(int i = 0; i < parsedJson.length; i++){
      Entry result = Entry(parsedJson[i]["data"], parsedJson[i]["id"]);
      temp.add(result);
    }
    _results = temp;
  }

  List<Entry> get results => _results;
}

class Entry{
  String _id;
  var _overallRating;
  String _name;
  String _img;
  List<String> _userIdRate = [];

  Entry(result, id){
    _id = id;
    _overallRating = result['overAllRating'];
    _name = result['name'];
    _img = result['image'];
    for (int i = 0; i < result['userIdRate'].length; i++) {
      _userIdRate.add(result['userIdRate'][i]);
    }
  }
  String get name => _name;
  double get vote_average => double.parse(_overallRating.toString());
  String get id => _id;
  String get image => _img;
}