import 'package:ratingApp/models/entry_model.dart';
import 'package:ratingApp/resources/repos/repository.dart';
import 'package:rxdart/rxdart.dart';

class EntryBloc{
  double rating = 1;
  final _repo = Repository();
  final _entriesFetcher = PublishSubject<EntryModel>();
  final _entriesStartWithFetcher = PublishSubject<EntryModel>();

  Observable<EntryModel> get alreadyRated => _entriesFetcher.stream;
  Observable<EntryModel> get startsWith => _entriesStartWithFetcher.stream;

  fetchAlreadyRated(userid) async{
    EntryModel model = await _repo.fetchAlreadyRated(userid);
    _entriesFetcher.sink.add(model);
  }

  fetchStartsWith(filter) async{
    EntryModel model = await _repo.fetchStartsWith(filter);
    _entriesStartWithFetcher.sink.add(model);
    print(model);
  }

  updateRating(entryid) async{
    _repo.updateEntry(this.rating, entryid);
  }

  void setRating(double val) => this.rating = val;

  dispose(){
    _entriesFetcher.close();
    _entriesStartWithFetcher.close();
  }
}
final entryBloc = EntryBloc();//initialize and Pass as parameter