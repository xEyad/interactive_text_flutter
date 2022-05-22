import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/previewPrediction.dart';

class PredictionMakerField extends StatefulWidget {
  final VoidCallback? onDelete;
  final PredictionMakerFieldController controller;
  PredictionMakerField({Key? key,required this.controller,this.onDelete }) : super(key: key);

  @override
  State<PredictionMakerField> createState() => _PredictionMakerFieldState();
}

class _PredictionMakerFieldState extends State<PredictionMakerField> {
  final borderRadiusValue = 10.0;
  PredictionMakerFieldController get controller => widget.controller;

  void controllerListener() { 
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(controllerListener);
  }

  @override
  void dispose() {
    controller.removeListener(controllerListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [
      titleBar(),
      previewArea()
    ]),
    width: double.infinity,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadiusValue),border: Border.all()),);
  }

  Widget titleBar()
  {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadiusValue),topRight: Radius.circular(borderRadiusValue)),
        color: Color(0xFF717C89)
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
    return PreviewPrediction(predictionList: controller.predictionList, sentenceCtrl: controller.textCtrl ,);   
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
  late final titleCtrl;
  List<Map<PredictionItem,String>> itemsAndSelections = [];
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

  ///Non reversible
  void freezeTextUpdates()
  {
    _textCtrl = TextEditingController(text: _textCtrl.text);
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