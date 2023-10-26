import 'package:flutter/material.dart';

class InstructorListScreen extends StatefulWidget {
  const InstructorListScreen({super.key});

  @override
  State<InstructorListScreen> createState() => _InstructorListScreenState();
}

class _InstructorListScreenState extends State<InstructorListScreen> {
 final List<String> _instructors=["Mr Johakim Hassan","Mr Nyondo","Prof Juma Mgaya","Mr James Kihaya","Dr Kihemba"];
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
      appBar: AppBar(
        title: const Text("Instructors"),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search))
        ],
      ),
      body: Column(children: [
        const Text("Instructors of particular department",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.green),),
        Expanded(child: _isLoading?const Center(child: CircularProgressIndicator()):ListView.builder(
        itemCount: _instructors.length,
        itemBuilder: (context,index){
          return ListTile(
            onTap: (){
              Navigator.pop(context,_instructors[index]);
            },
            contentPadding:const EdgeInsets.only(left: 5),
            visualDensity:const VisualDensity(horizontal: -3,vertical: -3),
            leading:const Icon(Icons.person_pin,size: 40,),
            title: Text(_instructors[index]),subtitle: const Text("Department of computer science"),
           ); 
        }))
      ],)
    );
  }
}