import 'package:flutter/material.dart';
import 'package:interactive_text/model/concreteWord.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/previewPrediction.dart';

class PredictionMakerField extends StatefulWidget {
  final VoidCallback? onDelete;
  final PredictionMakerFieldController controller;
  final Color? highlightColor;
  PredictionMakerField({Key? key,required this.controller,this.onDelete, this.highlightColor }) : super(key: key);

  @override
  State<PredictionMakerField> createState() => _PredictionMakerFieldState();
}

class _PredictionMakerFieldState extends State<PredictionMakerField> {
  final borderRadiusValue = 10.0;
  PredictionMakerFieldController get controller => widget.controller;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          titleBar(),
          previewArea()
        ]),
    width: double.infinity,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadiusValue),border: Border.all(color: widget.highlightColor??Colors.black)),);
  }

  Widget titleBar()
  {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusValue),topRight: Radius.circular(borderRadiusValue)),
        color: widget.highlightColor??Color(0xFF717C89)
      ),
      child: Row(children: [
        Expanded(child: Center(child: titleField()),),
        deleteBtn()
      ],),
    );
  }

  Widget titleField()
  {
    return TextField(
      decoration: InputDecoration(border: InputBorder.none,),
      controller: controller.titleCtrl,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18,color: Colors.grey[200]),
    );
  }

  Widget deleteBtn()
  {
    return IconButton(onPressed: widget.onDelete, icon: Icon(Icons.delete),color: Colors.grey[200],tooltip: "Delete Item",);
  }

  Widget previewArea()
  {
    return PreviewPrediction(
      predictionList: controller.predictionList, 
      sentenceCtrl: controller.textCtrl,
      onSentenceUpdated: (sentence)=>controller._updateSentence(sentence),
      initialSentence: controller.sentence,
    );   
  }

}


class PredictionMakerFieldController extends ChangeNotifier 
{
  ///Sentence data will be read from that controller
  TextEditingController _textCtrl;
  TextEditingController get textCtrl => _textCtrl;
  final String? initialTitle;
  final List<PredictionItem> predictionList;
  final int id;
  late final TextEditingController titleCtrl;
  List<ConcreteWord> get sentence => _sentence;
  List<ConcreteWord> _sentence = [];
  PredictionMakerFieldController({this.predictionList = const [],required TextEditingController textCtrl, this.initialTitle,  })
  :
  _textCtrl = textCtrl,
  id = DateTime.now().microsecondsSinceEpoch  
  {
    titleCtrl = TextEditingController(text: initialTitle);
  }
  
  PredictionItem predictionItem()
  {
    return PredictionItem(suggestions: [], trigger: titleCtrl.text);
  }

  void _updateSentence(List<ConcreteWord> sentence)
  {
    _sentence = sentence;
  }

  void freezeTextUpdates()
  {
    _textCtrl = TextEditingController(text: _textCtrl.text);
    notifyListeners();
  }

  void updateTextCtrl(TextEditingController newCtrl)
  {
    _textCtrl = newCtrl;
    notifyListeners();
  }

  @override
  bool operator ==(Object other) =>
      other is PredictionMakerFieldController &&
      other.runtimeType == runtimeType &&
      other.id == id;

  @override
  int get hashCode => id;

}