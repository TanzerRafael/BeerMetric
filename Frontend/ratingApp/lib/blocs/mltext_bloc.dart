import 'package:ratingApp/models/entry_model.dart';
import 'package:ratingApp/resources/repos/repository.dart';
import 'package:rxdart/rxdart.dart';

class MlTextBloc{
  final _repo = Repository();
  final _textFetcher = PublishSubject<List<String>>();
  final _selectionlist = PublishSubject<List<bool>>();
  List<String> _foundWords;
  List<bool> _selectedWords;

  Observable<List<String>> get readText => _textFetcher.stream;
  Observable<List<bool>> get selectedWords => _selectionlist.stream;

  fetchTextFromLabel(image) async{
    List<String> words = await _repo.readTextFromImage(image);
    _foundWords = words;
    List<bool> selection = [];
    for(var word in words){
      selection.add(false);
    }
    _selectedWords = selection;
    _selectionlist.sink.add(selection);
    _textFetcher.sink.add(words);
  }

  updateSelected(list) async{
    _selectionlist.sink.add(list);
  }

  List<String> getChosenWords(){
    if(_foundWords == null){
      return null;
    }
    List<String> cw = [];
    for(var i = 0; i<_foundWords.length;i++){
      if(_selectedWords[i]){
        cw.add(_foundWords[i]);
      }
    }
    return cw;
  }

  dispose(){
    _textFetcher.close();
    _selectionlist.close();
  }
}
final mlTextBloc = MlTextBloc();//initialize and Pass as parameter