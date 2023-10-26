import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:udomdte/app_screens/hod_screens/specific_item_evaluations.dart';
import 'package:intl/intl.dart';
import 'package:udomdte/app_screens/items_list_screen.dart';
import 'package:toast/toast.dart';
import 'package:udomdte/app_services/database_services.dart';
import '../../app_services/common_variables.dart';
import '../../app_services/provider_services.dart';
import '../../app_services/user_reply_windows_services.dart';

class ItemEvaluationListScreen extends StatefulWidget {
  const ItemEvaluationListScreen({super.key});

  @override
  State<ItemEvaluationListScreen> createState() => _ItemEvaluationListScreenState();
}

class _ItemEvaluationListScreenState extends State<ItemEvaluationListScreen> {
  late DataProvider dataProvider;
  bool _isLoading=true;
  List itemEvaluations=[]; 

  getItemEvaluations(Map<String,dynamic> filter)async{
    setState(() {
     _isLoading=true;
      itemEvaluations=[];
    });
   bool fit=false;
   if(filter.isNotEmpty){
       fit=true;
   }
   
   if(dataProvider.evaluations.isNotEmpty){
     for (var el in dataProvider.evaluations) {       
       if(el['for']=="item"){
          if(fit==true){
            if(filter['categoryId'] != null && filter['isSolved'] != null){
              print("all");
              if(filter['categoryId'] == el["categoryId"] && filter['isSolved'] == el["isSolved"]){
                 print("fit all");
                 itemEvaluations.add(el);    
              }

            }else{
              if(filter['categoryId'] == el["categoryId"] || filter['isSolved'] == el["isSolved"]){
                  itemEvaluations.add(el);
                  print("fit one ${el['categoryId']} ${filter['isSolved']}");
              }
            }    
          }else{
              itemEvaluations.add(el);
          }
       }
     }

     Future.delayed(const Duration(seconds:2),(){
         setState(() {
           _isLoading=false;
          });
     });     
   }
   
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero,(){
       getItemEvaluations({});
    });
    
    Future.delayed(const Duration(seconds: 4),(){
        setState(() {
          _isLoading=false;
        });
    });
  }
 
  @override
  Widget build(BuildContext context) {
    dataProvider=Provider.of<DataProvider>(context);

     return Column(
       children: [
        AppBar(
        elevation: 0,
        title: const Text("Items evaluations"),
         actions: [
          IconButton(onPressed: (){
            getItemEvaluations({});
          }, icon: const Icon(Icons.refresh)),
           IconButton(onPressed: (){
            showDataFilterBottomsheet();
           }, icon: const Icon(Icons.filter_list))
         ],
         ),
        Expanded(
           child: Container(
              decoration: BoxDecoration( 
              color: whiteColor,
               borderRadius: const BorderRadius.only(
               topLeft: Radius.circular(20),topRight: Radius.circular(20),
                  )
                ),
              child: Column(
                children: [
                  Container(padding: const EdgeInsets.symmetric(vertical: 7),child: Text("${itemEvaluations.length} evaluations found")),
                  Expanded(
                    child:_isLoading?const Center(child:CircularProgressIndicator()):itemEvaluations.isEmpty?const Center(child: Text("No evaluations found!!",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)):ListView.builder(
                    itemCount: itemEvaluations.length,
                    padding: const EdgeInsets.only(top:0), 
                    itemBuilder: (context,index){
                    Map<dynamic,dynamic> evaluation=itemEvaluations[index];
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
                                  )))),
                                  IconButton(onPressed: (){
                                      doSomething(evaluation);
                                  }, icon:const Icon(Icons.keyboard_double_arrow_up ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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

    String selectedProblemStatus="";
    Map<String,dynamic> selectedCategory={};
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
                       var result=await Navigator.push(context, PageTransition(child:const ItemsListScreen(), type: PageTransitionType.bottomToTop));
                       if(result != null){
                         stateSetter((){
                           selectedCategory=result;
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
                              const Icon(Icons.category),const SizedBox(width: 8,),
                              Expanded(child: Text(selectedCategory.isEmpty?"Category":selectedCategory['name'].toString(),overflow: TextOverflow.ellipsis,style: const TextStyle(fontWeight: FontWeight.bold),)),
                              GestureDetector(
                                onTap: ()async{
                                  var result=await Navigator.push(context, PageTransition(child: const ItemsListScreen(), type: PageTransitionType.bottomToTop) );
                                    if(result != null){
                                      stateSetter(() {
                                        selectedCategory=result;
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
                              const Text("Problem status",style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,  
                                children: problemStatus.map((e){
                                  Widget button=SizedBox(
                                    height:40,
                                    child: OutlinedButton(
                                            key: ValueKey(e),
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: appColor),
                                              backgroundColor: selectedProblemStatus==e?Colors.blueGrey:whiteColor),
                                              onPressed: (){
                                              stateSetter((){
                                                selectedProblemStatus=e;
                                              }); 
                                           }, child: Text(e)),
                                  );
                                   return Expanded(
                                     child: e!="Solved"?Row(
                                       children: [
                                        const SizedBox(width: 5,),
                                        Expanded(child: button)   
                                       ],
                                     ):button,
                                   );
                                }).toList(),
                                ),
                              ),

                            ],
                          ),
                         ),
                          ElevatedButton(onPressed: (){
                              if(selectedCategory.isNotEmpty || selectedProblemStatus.isNotEmpty){
                                var filter={
                                  "categoryId":selectedCategory['id'],
                                  "isSolved":selectedProblemStatus=="Solved"?true:selectedProblemStatus=="Unsolved"?false:null
                                };
                                Navigator.pop(context);
                                getItemEvaluations(filter);
                                                                     
                              }else{
                               ToastContext().init(context);
                                Toast.show("Select filter option");
                              }
                              
                          }, child: const Text("Apply filter"))                 
              ],),
            );
          }
        );
     });
  }

  List actionsToTake=["Mark as solved","Delete"];
  
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
                return OutlinedButton(onPressed: ()async{
                  if(e==actionsToTake[0]){
                    UserReplyWindows().showLoadingDialog(context);
                    var res=await DatabaseApi().updateSolvedStatus(evaluation['id']);
                     Navigator.pop(context);
                     if(res['msg']=="done"){
                        List evals=dataProvider.evaluations;
                       int index= evals.indexWhere((el) => el['id']==evaluation['id']);    
                        evals[index]['isSolved']=true;
                        setState(() {
                          dataProvider.evaluations=evals;
                          getItemEvaluations({});
                        });
                        Navigator.pop(context);
                      UserReplyWindows().showSnackBar("Evaluation updated successful..","info");
                     }else{
                        UserReplyWindows().showSnackBar(res["msg"],"error");  
                     }   
                  }else{
                    UserReplyWindows().showLoadingDialog(context);
                   var res=await DatabaseApi().deleteEvaluation(evaluation['id']);
                   Navigator.pop(context);
                  if(res['msg']=="done"){
                    List evals=dataProvider.evaluations;
                    evals.removeWhere((el) => el['id']==evaluation['id']);     
                    setState(() {
                      dataProvider.evaluations=evals;
                      getItemEvaluations({});
                    });
                    Navigator.pop(context);
                    UserReplyWindows().showSnackBar("Evaluation removed successful..","info");
                  }else{
                    UserReplyWindows().showSnackBar(res["msg"],"error");
                  }
                  
                  }
                },style: OutlinedButton.styleFrom(
                  side: BorderSide(color: appColor)
                  ), child: Text(e));
              }).toList()
            )
          ]));
          }
    );
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
              loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
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