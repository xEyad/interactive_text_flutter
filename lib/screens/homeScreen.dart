// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/predictionMakerField/predictionMakerField.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final textCtrl = TextEditingController();
  final sentencesControllers = <PredictionMakerFieldController>[];
  final predictionList = [
  {
    "trigger" : "cat",
    "suggestions": ["tuna", "mice"]
  },
  {
    "trigger" : "dog",
    "suggestions": ["bones", "carrots"]
  },
  {
    "trigger" : "mouse",
    "suggestions": ["cheese", "apple"]
  }
  ].map((e) => PredictionItem.fromJson(e)).toList();
  final scrollCtrl = ScrollController();
  int nSentencesAdded = 0;
  PredictionMakerFieldController? activeSentenceCtrl;
  
  void onAddSentence(String initialTitle)
  {    
    if(sentencesControllers.isNotEmpty)
    {      
      sentencesControllers.last.toggleTextUpdates();
    }

    sentencesControllers.add(
      PredictionMakerFieldController(predictionList: predictionList,initialTitle: initialTitle,)
    );     
    setActiveSentenceCtrl(sentencesControllers.last);
    nSentencesAdded++;


    Future.delayed(
      Duration(milliseconds: 100),
      () => scrollCtrl.animateTo(scrollCtrl.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.linear),
      );
  }

  void onDeleteSentenceCtrl(PredictionMakerFieldController ctrl)
  {
    if(ctrl == activeSentenceCtrl)
      activeSentenceCtrl = null;

    print('Removed ${ctrl.titleCtrl.text}');
    sentencesControllers.remove(ctrl);

    if(activeSentenceCtrl == null && sentencesControllers.isNotEmpty)
      activeSentenceCtrl = sentencesControllers.last;

    if(activeSentenceCtrl==null && sentencesControllers.isEmpty)
      textCtrl.clear();

    setState(() {});
  }

  void setActiveSentenceCtrl(PredictionMakerFieldController ctrl)
  {
    activeSentenceCtrl?.toggleTextUpdates();
    setState(() {
      activeSentenceCtrl = ctrl;
    });
  }

  Future<void> openGithubSource() async{
    try{
      launchUrl(Uri.parse("https://github.com/xEyad/interactive_text_flutter"));
    }catch(e)
    {
      print('Could not launch url');
    }
  }

  void showInstructions()
  {
    showDialog(context: context, builder: (ctx){
      return AlertDialog(
        title: Text("What is this?"),
        content: Text(
"""Start typing words in the Text area and the preview widget will render all words typed.
however, if it found any of these words: (cat,dog,mouse) it will render them differently cause these words gives you suggestions.
click on the words, to open and pick a suggestion. Add sentence, adds new sentence which is saved indvidually and can be edited later by clicking on it.
Sentences can be deleted or have it's title changed by clicking on it"""),
actions: [FlatButton(onPressed: ()=>Navigator.pop(ctx), child: Text("Ok"))],
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("interactive text"),actions: [
        IconButton(onPressed: showInstructions, icon: Icon(Icons.question_mark),tooltip: "What is this?",),
        IconButton(onPressed: openGithubSource, icon: Image.asset("assets/github.png",color: Colors.white,),tooltip: "Show source in github",)
      ]),      
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            // instructions(),
            // SizedBox(height: 10,),
            textInput(),
            SizedBox(height: 10,),
            addSentenceBtn(),
            SizedBox(height: 10,),
            Expanded(child: sentencesList()),
            SizedBox(height: 10,),
          ],
        )
      ),
    );
  }


  Widget textInput()
  {
    String label = "";
    if(activeSentenceCtrl != null)
    {
      label = "Editing ${activeSentenceCtrl!.titleCtrl.text}";
    }
    return TextField( 
      autocorrect: false,
      enableInteractiveSelection: false,
      readOnly: activeSentenceCtrl==null,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: label
        ),
      maxLines: 5,
      controller: activeSentenceCtrl!=null? activeSentenceCtrl!.textCtrl : textCtrl,
    );
  }

  Widget addSentenceBtn() {
    return Row(
      children: [
        Spacer(),
        ElevatedButton(
          onPressed: ()=>onAddSentence("Variable $nSentencesAdded"), 
          child: Text('Add sentence +'),
          style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.all(20))),
          ),
      ],
    );
  }

  Widget sentencesList()
  {
    return ListView(
      controller: scrollCtrl,
      // reverse: true,
      children: sentencesControllers.map(
        (e) => sentence(e)
      ).toList(),      
    );
  }

  Widget sentence(PredictionMakerFieldController sentenceCtrl)
  {
    return GestureDetector(
      onTap: (){setActiveSentenceCtrl(sentenceCtrl);},
      child: Container(
            key: UniqueKey(),
            margin: EdgeInsets.only(bottom: 10),
            child: PredictionMakerField(
              highlightColor: activeSentenceCtrl==sentenceCtrl?Color(0xFF064789):null,
              controller:sentenceCtrl,
              onDelete: ()=>onDeleteSentenceCtrl(sentenceCtrl))),
    );
  }
}