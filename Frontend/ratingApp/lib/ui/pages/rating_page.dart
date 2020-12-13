import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ratingApp/blocs/movie_bloc.dart';
import 'package:ratingApp/locator.dart';
import 'package:ratingApp/models/movie_model.dart';
import 'package:ratingApp/navigation_service.dart';

class RatingPage extends StatelessWidget{
  RatingPage({Key key, this.entry}) : super(key: key);
  final Result entry;
  double rating; //Display current overall rating final and ctor init and take inputrating into bloc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate"),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 180,
              height: 180,
              margin: EdgeInsets.fromLTRB(0, 25, 0, 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('https://image.tmdb.org/t/p/w185${entry.posterPath}'),
                )
              ),
            ),
            Container(
              child: Text(entry.title),
              margin: EdgeInsets.fromLTRB(0, 5, 0, 30),
            ),
            Container(
              child: _buildRatingBar(),
              margin: EdgeInsets.fromLTRB(0, 5, 0, 60)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton.icon(
                  icon: Icon(Icons.arrow_back, color: Colors.red,),
                  onPressed: (){
                    locator<NavigationService>().goBack();
                  },
                  color: Theme.of(context).canvasColor,
                  label: Text("Exit"),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.check, color: Colors.green,),
                  label: Text("Ok"),
                  onPressed: (){
                    //moviesBloc.updateRating(rating);
                    locator<NavigationService>().goBack();
                  },
                  color: Theme.of(context).hintColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget _buildRatingBar(){
    return RatingBar.builder(
      glowColor: Colors.grey,
        initialRating: 1,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 6,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.orangeAccent,
        ),
        onRatingUpdate: (rating){
          this.rating = rating;
        },
    );
  }
}