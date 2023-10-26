import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_services/common_variables.dart';
import '../app_services/provider_services.dart';
import 'evaluation_sub_screens/instructor_evaluation_sub_screen.dart';
import 'evaluation_sub_screens/items_evaluation_sub_screen.dart';

class EvaluationHomeScreen extends StatefulWidget {
  const EvaluationHomeScreen({super.key});

  @override
  State<EvaluationHomeScreen> createState() => _EvaluationHomeScreenState();
}

class _EvaluationHomeScreenState extends State<EvaluationHomeScreen> {
  @override
    Widget build(BuildContext context) {
    DataProvider dataProvider=Provider.of<DataProvider>(context);
    String studentEvaluate=dataProvider.studentEvaluate;
    Size screenSize=MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(studentEvaluate=="item"?"Evaluate item":studentEvaluate=="course"?"Evaluate course":"Evaluate instructor"),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration:const BoxDecoration(
        color: greenColor,
        borderRadius:BorderRadius.only(
          topLeft: Radius.circular(20),topRight: Radius.circular(20)
        ),
        ),
        child: studentEvaluate=="item"? const ItemsEvaluationSubScreen():const InstructorEvaluationSubScreen(),
      ),
    );
  }
 }