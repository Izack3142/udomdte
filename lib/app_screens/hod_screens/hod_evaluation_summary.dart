import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../app_services/common_variables.dart';

class HodEvaluationSummaryScreen extends StatefulWidget {
  const HodEvaluationSummaryScreen({super.key});

  @override
  State<HodEvaluationSummaryScreen> createState() => _HodEvaluationSummaryScreenState();
}

class _HodEvaluationSummaryScreenState extends State<HodEvaluationSummaryScreen> {

  //   getItemEvaluations(Map<String,dynamic> filter)async{
  //   setState(() {
  //    _isLoading=true;
  //     instructorEvaluations=[];
  //   });
  //  bool fit=false;
  //  if(filter.isNotEmpty){
  //      fit=true;
  //  }
   
  //  if(dataProvider.evaluations.length>0){
  //    for (var el in dataProvider.evaluations) {       
  //      if(el['for']=="instructor"){
  //         if(dataProvider.userData["lable"] == "hod"){
  //             if(el['departmentId'] == dataProvider.userData["departmentId"]){
  //              instructorEvaluations.add(el);       
  //             }
  //         }else{
  //           instructorEvaluations.add(el);
  //         }
  //      }
  //    }

  //    Future.delayed(Duration(seconds:2),(){
  //        setState(() {
  //          _isLoading=false;
  //         });
  //    });     
  //  }
   
  // }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        AppBar(
        elevation: 0,
        title: const Text("Evaluation summary")
         ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top:13),
             decoration: BoxDecoration( 
              color: whiteColor,
               borderRadius: const BorderRadius.only(
               topLeft: Radius.circular(20),topRight: Radius.circular(20),
                  )
                ),
            child: ListView(
              padding: const EdgeInsets.only(top:0),
              children: [
              Container(
                 margin: const EdgeInsets.only(top: 5,right: 5,left: 5),
                 padding: const EdgeInsets.all(5),
                 decoration: BoxDecoration(
                 color: whiteColor,
                 boxShadow: [BoxShadow(color: blackColor,blurRadius: 1)]
                 ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("All instructor evaluations",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                      Table(
                                  columnWidths: const {0:FractionColumnWidth(0.2),1:FractionColumnWidth(0.2)},
                                  border: TableBorder.all(width: 1.5),
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2
                                      )
                                    ),  
                                    children: const [
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Entry",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Eval_no",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Percent",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     ],   
                                    ),
                                    TableRow(
                                    children: [
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Bad",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("350",),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: getLinearPercentIndicator(0.2308),
                                     ),
                                     ],   
                                    ),
                                    TableRow(
                                    children: [
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Average",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("100",),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: getLinearPercentIndicator(0.077)
                                     ),
                                     ],   
                                    ),
                                    TableRow(
                                    children: [
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Good",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("600",),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: getLinearPercentIndicator(0.4615),
                                     ),
                                     ],   
                                    ),
                                    TableRow(
                                    children: [
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Best",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("230",),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: getLinearPercentIndicator(0.2308),
                                     ),
                                     ],   
                                    ),
                                  const TableRow(
                                    children:[
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Total",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("130",),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("100%"),
                                     ),
                                     ], 
                                    ),
                                  ],
                                ),
                    ],
                  ),
                ),
              Container(
                       margin: const EdgeInsets.only(top: 5,right: 5,left: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        boxShadow: [BoxShadow(color: blackColor,blurRadius: 1)]
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("All instructor evaluations",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                      Table(
                                  columnWidths: const {0:FractionColumnWidth(0.2),1:FractionColumnWidth(0.2)},
                                  border: TableBorder.all(width: 1.5),
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2
                                      )
                                    ),  
                                    children: const [
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Entry",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Eval_no",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Percent",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     ],   
                                    ),
                                    TableRow(
                                    children: [
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Electric facility",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("350",),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: getLinearPercentIndicator(0.2308),
                                     ),
                                     ],   
                                    ),
                                    TableRow(
                                    children: [
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Projector",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("100",),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: getLinearPercentIndicator(0.077)
                                     ),
                                     ],   
                                    ),
                                    TableRow(
                                    children: [
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Window",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("600",),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: getLinearPercentIndicator(0.4615),
                                     ),
                                     ],   
                                    ),
                                    TableRow(
                                    children: [
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Chairs",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     const Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("230",),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.all(4.0),
                                       child: getLinearPercentIndicator(0.2308),
                                      ),
                                     ],   
                                    ),
                                    const TableRow(
                                    children: [
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("Total",style: TextStyle(fontWeight: FontWeight.bold),),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("130",),
                                     ),
                                     Padding(
                                       padding: EdgeInsets.all(4.0),
                                       child: Text("100%"),
                                     ),
                                     ], 
                                    ),
                                  ],
                                ),
                    ],
                  ),
                ),
              
              
              ],
            ),
          ),
        ),
      ],
    );                
           
  }

   getLinearPercentIndicator(double d) {
    return LinearPercentIndicator(
      lineHeight: 15,
      barRadius: const Radius.circular(20),
      animation: true,animationDuration: 1000,
      percent: d,center: Text("${(d*100).toStringAsFixed(2)}%",style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),);
  }
 
}

