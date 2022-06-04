// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: curly_braces_in_flow_control_structures


import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_text/model/predictionItem.dart';
import 'package:interactive_text/widgets/predictionMakerField/predictionMakerField.dart';



void typeText(String text,TextEditingController ctrl)
{
  for (var i = 0; i < text.length; i++) {
    ctrl.text += text[i];
  }
}

void removeChar(TextEditingController ctrl,int indexToRemove)
{
  var txt = ctrl.text;
  var firstPart = txt.substring(0,indexToRemove);
  var lastPart = "";
  if(indexToRemove<=txt.length)
    lastPart = txt.substring(indexToRemove+1);

  ctrl.text = firstPart + lastPart;
}

void removeText(TextEditingController ctrl,List<int> indicesToRemove)
{
  for (var i = 0; i < indicesToRemove.length; i++) {
    final indexToRemove = indicesToRemove[i];
    var firstPart = ctrl.text.substring(0,indexToRemove);
    var lastPart = "";
    if(indexToRemove<=ctrl.text.length)
      lastPart = ctrl.text.substring(indexToRemove+1);

    ctrl.text = firstPart + lastPart;

    //update indicies numbers
    for (var idx = i+1; idx < indicesToRemove.length; idx++) {
      final futureIdxToRemove = indicesToRemove[idx];
      if(futureIdxToRemove > indexToRemove)
        indicesToRemove[idx]--; 
    }
  }
  
}

void insertText(TextEditingController ctrl,int location,String text)
{
  assert(location<ctrl.text.length);
  var txt = ctrl.text;
  var firstPart = txt.substring(0,location);
  var lastPart = "";
  if(location<=txt.length)
    lastPart = txt.substring(location);
  
  var textBuildUp = "";
  for (var i = 0; i < text.length; i++) {
    textBuildUp += text[i];
    ctrl.text = firstPart + textBuildUp + lastPart;
  }
}

  /*
  test cases:
  add to end
  remove from end
  add (space) to start
  add item to staret
  remove space from center
  remove item from center
    */
void main() {
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
  
   group('[predictionMakerFieldController]',(){
    test('detect No words after typing', ()  {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      typeText("sayed hanfy",ctrl.textCtrl);  
      expect(ctrl.sentence.length,0);
    });

    test('detect 1 word after typing', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      typeText("sayed cat hanfy",ctrl.textCtrl,);  
      expect(ctrl.sentence.length,1,);
      expect(ctrl.sentence[0].startIndex,6);
      expect(ctrl.sentence[0].text,"cat");
    });

    test('detect 2 words after typing', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      typeText("sayed cat hanfy dog",ctrl.textCtrl,);  
      expect(ctrl.sentence.length,2,);
      expect(ctrl.sentence[0].startIndex,6);
      expect(ctrl.sentence[1].startIndex,16);
      expect(ctrl.sentence[0].text,"cat");
      expect(ctrl.sentence[1].text,"dog");
    });

    test('detect 2 words consecutive after typing', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      typeText("sayed cat cat hanfy dog",ctrl.textCtrl,);  
      expect(ctrl.sentence.length,3,);
      expect(ctrl.sentence[0].startIndex,6);
      expect(ctrl.sentence[1].startIndex,10);
      expect(ctrl.sentence[2].startIndex,20);
      expect(ctrl.sentence[0].text,"cat");
      expect(ctrl.sentence[1].text,"cat");
      expect(ctrl.sentence[2].text,"dog");
    });

    test('detect 3 words consecutive after typing', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      typeText("sayed cat cat dog hanfy dog",ctrl.textCtrl,);  
      expect(ctrl.sentence.length,4,);
      expect(ctrl.sentence[0].startIndex,6);
      expect(ctrl.sentence[1].startIndex,10);
      expect(ctrl.sentence[2].startIndex,14);
      expect(ctrl.sentence[3].startIndex,24);
      expect(ctrl.sentence[0].text,"cat");
      expect(ctrl.sentence[1].text,"cat");
      expect(ctrl.sentence[2].text,"dog");
      expect(ctrl.sentence[3].text,"dog");
    });

    test('detect 3 words consecutive after removing', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      ctrl.textCtrl.text = "sayed cat cat dog hanfy dog";
      removeChar(ctrl.textCtrl,26);  //"sayed cat cat dog hanfy do"
      expect(ctrl.sentence.length,3,);
      expect(ctrl.sentence[0].startIndex,6);
      expect(ctrl.sentence[1].startIndex,10);
      expect(ctrl.sentence[2].startIndex,14);
      expect(ctrl.sentence[0].text,"cat");
      expect(ctrl.sentence[1].text,"cat");
      expect(ctrl.sentence[2].text,"dog");
    });

    test('detect 2 words consecutive after removing', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      ctrl.textCtrl.text = "sayed cat cat dog hanfy dog";
      removeChar(ctrl.textCtrl,26);  //"sayed cat cat dog hanfy do"
      removeChar(ctrl.textCtrl,15);  //"sayed cat cat dg hanfy do"
      expect(ctrl.sentence.length,2,);
      expect(ctrl.sentence[0].startIndex,6);
      expect(ctrl.sentence[1].startIndex,10);
      expect(ctrl.sentence[0].text,"cat");
      expect(ctrl.sentence[1].text,"cat");
    });

    test('detect 1 word after adding and removing 3 other', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      ctrl.textCtrl.text = "sayed cat cat dog hanfy dog";
      removeChar(ctrl.textCtrl,26);       //"sayed cat cat dog hanfy do"
      removeChar(ctrl.textCtrl,15);       //"sayed cat cat dg hanfy do"
      removeChar(ctrl.textCtrl,6);        //"sayed at cat dg hanfy do"
      insertText(ctrl.textCtrl,8,'f');    //"sayed atf cat dg hanfy do"
      expect(ctrl.sentence.length,1,);
      expect(ctrl.sentence[0].startIndex,10);
      expect(ctrl.sentence[0].text,"cat");
    });

    test('detect 2 words after adding and removing others', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      ctrl.textCtrl.text = "sayed cat cat dog hanfy dog";
      removeChar(ctrl.textCtrl,26);       //"sayed cat cat dog hanfy do"
      removeChar(ctrl.textCtrl,15);       //"sayed cat cat dg hanfy do"
      removeChar(ctrl.textCtrl,6);        //"sayed at cat dg hanfy do"
      insertText(ctrl.textCtrl,8,'f');    //"sayed atf cat dg hanfy do"
      removeChar(ctrl.textCtrl,8);        //"sayed at cat dg hanfy do"
      removeChar(ctrl.textCtrl,7);        //"sayed a cat dg hanfy do"
      removeChar(ctrl.textCtrl,6);        //"sayed  cat dg hanfy do"
      removeChar(ctrl.textCtrl,6);        //"sayed cat dg hanfy do"
      insertText(ctrl.textCtrl,11,'o');   //"sayed cat dog hanfy do"
      expect(ctrl.sentence.length,2,);
      expect(ctrl.sentence[0].startIndex,6);
      expect(ctrl.sentence[1].startIndex,10);
      expect(ctrl.sentence[0].text,"cat");
      expect(ctrl.sentence[1].text,"dog");
    });

    test('perfect match 3 words after manipulation', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      ctrl.textCtrl.text = "Sayed cat cat wird happy dog";
      removeText(ctrl.textCtrl,[12,11,10]);          // "Sayed cat wird happy dog"
      insertText(ctrl.textCtrl,10,'cat');             // "Sayed cat cat wird happy dog"
      expect(ctrl.sentence.length,3,);
      expect(ctrl.sentence[0].startIndex,6);
      expect(ctrl.sentence[1].startIndex,10);
      expect(ctrl.sentence[2].startIndex,25);
      expect(ctrl.sentence[0].text,"cat");
      expect(ctrl.sentence[1].text,"cat");
      expect(ctrl.sentence[2].text,"dog");
    });

    test('perfect match 1 word after removing space from end', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      ctrl.textCtrl.text = "Sayed cat cat ";
      removeText(ctrl.textCtrl,[12,11,10]);          // "Sayed cat  "      
      expect(ctrl.sentence.length,1,);
      expect(ctrl.sentence[0].startIndex,6);
      expect(ctrl.sentence[0].text,"cat");
    });

     test('perfect match 2 words after manipulation and alot of trimmed spaces', () {
      final ctrl = PredictionMakerFieldController(initialTitle: "",predictionList: predictionList);      
      ctrl.textCtrl.text = "Sayed cat cat ";
      removeText(ctrl.textCtrl,[12,11,10]);          // "Sayed cat  "      
      insertText(ctrl.textCtrl, 10, "dog");           // "Sayed cat dog "
      expect(ctrl.sentence.length,2,);
      expect(ctrl.sentence[0].startIndex,6);
      expect(ctrl.sentence[0].text,"cat");
      expect(ctrl.sentence[1].startIndex,10);
      expect(ctrl.sentence[1].text,"dog");
    });

  });
}