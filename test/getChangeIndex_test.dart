// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_text/model/util.dart';

void main() {
  group('[Detect string change location]', (){

    test('insertion from nothing', (){
      final changeIdx = Util.getChangeIndex("","s");
      expect(changeIdx, 0);
    });

    test('insertion at middle', (){
      final changeIdx = Util.getChangeIndex("mohsen","mohlsen");
      expect(changeIdx, 3);
    });

    test('insertion at start', (){
      final changeIdx = Util.getChangeIndex("mohlsen","smohlsen");
      expect(changeIdx, 0);
    });

    test('insertion at middle', (){
      final changeIdx = Util.getChangeIndex("smohlsen","smoohlsen");
      expect(changeIdx, 2);
    });

    test('insertion at middle', (){
      final changeIdx = Util.getChangeIndex("smoohlsen","asmoohlsen");
      expect(changeIdx, 0);
    });

    test('insertion at middle', (){
      final changeIdx = Util.getChangeIndex("asmoohlsen","asmmoohlsen");
      expect(changeIdx, 2);
    });

    test('deletion at middle', (){
      final changeIdx = Util.getChangeIndex("asmmoohlsen","asmmoolsen");
      expect(changeIdx, 6);
    });

    test('deletion at end 1', (){
      final changeIdx = Util.getChangeIndex("asmmoolsen","asmmoolse");
      expect(changeIdx, 9);
    });

    test('deletion at start', (){
      final changeIdx = Util.getChangeIndex("asmmoolse","smmoolse");
      expect(changeIdx, 0);
    });

    test('deletion at end 2', (){
      expect(()=>Util.getChangeIndex("hello o","hello"),throwsA(isA<AssertionError>()));
    });
  });
}