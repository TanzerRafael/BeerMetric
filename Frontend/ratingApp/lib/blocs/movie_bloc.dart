import 'package:ratingApp/models/movie_model.dart';
import 'package:ratingApp/resources/repos/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc{
  final _repo = Repository();
  final _moviesFetcher = PublishSubject<MovieModel>();
  final _moviesFetcherFilter = PublishSubject<MovieModel>();//otherwise on the homepage the filtered would be shown

  Observable<MovieModel> get allMovies => _moviesFetcher.stream;

  Observable<MovieModel> get filterMovies => _moviesFetcherFilter.stream;


  fetchAllMovies() async{
    MovieModel moviemodel = await _repo.fetchAllMovies();
    _moviesFetcher.sink.add(moviemodel);
  }


  fetchFilteredMovies(filter) async{
    MovieModel mm = await _repo.fetchAllMoviesFilter(filter);
    _moviesFetcherFilter.sink.add(mm);
  }


  dispose(){
    _moviesFetcher.close();
    _moviesFetcherFilter.close();
  }
}
final moviesBloc = MoviesBloc();//initialize and Pass as parameter