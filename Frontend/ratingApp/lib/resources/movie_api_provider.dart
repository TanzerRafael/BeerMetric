import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/movie_model.dart';

class MovieApiProvider{
   Client client = Client();
   final _api_key = '4695569ce4efed64003664fb58f4e924';
   
   Future<MovieModel> fetchMovies() async{
     print("started");
     final res = await client.get("http://api.themoviedb.org/3/movie/popular?api_key=$_api_key");
     print(res.body.toString());
     if(res.statusCode == 200){
       return MovieModel.fromJson(json.decode(res.body));
     } else {
       throw Exception('Failed to load');
     }
   }

   Future<MovieModel> fetchMoviesFilter(filter) async{
     print("started");
     final res = await client.get("http://api.themoviedb.org/3/movie/popular?api_key=$_api_key");
     print(res.body.toString());
     if(res.statusCode == 200){
       //return MovieModel.fromJson(json.decode(res.body));
       MovieModel mm = MovieModel.fromJson(json.decode(res.body));
       mm.results.removeWhere((element) => !element.title.startsWith(filter));
       return mm;
     } else {
       throw Exception('Failed to load');
     }
   }


}