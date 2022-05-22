import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/predictionWord.dart';

class PreviewPrediction extends StatefulWidget {
  final List<PredictionItem> predictionList;
  ///Sentence data will be read from that controller
  final TextEditingController sentenceCtrl;
  PreviewPrediction({Key? key, required this.predictionList, required this.sentenceCtrl}) : super(key: key);

  @override
  State<PreviewPrediction> createState() => _PreviewPredictionState();
}

class _PreviewPredictionState extends State<PreviewPrediction> {
  
  List<PredictionItem> get predictionList => widget.predictionList;

  void controllerListener() { 
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.sentenceCtrl.addListener(controllerListener);
  }

  @override
  void dispose() {
    widget.sentenceCtrl.removeListener(controllerListener);
    super.dispose();
  }

  ///if null is returned, then it means no match found
  PredictionItem? getPredictionWordObj(String word)
  {
    for (var item in predictionList) 
    {
      if(item.trigger == word)
      {
        return item;
      }
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return previewWidget();
  }

  Widget previewWidget()
  {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widgetList,
      ),
    );
  }

  List<Widget> get widgetList
  {
    return widget.sentenceCtrl.text.split(' ').map(
      (e)
      {
        final predictionObj =  getPredictionWordObj(e);
        return predictionObj==null ? Text(e+' ') : predictionWord(predictionObj);
      }
    ).toList();
  }

  Widget predictionWord(PredictionItem? predictionObj) => Container(child: PredictionWord(predictionObj!),margin: EdgeInsets.only(right: 10),);
  
}