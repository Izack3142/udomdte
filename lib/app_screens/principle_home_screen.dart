import 'package:flutter/material.dart';

import '../app_services/common_variables.dart';
import 'authentication_screens/login_screen.dart';
import 'authentication_screens/psw_change_dialog.dart';
import 'evaluation_sub_screens/items_evaluation_sub_screen.dart';

class PrincipleHomeScreen extends StatefulWidget {
  const PrincipleHomeScreen({super.key});

  @override
  State<PrincipleHomeScreen> createState() => _PrincipleHomeScreenState();
}

class _PrincipleHomeScreenState extends State<PrincipleHomeScreen> {
  @override
  Widget build(BuildContext context) {
        Size screenSize=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (val){
               print(val);
                if(val=="0"){
                   PasswordChangeDialog().showPswChangeDialog(context," data");
                }
                if(val=="1"){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen(const {})));  
                }
            },
            itemBuilder: (context){
              return [
                const PopupMenuItem(value: "0",child: Text("Change password"),),
                const PopupMenuItem(value: "1", child: Text("Logout")),
              ];
          })
        ],
        title: const Text("Welcome Udom dte"),elevation: 0,),
      body: SizedBox(
        width: screenSize.width,
        child: Column(
          children: [
            Container(
            width: screenSize.width,
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
            decoration: BoxDecoration(
             color: appColor,
             borderRadius:const BorderRadius.only(
              bottomLeft: Radius.circular(20),bottomRight:Radius.circular(20) 
             )  
                       ),
                       child: SafeArea(
             child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: Container(),),
                  Icon(Icons.person_pin,size: 120,color: whiteColor,),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Logedin as:",style: TextStyle(color: Colors.blue),),Text("Isiaka Mfugale",maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              ExpansionTile(title: Text("Other personal details",style: TextStyle(color: whiteColor),),
              collapsedIconColor: whiteColor,
              children: [
                Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                  children: [
                   Row(
                     children: [
                      const Icon(Icons.circle,color: Colors.blue,size: 10,),
                       Text("Reg number:",style: TextStyle(fontSize: 15, color:whiteColor),),
                     ],
                   ),
                   Text("T/UDOM/2018/00111",style: TextStyle(fontSize: 15, color:whiteColor,fontWeight: FontWeight.bold),),
                   ],   
                  ),
                  TableRow(                    
                  children: [
                   Row(
                     children: [
                      const Icon(Icons.circle,color: Colors.green,size: 10,),
                       Text("Program:",style: TextStyle(fontSize: 15, color:whiteColor),),
                     ],
                   ),
                   Text("Bsc Software engineering",style: TextStyle(fontSize: 15, color:whiteColor,fontWeight: FontWeight.bold),),
                   ],   
                  ),TableRow(
                  children: [
                   Row(
                     children: [
                      const Icon(Icons.circle,color: Colors.red,size: 10,),
                       Text("Department:",style: TextStyle(fontSize: 15, color:whiteColor),),
                     ],
                   ),
                   Text("Computer science and engineering",style: TextStyle(fontSize: 15, color:whiteColor,fontWeight: FontWeight.bold),),
                   ],   
                  )
                ],
              ),
                
              ],
              ),
              ],
             ),
                       ),
                      ),            
            const Expanded(
              child: ItemsEvaluationSubScreen()
             )
             ],
        ),
      )
    );  

  }
}