
import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';

class PredictionWord extends StatefulWidget {
  final PredictionItem predictionObj;
  const PredictionWord(this.predictionObj ,{ Key? key }) : super(key: key);

  @override
  State<PredictionWord> createState() => _PredictionWordState();
}

class _PredictionWordState extends State<PredictionWord> {
  String? selection;
  PredictionItem get predictionObj =>  widget.predictionObj;
  String get species => predictionObj.trigger;
  List <String> get foods => predictionObj.suggestions;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: "Show suggestions",
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
        ],
      ),
    );
  }
}