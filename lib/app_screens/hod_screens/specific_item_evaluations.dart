import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:udomdte/app_services/common_variables.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../app_services/provider_services.dart';
import '../../app_services/user_reply_windows_services.dart';

class SpecificItemEvaluationListScreen extends StatefulWidget {
  var evaluation;
  SpecificItemEvaluationListScreen(this.evaluation,{super.key});

  @override
  State<SpecificItemEvaluationListScreen> createState() => _SpecificItemEvaluationListScreenState();
}

class _SpecificItemEvaluationListScreenState extends State<SpecificItemEvaluationListScreen> {
  late DataProvider dataProvider;
  bool _isLoading=true;
  final List _evaluations=[];
  List _evTableRows=[];
  int _solvedCases=0;
  
  getItemEvaluations(){
      setState(() {
        _isLoading=true;
      });
      print(_isLoading);
       for (var el in dataProvider.evaluations) {
         if(el['categoryId']==widget.evaluation["categoryId"] && el['for']=="item"){
            _evaluations.add(el);
         }
       }
       //Calculating solved
        for (var el in _evaluations) {
         if(el['isSolved']==true){
            _solvedCases++;
         }
       }
       _evTableRows=[
        {
          "name":"Solved",
          "number":_solvedCases.toString(),
          "percent":(_solvedCases/_evaluations.length).toStringAsFixed(2)
        },
        {
          "name":"Unsolved",
          "number":(_evaluations.length-_solvedCases).toString(),
          "percent":((_evaluations.length-_solvedCases)/_evaluations.length).toStringAsFixed(2)
        },
       ];  
       //print(_evTableRows);
      Future.delayed(const Duration(seconds:2),(){
         setState(() {
           _isLoading=false;
          });
       });    
       print(_isLoading);
    }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 1),(){
      getItemEvaluations();     
    });
  }
  @override
  Widget build(BuildContext context) {
    dataProvider=Provider.of<DataProvider>(context);
    var evaluation=widget.evaluation;
    final screen=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appColor,
      body: SafeArea(
        child: Column(
          children: [
          Container(
          margin: const EdgeInsets.only(bottom: 5,right: 5,left: 5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [BoxShadow(color: blackColor,blurRadius: 5)]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person_pin,color: appColor),
                  Text("Analysis of ${evaluation["categoryName"]} as of now",overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,color: appColor),),
                ],
              ),
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
                   ],
              ),
                Table(
                columnWidths: const {0:FractionColumnWidth(0.2),1:FractionColumnWidth(0.2)},
                border: TableBorder.all(width: 1.5),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: _evTableRows.map((e){
                  return TableRow(
                  children: [
                   Padding(
                     padding: const EdgeInsets.all(4.0),
                     child: Text(e['name'],style: const TextStyle(fontWeight: FontWeight.bold),),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(4.0),
                     child: Text(e['number'],),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(4.0),
                     child: getLinearPercentIndicator(double.parse(e['percent'].toString())),
                   ),
                   ],   
                  );
                }).toList()
              ),              
            ],
          ),
        )    

          ,Expanded(
            child: Container(
              width: screen.width,
              padding: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),topRight: Radius.circular(25)
                )
              ),
              child: Column(children: [
                Container(padding: const EdgeInsets.only(bottom:10), child: Text("Other evaluations for ${evaluation["categoryName"]}",style: TextStyle(fontWeight: FontWeight.bold,color: appColor,fontSize:16)))
                ,Expanded(child: _isLoading?const Center(child:CircularProgressIndicator()):_evaluations.length==1?const Center(child: Text("No evaluations found!!",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)):ListView.builder(
                itemCount: _evaluations.length,
                itemBuilder: (context,index){
                  var evaluation=_evaluations[index];
                    String date=DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(evaluation['dateUploaded']));
                      var keys=evaluation.keys.toList();
                    List<String> numberedKeys=[];
                    for (var el in keys) {
                      var d=evaluation[el];
                      if(excellenceLevel.contains(d)){
                         numberedKeys.add(el);
                      }
                    }
                      return Container(
                      margin: const EdgeInsets.only(bottom: 5,right: 5,left: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        boxShadow: [BoxShadow(color: blackColor,blurRadius: 1)]
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.category,color: appColor),
                              const SizedBox(height:10),
                              GestureDetector(
                                onTap: (){
                                  if(evaluation['image'] != null){
                                     showImageDialog(evaluation['image']);
                                  }else{
                                     Toast.show("No image attached!!");                     
                                  }
                                  
                                },
                                child: const AbsorbPointer(child: Icon(Icons.image))),
                                Icon(evaluation['isSolved']==true?Icons.done:Icons.dangerous_outlined,color:evaluation['isSolved']==true?greenColor:redColor,size: 15,)
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                   onTap: (){
                                    UserReplyWindows().navigateScreen(context,SpecificItemEvaluationListScreen(evaluation));
                                   },
                                  child: AbsorbPointer(
                                    child: Row(children: [  
                                    Row(children: [Text(evaluation["categoryName"],style: TextStyle(fontWeight: FontWeight.bold,color: appColor),),]),
                                    const Icon(Icons.arrow_right_alt_sharp),Expanded(child: Text(evaluation["location"],overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold))),Text(date,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold))
                                    ]),
                                  ),
                                ),
                                Row(
                                  children: [
                                  Expanded(child: GestureDetector(
                                  onTap: (){
                                    UserReplyWindows().navigateScreen(context,SpecificItemEvaluationListScreen(evaluation));
                                   },  
                                  child: AbsorbPointer(child: Column(
                                    children:[
                                      Row(children: [
                                        const Text("General condition: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text(evaluation[numberedKeys[0]],style: const TextStyle(fontWeight: FontWeight.bold,color: greenColor))
                                      ],),
                                      Text(evaluation['description']),
                                    ] 
                                  ))))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                 
                    })
  )
              ],),  
            ),
          )
        ],),
      ),
    );
  }
  
  getLinearPercentIndicator(double d) {
    return LinearPercentIndicator(
      lineHeight: 15,
      barRadius: const Radius.circular(20),
      animation: true,animationDuration: 1000,
      percent: d,center: Text("${(d*100).toStringAsFixed(2)}%",style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),);
  }
  
  void showImageDialog(String url) {
    showGeneralDialog(context: context,
    barrierLabel: "item image",
    barrierDismissible: true,
    barrierColor:Colors.black87,
    transitionBuilder: (context,anim1,anim2,child){
        Animation<Offset> position=Tween<Offset>(begin: const Offset(-1,0),end: const Offset(0,0)).animate(anim1);
        return SlideTransition(
          position:position,
          child: child, 
        );
     },
     pageBuilder: (context,anim1,anim2){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          contentPadding: const EdgeInsets.all(0),
          content: AspectRatio(
            aspectRatio: 5/3,
            child: Container(
            child: Stack(
               alignment: Alignment.topCenter,
              children: [
              Image.network(url,fit: BoxFit.cover,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                color: whiteColor, child: const Text("Loc: Darasani lrb",style: TextStyle(fontWeight: FontWeight.bold),))
            ]),
            )),
        );
     });
  }    
   
}