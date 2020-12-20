import 'package:ratingApp/resources/mltext_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../entry_provider.dart';

class Repository{
  final entryProvider = EntryProvider();
  final mlTextProvider = MlTextProvider();


  fetchAlreadyRated(userid) => entryProvider.getAlreadyRated(userid);
  fetchStartsWith(filter) => entryProvider.getStartsWith(filter);
  updateEntry(rating, entryid) => entryProvider.updateRating(rating, entryid);

  readTextFromImage(image) => mlTextProvider.readText(image);
}