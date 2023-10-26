import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_services/database_services.dart';
import '../app_services/provider_services.dart';

class InstructorListScreen extends StatefulWidget {
  const InstructorListScreen({super.key});

  @override
  State<InstructorListScreen> createState() => _InstructorListScreenState();
}

class _InstructorListScreenState extends State<InstructorListScreen> {
 late DataProvider dataProvider;
 List<Map<String,dynamic>> _instructors=[];
 Map<String,dynamic> result={};
 bool _isLoading=true;

Future<void> getInstructors()async{
   var res= await DatabaseApi().getInstructors(dataProvider.userData);
    setState(() {
      _isLoading=false;
      result=res;
      if(result["msg"]=="done"){
         _instructors=result['data'];
      }
    });
}

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 1),(){
         getInstructors();
    });
  }
 
  @override
  Widget build(BuildContext context) {
     dataProvider=Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instructors"),
        // actions: [
        //   IconButton(onPressed: (){}, icon: Icon(Icons.search))
        // ],
      ),
      body: Column(children: [
        const Text("Instructors of particular department",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green),),
        Expanded(child: _isLoading?const Center(child: CircularProgressIndicator()):result['msg']!= "done"?Text(result['msg']):ListView.builder(
        itemCount: _instructors.length,
        itemBuilder: (context,index){
          return ListTile(
            onTap: (){
              Navigator.pop(context,_instructors[index]);
            },
            contentPadding: const EdgeInsets.only(left: 5),
            visualDensity: const VisualDensity(horizontal: -3,vertical: -3),
            leading: const Icon(Icons.person_pin,size: 40,),
            title: Text(_instructors[index]['userName']),subtitle: const Text("Department of computer science and engineering"),
           ); 
        }))
      ],)
    );
  }
}