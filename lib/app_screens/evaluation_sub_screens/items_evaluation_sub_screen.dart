import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udomdte/app_screens/items_list_screen.dart';

import '../../app_services/common_variables.dart';
import '../../app_services/database_services.dart';
import '../../app_services/provider_services.dart';
import '../../app_services/user_reply_windows_services.dart';

class ItemsEvaluationSubScreen extends StatefulWidget {
  const ItemsEvaluationSubScreen({super.key});

  @override
  State<ItemsEvaluationSubScreen> createState() => _ItemsEvaluationSubScreenState();
}


class _ItemsEvaluationSubScreenState extends State<ItemsEvaluationSubScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
 String _selectedItemStatus=""; 
 File? _pickedImage;  
 final _itemLocationCntr=TextEditingController();
 final _evaluationCntr=TextEditingController();
 Map<String,dynamic> _itemType={};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  DataProvider dataProvider=Provider.of<DataProvider>(context);
   return Scaffold(
    backgroundColor: appColor,
      body: Container(
       padding:const EdgeInsets.only(left: 5,right: 5, bottom: 5),
       decoration: BoxDecoration(
        color: whiteColor,
        borderRadius:const BorderRadius.only(
          topLeft: Radius.circular(20),topRight: Radius.circular(20)
        ),
        ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
         Expanded(child: Column(
           children: [
           Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: const Text("Write evaluation for collage items.",textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),),
            ),
             Expanded(
               child: SingleChildScrollView(
                 child: Column(
                  children: [
                       GestureDetector(
                        onTap: ()async{
                         var result=await Navigator.push(context, PageTransition(child: const ItemsListScreen(), type: PageTransitionType.bottomToTop) );
                         if(result != null){
                           setState(() {
                              _itemType =result;
                           });
                         }
                        },
                         child: AbsorbPointer(
                           child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: appColor,width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Row(children: [const Icon(Icons.category),const SizedBox(width: 8,),
                                Text(_itemType.isEmpty ?"Select item":_itemType['name'],style: const TextStyle(fontWeight: FontWeight.bold),),],)),
                                GestureDetector(
                                  onTap: ()async{
                                    var result=await Navigator.push(context, PageTransition(child: const ItemsListScreen(), type: PageTransitionType.bottomToTop) );
                                      if(result != null){
                                        setState(() {
                                            _itemType =result;
                                        });
                                      }
                                  },
                                  child: const AbsorbPointer(child: Icon(Icons.arrow_drop_down)),
                                )
                              ],
                            ),
                           ),
                         ),
                       ),
                  const SizedBox(height: 10,),
                  Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom:4),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: appColor,width: 1.5),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("General item condition",style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                            shrinkWrap: true,  
                            scrollDirection: Axis.horizontal,  
                            children: excellenceLevel.map((el){
                              int ind=excellenceLevel.indexWhere((element) => element==el);
                               return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: appColor),
                                  backgroundColor: _selectedItemStatus==el?excellenceLevelColors[ind]:whiteColor),
                                  onPressed: (){
                                    setState(() {
                                      _selectedItemStatus=el;
                                    });
                                   }, child: Text(el,maxLines: 1));
                            }).toList(),
                            ),
                          ),
                        ],
                      ),
                     ),
                  SizedBox(
                   height: 45,
                   child: TextFormField(
                   controller: _itemLocationCntr,
                    decoration:const InputDecoration(
                    label: Text("Item's location"),
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder()
                     ),
                       ),
                    ),
                    const SizedBox(height: 10,),
                  ],
                 ),
               ),
             ),
           ],
         )),
         
         SizedBox(
          width: MediaQuery.of(context).size.width,
           child: ElevatedButton(onPressed: () async{
            if(_itemType.isNotEmpty && _selectedItemStatus.isNotEmpty && _itemLocationCntr.text.trim().isNotEmpty){
                var itemData={
                   "categoryId":_itemType['id'],
                   "categoryName":_itemType['name'],
                   "for":"item",
                   "uploaderId": dataProvider.userData['id'],
                   "location":"CIVE-"+_itemLocationCntr.text.trim(),
                   "description":_evaluationCntr.text.trim(),
                   "collageId":dataProvider.userData['collageId'],
                   "solvedAt":null,
                   "isSolved":false,
                   "uploadedAt":null,
                   "status":_selectedItemStatus,
                };

                UserReplyWindows().showLoadingDialog(context);
                var res=await DatabaseApi().uploadToFirestore(itemData);
                Navigator.pop(context);
                 if(res['msg']=="done"){
                  setState(() {
                    _itemType={};
                    _itemLocationCntr.clear();
                    _evaluationCntr.clear();
                    _pickedImage=null;      
                  });
                  print(dataProvider.evaluations.length);
                 List evals=dataProvider.evaluations;
                 evals.add(res['data']);
                  dataProvider.evaluations=evals;
                  print(dataProvider.evaluations.length);
                  Navigator.pop(context);
                    UserReplyWindows().showSnackBar("Evaluation posted successful..","info");     
                 }else{
                    UserReplyWindows().showSnackBar(res['msg'],"error");
                 }
             }else{
              EasyLoading.showToast("Please fill all fields!!");
             } 
             
           }, child: const Text("Submit")),
         )
         
      ],
    ),
  )
    );
  }
  
  void openBottomSheet() {
    showModalBottomSheet(context: context,
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
          const Center(child: Text("Where to take?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),))       
          ,const SizedBox(height: 10,),
          OutlinedButton.icon(onPressed: (){
            getItemImage(ImageSource.camera);
          }, icon: const Icon(Icons.camera), label: const Text("Camera")),
          //SizedBox(height: 10,),
          OutlinedButton.icon(onPressed: (){
            getItemImage(ImageSource.gallery);
          }, icon: const Icon(Icons.image_search ), label: const Text("Gallery")),
          ],),
        );
     });
  }
  
  void getItemImage(ImageSource source) async{
    Navigator.pop(context);
    var imgFile=await ImagePicker.platform.pickImage(source: source);
    if(imgFile != null){
       CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio5x3,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: appColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ],
    );
       if(croppedFile != null){
         setState(() {
          _pickedImage=File(croppedFile.path);  
        });
       }else{
         UserReplyWindows().showSnackBar("Oops image was not croped","error");
       } 
    }else{
           UserReplyWindows().showSnackBar("Oops image was not taken","error");
    }
         
  }
}