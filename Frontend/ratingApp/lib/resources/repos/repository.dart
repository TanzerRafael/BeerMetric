import 'package:ratingApp/models/movie_model.dart';
import 'package:ratingApp/resources/movie_api_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../entry_provider.dart';

class Repository{
  final movieApiProvider = MovieApiProvider();
  final entryProvider = EntryProvider();

  Future<MovieModel> fetchAllMovies() => movieApiProvider.fetchMovies();
  Future<MovieModel> fetchAllMoviesFilter(filter) => movieApiProvider.fetchMoviesFilter(filter);

  Future<MovieModel> updateRatingForMovie() {
    throw Error();
    //api_provider
  }

  fetchAlreadyRated(userid) => entryProvider.getAlreadyRated(userid);
  fetchStartsWith(filter) => entryProvider.getStartsWith(filter);
  updateEntry(rating, entryid) => entryProvider.updateRating(rating, entryid);
}