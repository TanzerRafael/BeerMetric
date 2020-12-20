import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ratingApp/blocs/entry_bloc.dart';
import 'package:ratingApp/blocs/mltext_bloc.dart';
import 'package:ratingApp/locator.dart';
import 'package:ratingApp/navigation_service.dart';

class ChooseName extends StatelessWidget{
  ChooseName({Key key, this.img}) : super(key : key);
  final File img;

  final List<String> entries = <String>['A', 'B', 'C','A', 'B', 'C'];
  final List<bool> isSelected = [true, false, false, true, false, false];

  @override
  Widget build(BuildContext context) {
    mlTextBloc.fetchTextFromLabel(img);
    return Material(
      child: StreamBuilder(
          stream: mlTextBloc.readText,
          builder: (context, AsyncSnapshot<List<String>> snapshot){
            return StreamBuilder(
              stream: mlTextBloc.selectedWords,
              builder: (context, AsyncSnapshot<List<bool>> snapshot2){
                if(snapshot.hasData){
                  return _buildSelect(snapshot, snapshot2);
                }else if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                }else{
                  return Center( child: CircularProgressIndicator(),);
                }
            },
            );
          }
      ),
    );
  }

  Widget _buildSelect(AsyncSnapshot<List<String>> snapshot, AsyncSnapshot<List<bool>> snapshot2) {
    return Container(
      color: Colors.black12.withOpacity(0.2),
      padding: EdgeInsets.symmetric(vertical: 150, horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Assamble Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    color: snapshot2.data[index] ? Colors.lightGreen : null,
                    child: ListTile(
                      title: Center( child: Text('${snapshot.data[index]}')),
                      subtitle: Text(""),
                      selected: snapshot2.data[index],
                      onTap: () {
                        snapshot2.data[index] = !snapshot2.data[index];
                        mlTextBloc.updateSelected(snapshot2.data);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          FlatButton(
            height: 50,
            child: Text('Save'),
            color: Colors.green,
            onPressed: () {
              locator<NavigationService>().goBack();
            },
          ),
        ],
      ),
    );
  }
}