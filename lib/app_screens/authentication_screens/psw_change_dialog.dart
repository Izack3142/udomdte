import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../app_services/user_reply_windows_services.dart';

class PasswordChangeDialog{
  final _newPasswordCntrl=TextEditingController();
  final _newPasswordConfirmCntrl=TextEditingController();

  showPswChangeDialog(BuildContext context,var data){
    showGeneralDialog(context: context,
     pageBuilder: (context,anim1,anim2){
      return AlertDialog(
        contentPadding: const EdgeInsets.all(10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Create new password",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            SizedBox(
             height: 45,
             child: TextFormField(
              obscureText: true,
             controller: _newPasswordCntrl,
              decoration:const InputDecoration(
              label: Text("Your new password"),
              prefixIcon: Icon(Icons.security),
              border: OutlineInputBorder()
               ),
                 ),
              ),
           const SizedBox(height: 10,),
            SizedBox(
             height: 45,
             child: TextFormField(
              obscureText: true,
             controller: _newPasswordConfirmCntrl,
              decoration:const InputDecoration(
              label: Text("Confirm your new password"),
              prefixIcon: Icon(Icons.security),
              border: OutlineInputBorder()
               ),
                 ),
              ),
           const SizedBox(height: 10,),
           SizedBox(
          width: MediaQuery.of(context).size.width,
           child: ElevatedButton(onPressed: (){
             if(_newPasswordCntrl.text.trim().isNotEmpty && _newPasswordConfirmCntrl.text.trim().isNotEmpty){
                UserReplyWindows().showLoadingDialog(context);
                  Future.delayed(const Duration(milliseconds: 4000),(){
                   Navigator.pop(context);
                  // Navigator.push(context,MaterialPageRoute(builder: (context)=>StudentHomeScreen()));
                 });
             }else{
              EasyLoading.showToast("Please fill all fields!!");
             }
            }, child: const Text("Submit")),
           )
          ],
        ),
      );
     });
  }
}