import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreviewScreen extends StatefulWidget{
  String imgPath;

  PreviewScreen({this.imgPath});

  @override
  State<StatefulWidget> createState() => _PreviewScreenState();
}
class _PreviewScreenState extends State<PreviewScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 2,child: Image.file(File(widget.imgPath), fit: BoxFit.cover)),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60,
                color: Colors.black54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back_sharp, color: Colors.white,),
                        onPressed: (){
                          Navigator.pop(context, false);
                        }
                    ),
                    IconButton(
                        icon: Icon(Icons.check_outlined, color: Colors.white,),
                        onPressed: (){
                          Navigator.pop(context, true);
                        }
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<ByteData> getBytes() async{
    Uint8List bytes = File(widget.imgPath).readAsLinesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }

}