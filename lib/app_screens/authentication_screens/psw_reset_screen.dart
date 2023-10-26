import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:udomdte/app_services/common_variables.dart';
import 'package:udomdte/app_services/user_reply_windows_services.dart';

import '../../app_services/database_services.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
 final _usernameCntr=TextEditingController();
  
  @override
  Widget build(BuildContext context) {
      Size screenSize=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text(""),elevation: 0,),
      body: SizedBox(
        width: screenSize.width,
        child: Column(
          children: [
            Expanded(child: Container(
              width: screenSize.width,
             decoration: BoxDecoration(
               color: appColor,
               borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),bottomRight:Radius.circular(20) 
               )  
             ),
             child: SafeArea(
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(200)
                  ),
                  child: Image.asset("assets/images/udom_logo.png"),
                ),
                const SizedBox(height: 10,),
                Text("Reset password",style: TextStyle(fontSize: 30,color:whiteColor),),
                ],
               ),
             ),
            )),            
            Expanded(child:Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Form(
                child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("we will send link to your email address that you will use to create your new password.",
                  style: TextStyle(color: Colors.green,fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,),
                  const SizedBox(height: 10,),
                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: _usernameCntr,
                      decoration:const InputDecoration(
                        label: Text("Reg number or Email address"),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                        style:ElevatedButton.styleFrom(
                          shadowColor: blackColor,elevation: 10,
                          backgroundColor: whiteColor,
                          padding:const EdgeInsets.all(0),
                          shape:RoundedRectangleBorder(
                            side: BorderSide(color: appColor,width: 2),
                            borderRadius: BorderRadius.circular(30)
                          )
                        ),
                        onPressed: ()async{
                        if(_usernameCntr.text.trim().isNotEmpty){
                            UserReplyWindows().showLoadingDialog(context);
                           var res=await DatabaseApi().resetForgotPassword(_usernameCntr.text.trim());
                           Navigator.pop(context);
                           if(res['msg']=='done'){
                             UserReplyWindows().showSnackBar("Link sent successfuly, open it to continue..", "info");
                             Navigator.pop(context);
                           }else{
                              UserReplyWindows().showSnackBar(res['msg'], "error");
                           }
                        }else{
                            EasyLoading.showToast("Please fill your username or email address!!");
                        }
                        
                        },
                         child: Stack(
                          children: [
                           Container(
                            height: 40,
                            padding:const EdgeInsets.only(right: 7),
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.link,color: appColor,)),                           
                           Container(
                            height: 40,width: 160,
                            decoration: BoxDecoration(
                              color: appColor,
                              borderRadius:const BorderRadius.only(topLeft: Radius.circular(30),
                              bottomRight: Radius.circular(50),
                              bottomLeft: Radius.circular(30))
                            ),
                            child: const Center(child: Text("Get link")))
                         ],
                       )),
                  )   
                ],
              )),
            ) ),
          ],
        ),
      )
    );
  
  }
}


