import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:udomdte/app_screens/hod_screens/specific_course_screen.dart';
import 'package:udomdte/app_services/common_variables.dart';

import '../../app_services/provider_services.dart';
import '../../app_services/user_reply_windows_services.dart';

class CourseEvaluationListScreen extends StatefulWidget {
  const CourseEvaluationListScreen({super.key});

  @override
  State<CourseEvaluationListScreen> createState() => _CourseEvaluationListScreenState();
}

class _CourseEvaluationListScreenState extends State<CourseEvaluationListScreen> {
  bool _isLoading=true;
  final Map<String,dynamic> _dates={};
  late DataProvider dataProvider;
  Map<String,dynamic> _selectedCourse={};
  final List<Map<String,dynamic>> _courses=[];
  late void Function(void Function()) _stateSetter;
  List<Map<String,dynamic>> instructorEvaluations=[];


void conditionalStateSetter(){
  setState(() {
    
  });
 }

Future<void> _getInstructor(String name)async{
    name=name.trim().toLowerCase();
    setState(() { 
      _courses.clear();
      _isLoading=true;
    });
      if(name.trim().isNotEmpty){
       for (var crs in dataProvider.courses) {
       if(crs['lable'].toString().toLowerCase().contains(name) || crs['name'].toString().toLowerCase().contains(name)){
            if(dataProvider.userData['lable']=="hod"){
               if(crs['departmentId'] == dataProvider.userData['departmentId']){
                _courses.add(crs);
               }
            }else{
               _courses.add(crs);
            }
          }
        }
      }
    setState(() {
      _isLoading=false;
    });
  }

 getItemEvaluations(Map<String,dynamic> filter)async{
    setState(() {
     _isLoading=true;
      instructorEvaluations=[];
    });
   bool fit=false;
   if(filter.isNotEmpty){
       fit=true;
   }
   
   if(dataProvider.evaluations.isNotEmpty){
     for (var el in dataProvider.evaluations) {       
       if(el['for']=="course"){
          if(dataProvider.userData["lable"] == "hod"){
              if(el['departmentId'] == dataProvider.userData["departmentId"]){
               instructorEvaluations.add(el);       
              }
          }else{
            instructorEvaluations.add(el);
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
        title: const Text("Course evaluations"),
      ),
         Expanded(
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.only(
                    topRight:Radius.circular(25),
                    topLeft:Radius.circular(25)
                  ),
                  boxShadow: const [BoxShadow(blurRadius: 8)]
           ),
          child: Column(
            children: [
              Container(
                height:45,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(blurRadius: 2)]
                ),
                child: TextFormField(
                  onFieldSubmitted: (value){
                     _getInstructor(value);   
                  },
                  onChanged: (value){
                      _getInstructor(value);
                  },
                  //controller: _searchTxtController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText:"Type course name or course code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),
                ),
              ),
              const SizedBox(height:10),
              Stack(
                alignment: Alignment.center,
                children: [
                  Divider(height:3,color: blackColor,),
                  Container(
                    color: whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Column(
                      children: [
                        Text("Courses from".toUpperCase()),
                        Text(dataProvider.userData['lable']=="principle"?dataProvider.userData['collageName']:"${dataProvider.userData['departmentName']} department"),
                      ],
                    )),
                ],
              ),
              Expanded(child:
              _courses.isEmpty?const Center(child:Text("No matching course!!")):ListView.builder(
                itemCount: _courses.length,
                padding:const EdgeInsets.only(top: 0) ,
                itemBuilder:(context,index){
                  var course=_courses[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      border: Border.all()
                    ),
                    child: ListTile(
                        onTap: (){
                         _selectedCourse=course;
                         _showDatepickerBottomsheet();
                        },
                        contentPadding: const EdgeInsets.only(left: 5),
                        visualDensity: const VisualDensity(horizontal: -3,vertical: -3),
                        leading: const Icon(Icons.person_pin,size: 40,),
                        title: Text(course['lable']),subtitle: Text(course['name']),
                      ),
                  ); 
                } ))
            ],
          ),
        ),
      )    
       ],
    );
  }

  void _showDatepickerBottomsheet() {
    String selectedExcellenceLevel="";
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
            _stateSetter= stateSetter;
            late String startDate,endDate;
            if(_dates['startDate'] != null){
             startDate=DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(_dates['startDate']));
            }
            if(_dates['endDate'] != null){
             endDate=DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(_dates['endDate']));
            }
            return Padding(
              padding:const EdgeInsets.all(10),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,  
              children: [
              const Center(child: Text("Select date interval",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),))       
              ,Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                 OutlinedButton(onPressed: (){
                  _pickDate("startDate");   
                 }, child:Text(_dates['startDate'] != null?startDate:"Start date")),
                 const Text("To"),
                 OutlinedButton(onPressed: (){
                   if(_dates["startDate"]!=null){
                       _pickDate("endDate");
                   }else{
                    UserReplyWindows().showSnackBar("Start date is needed first!!","error");
                   }   
                 }, child:Text(_dates['endDate'] != null?endDate:"End date"))
                ],),
              ),
              ElevatedButton(onPressed: (){
                  if(_dates['startDate'] != null){
                    Navigator.pop(context);
                    UserReplyWindows().navigateScreen(context,SpecificCourseEvaluationListScreen(_selectedCourse,_dates)); 
                  }else{
                    UserReplyWindows().showSnackBar("Start date is needed!!","error");
                  }
                }, child:const Text("Get evaluations"))
              ],),
            );
          }
        );
     });
  }

  void _pickDate(String s) async{
   final pickedDate=await showDatePicker(context: context,
      initialDate:s=="endDate"?DateTime.fromMillisecondsSinceEpoch(_dates['startDate']):DateTime.now(),
      firstDate:s=="endDate"?DateTime.fromMillisecondsSinceEpoch(_dates['startDate']):DateTime(2022),lastDate: DateTime.now());
     if(pickedDate != null){
      _stateSetter((){
        _dates[s]=pickedDate.millisecondsSinceEpoch;
      });
     }
  } 

    List actionsToTake=["Report to principle","Delete"];
  
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
                return OutlinedButton(onPressed: (){
                  Navigator.pop(context);
                },style: OutlinedButton.styleFrom(
                  side: BorderSide(color: appColor)
                  ), child: Text(e));
              }).toList()
            )
          ]));
          }
    );
  } 

}

