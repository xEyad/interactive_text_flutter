import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/predictionWord.dart';
import 'package:interactive_text/widgets/previewPrediction.dart';

class TextWidget extends StatelessWidget{
  final List<PredictionItem> predictionList;
  final textCtrl = TextEditingController();
  
  TextWidget({this.predictionList = const []});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        textArea(),
        SizedBox(height: 10),
        PreviewPrediction(sentenceCtrl: textCtrl,predictionList: predictionList),
      ],
    );
    
  }

  Widget textArea()
  {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: TextField(        
        maxLines: 5,
        controller: textCtrl,
      ),
    );
  }

}

