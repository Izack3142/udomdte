import 'package:flutter/material.dart';

import 'package:udomdte/app_services/common_variables.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  bool _isLoading=true;


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 4),(){
        setState(() {
          _isLoading=false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select course"),),
    body: _isLoading?const Center(child: CircularProgressIndicator()):ListView.builder(
        itemCount: schoolItems.length,
        itemBuilder: (context,index){
          return ListTile(
            onTap: (){
              Navigator.pop(context,schoolItems[index]);
            },
            contentPadding: const EdgeInsets.only(left: 5),
            visualDensity: const VisualDensity(horizontal: -3,vertical: -3),
            leading: const Icon(Icons.person_pin,size: 40,),
            title: Text(schoolItems[index]),subtitle: const Text("All items that fall under this cartegory"),
           ); 
        }),
    );
  }
}