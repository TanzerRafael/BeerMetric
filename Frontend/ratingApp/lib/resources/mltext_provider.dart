import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class MlTextProvider{

  Future<List<String>> readText(File image) async{
    List<String> foundWords = [];

    try{
      FirebaseVisionImage img = FirebaseVisionImage.fromFile(image);
      TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
      VisionText readText = await recognizer.processImage(img);
      for (TextBlock block in readText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement word in line.elements) {
            foundWords.add(word.text);
          }
        }
      }
    } catch(error){
        print('MlTextProvider - Error $error');
    }

    print("MlText-Provider:: Words--" + foundWords.toString());
    return foundWords;
  }
}