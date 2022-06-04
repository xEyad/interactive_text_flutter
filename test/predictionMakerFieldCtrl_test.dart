// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_text/widgets/predictionMakerField/predictionMakerField.dart';

///-1 means no change
int getChangeIndex(String oldStr, String newStr)
{
  if(newStr.length > oldStr.length) //insertion
  {
    for (var i = oldStr.length-1; i >= 0; i--) 
    {
      final oldChar = oldStr[i];
      final newChar = newStr[i+1];
      final isOldCharShifted = oldChar == newChar;
      if(!isOldCharShifted)      
        return i+1; //change detected

      if(isOldCharShifted && i==0) //this means insertion is the first character
        return 0;
    }
  }
  else if(newStr.length < oldStr.length) //deletion
  {
    for (var i = oldStr.length-1; i >= 0; i--) 
    {      
      if(i==0)
        return 0; //this means that first character is deleted
      final oldChar = oldStr[i];
      final newChar = newStr[i-1];
      final isOldCharShifted = oldChar == newChar;
      if(!isOldCharShifted)      
        return i; //change detected
    }
  }
  else //same
  {
    return -1;
  }

  throw 'Unexpected error!';
}

void main() {
  group('Detect string change location', (){

    test('insertion at middle', (){
      final changeIdx = getChangeIndex("mohsen","mohlsen");
      expect(changeIdx, 3);
    });

    test('insertion at start', (){
      final changeIdx = getChangeIndex("mohlsen","smohlsen");
      expect(changeIdx, 0);
    });

    test('insertion at middle', (){
      final changeIdx = getChangeIndex("smohlsen","smoohlsen");
      expect(changeIdx, 2);
    });

    test('insertion at middle', (){
      final changeIdx = getChangeIndex("smoohlsen","asmoohlsen");
      expect(changeIdx, 0);
    });

    test('insertion at middle', (){
      final changeIdx = getChangeIndex("asmoohlsen","asmmoohlsen");
      expect(changeIdx, 2);
    });

    test('deletion at middle', (){
      final changeIdx = getChangeIndex("asmmoohlsen","asmmoolsen");
      expect(changeIdx, 6);
    });

    test('deletion at end', (){
      final changeIdx = getChangeIndex("asmmoolsen","asmmoolse");
      expect(changeIdx, 9);
    });

    test('deletion at start', (){
      final changeIdx = getChangeIndex("asmmoolse","smmoolse");
      expect(changeIdx, 0);
    });
  });
}
