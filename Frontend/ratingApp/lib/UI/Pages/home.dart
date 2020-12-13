import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ratingApp/blocs/movie_bloc.dart';
import 'package:ratingApp/locator.dart';
import 'package:ratingApp/models/movie_model.dart';
import 'package:ratingApp/navigation_service.dart';
import 'package:ratingApp/ui/pages/movie_search.dart';
import 'package:ratingApp/ui/pages/rating_page.dart';
import 'package:ratingApp/route_paths.dart' as routes;
import 'package:ratingApp/ui/pages/signin.dart';

class Home extends StatelessWidget {
  //Home({Key key, this.title}) : super(key: key);
  //final String title;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    moviesBloc.fetchAllMovies();
    //Text buttonText = Text(_auth.currentUser == null ? 'Sign in' : 'Sign out');
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          snap: true,
          pinned: true,
          title: Text("BeerMetric"),
          actions: <Widget>[
            FlatButton(
            child: Text('Auth'),
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                /*setState(() {
                  _auth.currentUser;
                });*/
                final User user = _auth.currentUser;
                if (user == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                  /*setState(() {
                    buttonText = Text(_auth.currentUser == null ? 'Sign in' : 'Sign out');
                  });*/
                  return;
                }
                await _auth.signOut();
                final String uid = user.uid;
                /*setState(() {
                  buttonText = Text(_auth.currentUser == null ? 'Sign in' : 'Sign out');
                });*/
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
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
          stream: moviesBloc.allMovies,
          builder: (context, AsyncSnapshot<MovieModel> snapshot){
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

  Widget _buildList(AsyncSnapshot<MovieModel> snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index){
            return _buildListItem(snapshot.data.results[index]);
          },
        childCount: snapshot.data.results.length
      ),
    );
  }

  Widget _buildListItem(Result result){
    return GestureDetector(
        onTap: (){
        locator<NavigationService>().navigateTo(routes.RatingRoute, args: result);
      },
      child: Container(
        height: 100,
        color: Colors.white,
        child: Row(
          children: <Widget>[
          Image.network(
          'https://image.tmdb.org/t/p/w185${result.posterPath}',
            height: 150,
            fit: BoxFit.contain,
          ),
          Center(
            child: Text(
            result.title,
            style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
              ),
            ),
          ),
       ]
      )
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