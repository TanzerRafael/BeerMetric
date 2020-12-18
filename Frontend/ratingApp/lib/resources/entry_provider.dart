import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'package:ratingApp/models/entry_model.dart';

class EntryProvider{

  Future<EntryModel> getAlreadyRated(userid) async{
    print("EntryProvider" + userid);
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Access-Control-Allow-Origin': '*'
    };

    //HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('/getAlreadyRatedEntries/$userid');
    //final res = await callable();
    final res = await http.get('https://us-central1-ratingsvs.cloudfunctions.net/getAlreadyRatedEntries/$userid', headers: headers);
    print("EntryProvider:: AlreadyRated" + res.body);
    String bod = res.body;


    List<dynamic> list = json.decode(bod);
    return EntryModel.fromJson(list);
  }

  Future<EntryModel> getStartsWith(filter) async{
    print("EntryProvider:: startsWith--Filter::" + filter);
    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Access-Control-Allow-Origin': '*'
    };
    final res = await http.get('https://us-central1-ratingsvs.cloudfunctions.net/getEntriesStartsWith/$filter', headers: headers);
    print("EntryProvider:: startsWith--" + res.statusCode.toString());
    print("EntryProvider:: startsWith--" + res.body);
    String bod = res.body;
    List<dynamic> list = json.decode(bod);
    return EntryModel.fromJson(list);
  }

  void updateRating(rating, entryid) async{//refresh homepage
    if(entryid == null){
      entryid = "1GYFohyPN602YHnemz8U";
    }
    final res = await http.put('https://us-central1-ratingsvs.cloudfunctions.net/updateEntryRating/$entryid',
        headers: <String, String>{ 'Content-Type': 'application/json; charset=UTF-8' },
        body: jsonEncode(<String, String>{'overAllRating': rating.toString()}));

    print("EntryProvider:: Update" + res.body);
  }
}