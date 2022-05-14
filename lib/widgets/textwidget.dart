import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/predictionWord.dart';

class TextWidget extends StatefulWidget {
  final List<PredictionItem> predictionList;
  const TextWidget({ Key? key, this.predictionList = const [] }) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  List<Widget> previewWidgets = [];
  final textCtrl = TextEditingController();
  List<PredictionItem> get predictionList => widget.predictionList;


  @override
  void initState() {
    super.initState();
    textCtrl.addListener(() { 
      setState(() {});
    });
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
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            textArea(),
            SizedBox(height: 10),
            previewWidget(),
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
        // runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widgetList,
      ),
    );
  }

  
  List<Widget> get widgetList
  {
    return textCtrl.text.split(' ').map(
      (e)
      {
        final predictionObj =  getPredictionWordObj(e);
        return predictionObj==null ? Text(e+' ') : predictionWord(predictionObj);
      }
    ).toList();
  }

  Widget predictionWord(PredictionItem? predictionObj) => Container(child: PredictionWord(predictionObj!),margin: EdgeInsets.only(right: 10),);

}




