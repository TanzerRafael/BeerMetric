import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ratingApp/blocs/entry_bloc.dart';
import 'package:ratingApp/blocs/movie_bloc.dart';
import 'package:ratingApp/locator.dart';
import 'package:ratingApp/models/entry_model.dart';
import 'package:ratingApp/models/movie_model.dart';
import 'package:ratingApp/navigation_service.dart';
import 'package:ratingApp/ui/pages/movie_search.dart';
import 'package:ratingApp/ui/pages/rating_page.dart';
import 'package:ratingApp/route_paths.dart' as routes;

class Home extends StatelessWidget {
  //Home({Key key, this.title}) : super(key: key);
  //final String title;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    entryBloc.fetchAlreadyRated(_auth.currentUser.uid);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          snap: true,
          pinned: true,
          title: Text("BeerMetric"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () async {
                await _auth.signOut();
                final User user = _auth.currentUser;
                if (user == null) {
                  locator<NavigationService>().navigateTo(routes.SignInRoute);
                  return;
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                showSearch(
                    context: context,
                    delegate: MovieSearch()
                );
              },
            )
          ],
        ),
        StreamBuilder(
          stream: entryBloc.alreadyRated,
          builder: (context, AsyncSnapshot<EntryModel> snapshot){
              if(snapshot.hasData) {
                return _buildList(snapshot);
              }
              else if(snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 750,
                    child: Center(
                      child: Text(snapshot.error.toString()),
                    ),
                  ),
                );
              }
              else{
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 750,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
            },
        )
      ],
    );
  }

  Widget _buildList(AsyncSnapshot<EntryModel> snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index){
            return _buildListItem(snapshot.data.results[index]);
          },
        childCount: snapshot.data.results.length
      ),
    );
  }

  Widget _buildListItem(Entry result){
    return GestureDetector(
        onTap: (){
        locator<NavigationService>().navigateTo(routes.RatingRoute, args: result);
      },
      child: Material(
        color: ThemeData.dark().dividerColor,
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 1.0),
            height: 100,
            color: ThemeData.dark().canvasColor,
            child: Row(
                children: <Widget>[
                  Image.memory(
                    //Uri.parse(result.image).data.contentAsBytes(),
                    base64.decode(result.image),
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  Expanded(
                    child:
                    Text(
                      '  ${result.name}',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 4.0, right: 10.0),
                    child: Text(
                      '${result.vote_average}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ]
            )
        ),
      )
    );
  }

  /*Widget _buildList(AsyncSnapshot<MovieModel> snapshot) {
    return SliverList.builder(
        itemCount: snapshot.data.results.length,
        itemBuilder: (context, index) => _buildListItem(snapshot.data.results[index])
    );
  }*/

  /*Widget _buildListItem(Result result){
    return Text(result.original_title,
                style: TextStyle(fontSize: 20),);
  }*/
}