import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';

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

  Widget predictionWord(predictionObj) => Container(child: PredictionWord(predictionObj),margin: EdgeInsets.only(right: 10),);
  
  ///if null is returned, then it means no match found
  dynamic getPredictionWordObj(String word)
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
    return Scaffold(
      appBar: AppBar(title: Text("interactive text")),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            textArea(),
            SizedBox(height: 10),
            previewWidget(),
          ],
        ),
      ),
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
}





class PredictionWord extends StatefulWidget {
  final Map<String,dynamic> predictionObj;
  const PredictionWord(this.predictionObj ,{ Key? key }) : super(key: key);

  @override
  State<PredictionWord> createState() => _PredictionWordState();
}

class _PredictionWordState extends State<PredictionWord> {
  String? selection;
  get predictionObj =>  widget.predictionObj;
  String get species => predictionObj['species'];
  List <String> get foods => predictionObj['foods'] as List<String>;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: content(),
      itemBuilder: (context)=>foods.map((e) => PopupMenuItem(child:Text(e),value: e,onTap: (){
        setState(() {
          selection = e;
        });
      },)).toList(),
    );
  }

  Widget content() {
    final clr = Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(species,style: TextStyle(color: clr),),
            selection==null ? SizedBox() : Text(selection!,style: TextStyle(color: clr))
          ]),
          // Icon(Icons.arrow_drop_down,color: clr,)
        ],
      ),
    );
  }
}