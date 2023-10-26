import 'package:flutter/material.dart';


class DataProvider with ChangeNotifier{

 Map<String,dynamic> _userData={};
 List _evaluations=[];
 List<Map<String,dynamic>> _instructors=[];
 List<Map<String,dynamic>> _courses=[];
 String _studentEvaluate="";

set courses(List<Map<String,dynamic>> data){
  _courses=data;
  notifyListeners();
}
List<Map<String,dynamic>> get courses=>_courses;

set instructors(List<Map<String,dynamic>> data){
  _instructors=data;
  notifyListeners();
}
List<Map<String,dynamic>> get instructors=>_instructors;

set studentEvaluate(String data){
  _studentEvaluate=data;
  notifyListeners();
}
String get studentEvaluate=>_studentEvaluate;

set userData(Map<String,dynamic> data){
  _userData=data;
  notifyListeners();
}
Map<String,dynamic> get userData=>_userData;

set evaluations(data){
  _evaluations=data;
  notifyListeners();
}
List get evaluations => _evaluations;

}