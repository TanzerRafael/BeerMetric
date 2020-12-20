import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ratingApp/blocs/entry_bloc.dart';
import 'package:ratingApp/locator.dart';
import 'package:ratingApp/models/entry_model.dart';
import 'package:ratingApp/navigation_service.dart';

class RatingPage extends StatelessWidget{
  RatingPage({Key key, this.entry}) : super(key: key);
  final Entry entry;
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
                  image: MemoryImage(base64.decode(entry.image)),
                )
              ),
            ),
            Container(
              child: Text(entry.name, style: TextStyle(fontWeight: FontWeight.bold),),
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
                  color: Theme.of(context).accentColor,
                  label: Text("Exit"),
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.check, color: Colors.green,),
                  label: Text("Ok"),
                  onPressed: (){
                    entryBloc.updateRating(entry.id);
                    locator<NavigationService>().goBack();
                  },
                  color: Theme.of(context).accentColor,
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
        initialRating: entry.vote_average,
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
          entryBloc.setRating((rating+entry.vote_average)/2);
        },
    );
  }
}