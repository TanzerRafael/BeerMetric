import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ratingApp/blocs/entry_bloc.dart';
import 'package:ratingApp/blocs/movie_bloc.dart';
import 'package:ratingApp/locator.dart';
import 'package:ratingApp/models/entry_model.dart';
import 'package:ratingApp/models/movie_model.dart';
import 'package:ratingApp/navigation_service.dart';
import 'package:ratingApp/route_paths.dart' as routes;

class MovieSearch extends SearchDelegate<Result>{

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: theme.bottomAppBarColor,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: (){
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    entryBloc.fetchStartsWith(query);

    return StreamBuilder(
      stream: entryBloc.startsWith,
      builder: (context, AsyncSnapshot<EntryModel> snapshot){
        /*if(!snapshot.hasData) {
          return Container(
            color: Theme.of(context).canvasColor,
            child: Column(
              children: <Widget>[
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          );
        }*/if (!snapshot.hasData || snapshot.data.results.length == 0){
          return Container(
            color: Theme.of(context).canvasColor,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 35, 0, 20),
                    child: Text(
                      "Nothing Found",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).accentColor
                      ),
                    ),
                ),
                Center(
                  child: FlatButton(
                    child: Text(
                        "+ Add Entry",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      locator<NavigationService>().navigateTo(routes.AddItemRoute);
                    },
                    padding: EdgeInsets.all(12),
                    color: Theme.of(context).accentColor,
                  ),
                )
              ],
            ),
          );
        }
        else{
          return Container(
            color: Theme.of(context).canvasColor,
            child: _buildList(snapshot),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  Widget _buildList(AsyncSnapshot<EntryModel> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: snapshot.data.results.length,
      itemBuilder: (context, index) => _buildListItem(snapshot.data.results[index]),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _buildListItem(Entry result) {
    return InkWell(
      onTap: (){
        locator<NavigationService>().navigateTo(routes.RatingRoute, args: result);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Center(
            child: Row(
              children: <Widget>[
                Image.memory(
                    base64.decode(result.image),
                  height: 150,
                  fit: BoxFit.contain,
                ),
                Text(
                  result.name,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            )
          )
      )
    );
  }
}