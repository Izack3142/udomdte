import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udomdte/app_screens/evaluation_home_screen.dart';
import 'package:udomdte/app_screens/hod_screens/attendance_screen.dart';

import '../app_services/common_variables.dart';
import '../app_services/provider_services.dart';
import '../app_services/user_reply_windows_services.dart';
import '../app_subscreens/app_subscreens.dart';

class InstructorHomeScreen extends StatefulWidget {
  const InstructorHomeScreen({super.key});

  @override
  State<InstructorHomeScreen> createState() => _InstructorHomeScreenState();
}

class _InstructorHomeScreenState extends State<InstructorHomeScreen> {
  final _pageController=PageController();
  final int _currentPage=0;
 
  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider=Provider.of<DataProvider>(context);
    Size screenSize=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppSubScreens().homeAppBar(context,dataProvider),
      body: SizedBox(
        width: screenSize.width,
        child: Column(
          children: [
            AppSubScreens().homeAppHeader(dataProvider.userData),             
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(onPressed: (){
                   dataProvider.studentEvaluate="item";
                   UserReplyWindows().navigateScreen(context,const EvaluationHomeScreen());
                  },style: OutlinedButton.styleFrom(
                  side: BorderSide(color: appColor)
                  ), child:const Text("Start item evaluation")),
                  OutlinedButton(onPressed: ()async{
                   int ind= dataProvider.courses.indexWhere((el) => el['instructorId']==dataProvider.userData['id']);
                   if(ind>=0){
                    //UserReplyWindows().showSnackBar(ind.toString(),"error");
                    _pickAttendanceDate(dataProvider.courses[ind]);
                   }else{
                    UserReplyWindows().showSnackBar("No courses uploaded for you!!","error");
                   }
                  },style: OutlinedButton.styleFrom(
                  side: BorderSide(color: appColor)
                  ), child:const Text("View attendance")),
                ],
                )
              )
             ],
        ),
      )
    );  
  }
  
  void _pickAttendanceDate(course)async{
    final pickedDate=await showDatePicker(context: context,
      initialDate:DateTime.now(),
      firstDate:DateTime(2022),lastDate: DateTime.now());
     if(pickedDate != null){
       UserReplyWindows().navigateScreen(context,AttendanceScreen(course,pickedDate));
     }
  }
}
