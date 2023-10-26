import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:udomdte/app_services/database_services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:udomdte/app_services/user_reply_windows_services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app_services/common_variables.dart';


class AttendanceScreen extends StatefulWidget {
  var course;
  DateTime attendanceDate;
  AttendanceScreen(this.course,this.attendanceDate,{super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<Map<String,dynamic>> _attendance=[];
  final List _colNames=["N","NAME","REG_NUMBER"];
  String _formattedDate="";
  bool _isLoading=false;
  final pdfDoc=pw.Document();

  getPdfDoc()async{
   pdfDoc.addPage(pw.Page(
    build:(pw.Context context){
      return pw.Container(
        child:pw.Column(
          crossAxisAlignment:pw.CrossAxisAlignment.center,
          children:[
          pw.Text("UDOM DAILY TEACHING EVALUATION SYSTEM",style: pw.TextStyle(fontWeight:pw.FontWeight.bold,fontSize: 18),),
          pw.Text("Attendance for ${widget.course['lable']} on $_formattedDate",style: pw.TextStyle(fontWeight:pw.FontWeight.bold),),
          pw.Table(
                columnWidths: {0:const pw.FixedColumnWidth(25),2:const pw.FixedColumnWidth(200),3:const pw.FixedColumnWidth(200)},
                border: pw.TableBorder.all(width: 1),
                children: [
                 pw.TableRow(
                  children: _colNames.map((e){
                     return pw.Padding(
                       padding: const pw.EdgeInsets.all(1.0),
                       child: pw.Text(e,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15),),
                     );
                  }).toList()
                 )   
                ],
              ),
                   pw.Table(
                    columnWidths: {0:const pw.FixedColumnWidth(25),2:const pw.FixedColumnWidth(200),3:const pw.FixedColumnWidth(200)},
                    border: pw.TableBorder.all(width: 0.5),
                    children: _attendance.map((e){
                      List<String> keys=e.keys.toList();
                       return pw.TableRow(
                        children:keys.map((a){
                           return pw.Padding(
                             padding: const pw.EdgeInsets.all(4.0),
                             child: pw.Text(e[a].toString()),
                           ); 
                        }).toList()
                       );
                    }).toList(),
                  ),   
        ])
      );
    }
   ));    
  }


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _formattedDate=DateFormat("dd/MM/yyyy").format(widget.attendanceDate);
    });
    getAttendance();
  }

 Future<void> getAttendance()async{
   setState(() {
     _isLoading=true;
   });
   var res=await DatabaseApi().getCoursesAttendance(widget.course['id']);
   if(res['msg']=='done'){
     if(res['msg']!=null){
      int i=0;
      for (var item in res['data']) {
        DateTime date=DateTime.fromMillisecondsSinceEpoch(item['dateUploaded']);
        //print(date.compareTo(widget.attendanceDate));
        if(date.compareTo(widget.attendanceDate)==0){
          _attendance.add({
            'number':i+1,
            'name':item['studentName'],
            'regNumber':item['studentRegNo'],
          });     
          i++;
        }
      }
      if(_attendance.isNotEmpty){
         getPdfDoc();
      }
     }
   }
      setState(() {
     _isLoading=false;
   });
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Column(
          children: [
            const Text("Student attendance"),Text("${widget.course['lable']}--$_formattedDate",style: const TextStyle(fontSize: 13,color: Colors.blue),),
          ],
        ),
      ),
      body: Stack(
        children: [
         Column(
            children: [
              Table(
                columnWidths: const {0:FixedColumnWidth(25),2:FractionColumnWidth(0.45),3:FractionColumnWidth(0.22)},
                border: TableBorder.all(width: 1),
                children: [
                 TableRow(
                  children: _colNames.map((e){
                     return Padding(
                       padding: const EdgeInsets.all(1.0),
                       child: Text(e,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                     );
                  }).toList()
                 )   
                ],
              ),
              Expanded(
                child:_isLoading?const Center(child: CircularProgressIndicator(),)
                :_attendance.isEmpty?const Center(child: Text('No attendance found!!'),):SingleChildScrollView(
                  child: Table(
                    columnWidths: const {0:FixedColumnWidth(25),2:FractionColumnWidth(0.45),3:FractionColumnWidth(0.22)},
                    border: TableBorder.all(width: 0.5),
                    children: _attendance.map((e){
                      List<String> keys=e.keys.toList();
                       return TableRow(
                        children:keys.map((a){
                           return Padding(
                             padding: const EdgeInsets.all(4.0),
                             child: Text(e[a].toString()),
                           ); 
                        }).toList()
                       );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ), 
         Positioned(
          bottom:10,right: 0,left: 0,
           child:_attendance.isEmpty?Container():FloatingActionButton(onPressed: ()async{
            UserReplyWindows().showLoadingDialog(context);
              await saveFiletoStorage();
              Navigator.pop(context);
           },mini: true,backgroundColor: greenColor,child: const Icon(Icons.file_download),),
         ) 
        ],
      ),
    );
  }

  Future<void> saveFiletoStorage()async{
  final expath =Directory("/storage/emulated/0/Download/UdomDte/Attendance").path;
   try{
       final status=await Permission.storage.status;
       if(!status.isGranted){
           await Permission.storage.request();
       }else{
          await Directory(expath).create(recursive: true).then((value)async{    
            File file=File("$expath/${_formattedDate.replaceAll("/","-")}.pdf");
            file.writeAsBytesSync(await pdfDoc.save());
            UserReplyWindows().showSnackBar("File saved to download folder..","info");
          });
       }
   }catch(err){
     UserReplyWindows().showSnackBar(err.toString(),"error");
   }
  }
}