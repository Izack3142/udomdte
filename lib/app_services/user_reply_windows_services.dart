import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:udomdte/app_services/common_variables.dart';
import 'package:udomdte/main.dart';

class UserReplyWindows{
  
  navigateScreen(BuildContext context,Widget newScreen,{bool? kill}){
   if(kill == true){
     Navigator.pushReplacement(context, PageTransition(child: newScreen, type: PageTransitionType.rightToLeft));
   }else{
     Navigator.push(context, PageTransition(child: newScreen, type: PageTransitionType.rightToLeft));
   }
  }
  

 showSnackBar(String message,String type){
  scaffoldKey.currentState!.showSnackBar(SnackBar(
    backgroundColor: type=="error"?Colors.red:Colors.green,
    duration: const Duration(seconds:8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    content:Row(
    children: [
      Icon(type=="error"?Icons.error:Icons.done),
      Expanded(child: Text(message,style: const TextStyle(fontWeight: FontWeight.bold),)),
    ],
  )));
 }


  void showLoadingDialog(BuildContext context){
    showDialog(context: context,
    barrierColor: Colors.black87,
     builder: (context){
       return Container(
        width: 50,height:50,
        padding: const EdgeInsets.all(0),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
           children:[
             CircularProgressIndicator(color: whiteColor,),
             Text("please wait..",style: TextStyle(color: whiteColor,fontWeight: FontWeight.bold),)
             ],
         ),
       );
    });
  }
}