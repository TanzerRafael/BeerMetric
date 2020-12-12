import 'package:ratingApp/models/movie_model.dart';
import 'package:ratingApp/resources/movie_api_provider.dart';
import 'package:rxdart/rxdart.dart';

class Repository{
  final movieApiProvider = MovieApiProvider();

  Future<MovieModel> fetchAllMovies() => movieApiProvider.fetchMovies();
  Future<MovieModel> fetchAllMoviesFilter(filter) => movieApiProvider.fetchMoviesFilter(filter);

  Future<MovieModel> updateRatingForMovie() {
    throw Error();
    //api_provider
  }
}