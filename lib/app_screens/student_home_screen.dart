import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udomdte/app_screens/evaluation_home_screen.dart';
import 'package:udomdte/app_services/common_variables.dart';
import 'package:udomdte/app_services/database_services.dart';

import '../app_services/provider_services.dart';
import '../app_services/user_reply_windows_services.dart';
import '../app_subscreens/app_subscreens.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> with SingleTickerProviderStateMixin {
  final List<String> _pageViewTitle=["Evaluate instructor","Evaluate course","Evaluate item"];
  TabController? _cntr;
    late DataProvider dataProvider;
 Map<String,dynamic> _data={};
 Map<String,dynamic> _userInfo={};

  getEvaluations()async{
        Map<String,dynamic> filter={
          "collageId":_userInfo['collageId']
        };       
        var data= await DatabaseApi().getEvaluation(filter);
        _data=data;
        if(data['msg']=="done"){
            dataProvider.evaluations = data['data'];
        }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cntr=TabController(length: 3, vsync: this);
    Future.delayed(const Duration(microseconds: 1),()async{
       getEvaluations();
    });
  }

  @override
  Widget build(BuildContext context) {
    dataProvider=Provider.of<DataProvider>(context);
     Size screenSize=MediaQuery.of(context).size;
     _userInfo=dataProvider.userData;   
    return WillPopScope(
      onWillPop: ()async{
        _cntr!.animateTo(0);
       return false;
      },
      child: Scaffold(
        appBar: AppSubScreens().homeAppBar(context,dataProvider),
        body: SizedBox(
          width: screenSize.width,
          child: Column(
            children: [
               AppSubScreens().homeAppHeader(dataProvider.userData),            
              Expanded(
                child: Column(
                     children: [
                       Container(
                         padding: const EdgeInsets.symmetric(vertical: 4),
                         child: const Text("What do you want to do?",textAlign: TextAlign.center,
                           style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),),
                       ),
                       Expanded(
                         child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,mainAxisSpacing: 10,crossAxisSpacing: 10,childAspectRatio: 8.5),
                             itemCount: _pageViewTitle.length,
                             padding: const EdgeInsets.all(5),
                             itemBuilder: (context,index){
                              Icon icon=const Icon(Icons.person);
                              String stdEvaluate="";
                               switch (index) {
                                 case 0:
                                   icon=const Icon(Icons.person);
                                   break;
                                  case 1:
                                   icon=const Icon(Icons.school); 
                                   break;
                                  case 2:
                                   icon=const Icon(Icons.category); 
                                   break; 
                                 default:
                               }
                                return OutlinedButton.icon(
                                onPressed: (){
                                String stdEvaluate="";
                                switch (index) {
                                 case 0:
                                   stdEvaluate="instructor";
                                   break;
                                  case 1:
                                   stdEvaluate="course"; 
                                   break;
                                  case 2:
                                   stdEvaluate="item"; 
                                   break; 
                                  default:
                                 }
                                 dataProvider.studentEvaluate=stdEvaluate;
                                 UserReplyWindows().navigateScreen(context,const EvaluationHomeScreen());     
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: appColor)
                                ),
                                 icon: icon, label: Text(_pageViewTitle[index])); 
                             }),
                       ),
                     ],
                   ),                     
               )
               ],
          ),
        )
      ),
    );  
}
}