import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:udomdte/app_screens/hod_screens/course_selection_screen.dart';
import 'package:udomdte/app_services/common_variables.dart';


class ReportedCasesScreen extends StatefulWidget {
  const ReportedCasesScreen({super.key});

  @override
  State<ReportedCasesScreen> createState() => _ReportedCasesScreenState();
}

class _ReportedCasesScreenState extends State<ReportedCasesScreen> {
  bool _isLoading=true;

void conditionalStateSetter(){
  setState(() {
    
  });
 }

  
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1),(){
        setState(() {
          _isLoading=false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        AppBar(
        elevation: 0,
        title: const Text("Reported cases"),
        actions: [
           IconButton(onPressed: (){
            showDataFilterBottomsheet();
           }, icon: const Icon(Icons.filter_list))
        ],
      ),
        Expanded(
          child: Container(
                  //padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration( 
                  color: whiteColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),topRight: Radius.circular(20),
                  )
                ),
            child: _isLoading?const Center(child: CircularProgressIndicator()):
            Column(
              children: [
                Container(padding: const EdgeInsets.symmetric(vertical: 7),child: const Text("1000 evaluations found")),
                Expanded(
                  child: ListView.builder(
                    itemCount: instEvalList.length,
                    padding: const EdgeInsets.only(top:0),
                    itemBuilder: (context,index){
                      var evaluation=instEvalList[index];
                    return GestureDetector(
                      onTap: (){
                       // UserReplyWindows().navigateScreen(context,SpecificInstructorEvaluationListScreen(evaluation));
                      },
                      onLongPress: (){
                        doSomething(evaluation);          
                      },
                      child: AbsorbPointer(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5,right: 5,left: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            boxShadow: [BoxShadow(color: blackColor,blurRadius: 1)]
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person_pin,color: appColor),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                    Expanded(child: Row(children: [Text(evaluation["name"],style: TextStyle(fontWeight: FontWeight.bold,color: appColor),),]),),
                                    Row(children: [Text(evaluation["rank"],style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),const Icon(Icons.circle,color: Colors.green,size: 7,),Text(evaluation["course"],style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),const Icon(Icons.circle,color: Colors.red,size: 7,),Text(evaluation["date"],style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)] 
                                    ),]),Padding(padding:const EdgeInsets.only(top: 5),child: Text(evaluation["description"])),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showDataFilterBottomsheet() {
    String selectedExcellenceLevel="";
     showModalBottomSheet(context: context,
     shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )
     ),
     builder: (context){
        return StatefulBuilder(
          builder: (context,stateSetter) {
            return Padding(
              padding:const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,  
              children: [
              const Center(child: Text("Filter evaluations",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),))       
              ,const SizedBox(height: 10,),
              GestureDetector(
                      onTap: ()async{
                       var result=await Navigator.push(context, PageTransition(child: const InstructorListScreen(), type: PageTransitionType.bottomToTop));
                       if(result != null){
                         setState(() {
                           //_instructorName=result;
                         });
                       }
                      },
                       child: AbsorbPointer(
                         child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: appColor,width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Row(children: [Icon(Icons.school),SizedBox(width: 8,),
                              Text("Course",style: TextStyle(fontWeight: FontWeight.bold),),],)),
                              GestureDetector(
                                onTap: ()async{
                                  var result=await Navigator.push(context, PageTransition(child: const InstructorListScreen(), type: PageTransitionType.bottomToTop) );
                                    if(result != null){
                                      setState(() {
                                        //_instructorName=result;
                                      });
                                 }
                                },
                                child: const AbsorbPointer(child: Icon(Icons.arrow_drop_down)),
                              )
                            ],
                          ),
                         ),
                       ),
                     ),
                     const SizedBox(height: 10,),
                     Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: appColor,width: 1.5),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text("Level of excellence",style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                                children: excellenceLevel.map((e){
                                   return OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: appColor),
                                      backgroundColor: selectedExcellenceLevel==e?Colors.blueGrey:whiteColor),
                                      onPressed: (){
                                      stateSetter(() { 
                                        selectedExcellenceLevel=e;
                                      }); 
                                   }, child: Text(e));
                                }).toList(),
                                ),
                              ),

                            ],
                          ),
                         ),
                          ElevatedButton(onPressed: (){
                              // setState(() {
                              //   instEvalList=[];
                              // });
                              Navigator.pop(context);
                          }, child: const Text("Apply filter"))                 
              ],),
            );
          }
        );
     });
  }

    List actionsToTake=["Report to principle","Delete"];
  
  void doSomething(evaluation) {
    int index=0;
    showModalBottomSheet(
      context: context,
     shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )
     ),
     builder: (context){
        return Padding(
          padding:const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,  
          children: [
            const Center(child: Text("Take action",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),))   
            ,Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: actionsToTake.map((e){
                return OutlinedButton(onPressed: (){
                  Navigator.pop(context);
                },style: OutlinedButton.styleFrom(
                  side: BorderSide(color: appColor)
                  ), child: Text(e));
              }).toList()
            )
          ]));
          }
    );
  } 

}