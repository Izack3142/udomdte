import 'package:flutter/material.dart';
import 'package:loading_transition_button/loading_transition_button.dart';
import 'package:provider/provider.dart';
import 'package:udomdte/app_screens/authentication_screens/psw_reset_screen.dart';
import 'package:udomdte/app_screens/hod_home_screen.dart';
import 'package:udomdte/app_screens/student_home_screen.dart';
import 'package:udomdte/app_services/common_variables.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:udomdte/app_services/user_reply_windows_services.dart';

import '../../app_services/database_services.dart';
import '../../app_services/provider_services.dart';
import '../instructor_home_screen.dart';

class LoginScreen extends StatefulWidget {
  Map<String, dynamic> currentUser;
  LoginScreen(this.currentUser, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late DataProvider dataProvider;
  bool _passwordHidden = true;
  final _usernameCntr = TextEditingController();
  final _passwordCntr = TextEditingController();
  final _ladingBtnController = LoadingButtonController();
  final bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (widget.currentUser.isNotEmpty) {
        showPasswordUpdateDialog(widget.currentUser);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    dataProvider = Provider.of<DataProvider>(context);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SizedBox(
      width: screenSize.width,
      child: Column(
        children: [
          Expanded(
              child: Container(
            width: screenSize.width,
            decoration: BoxDecoration(
                color: appColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(200)),
                    child: Image.asset("assets/images/udom_logo.png"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 30, color: whiteColor),
                  ),
                ],
              ),
            ),
          )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: _usernameCntr,
                    decoration: const InputDecoration(
                        label: Text("Username"),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 45,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: _passwordCntr,
                        obscureText: _passwordHidden,
                        decoration: const InputDecoration(
                            label: Text("Password"),
                            prefixIcon: Icon(Icons.security),
                            border: OutlineInputBorder()),
                      ),
                      Positioned(
                        right: 0,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordHidden = !_passwordHidden;
                              });
                            },
                            icon: Icon(_passwordHidden == true
                                ? Icons.visibility
                                : Icons.visibility_off)),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Forgot password? "),
                    TextButton(
                        onPressed: () {
                          UserReplyWindows().navigateScreen(
                              context, const PasswordResetScreen());
                        },
                        child: const Text("Reset"))
                  ],
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: blackColor,
                          elevation: 10,
                          backgroundColor: whiteColor,
                          padding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: appColor, width: 2),
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        // int count=0;
                        //     courses.forEach((el) {
                        //       el['stoodBy'].forEach((s){
                        //          if(s["name"]=="BSC-CE" && s["yos"]==1 && s["semester"]==1){
                        //           count++;
                        //         }
                        //       });

                        //     });
                        //  print("Total records ${count.toString()}");
                        if (_usernameCntr.text.trim().isNotEmpty &&
                            _passwordCntr.text.trim().isNotEmpty) {
                          UserReplyWindows().showLoadingDialog(context);
                          // print(_usernameCntr.text.trim() + " abc " +_passwordCntr.text.trim());
                          var credentials = {
                            "userName": _usernameCntr.text.trim(),
                            "password": _passwordCntr.text.trim()
                          };
                          var resp =
                              await DatabaseApi().signInUser(credentials);

                          //print(resp);
                          if (resp["msg"] == 'update-password') {
                            Navigator.pop(context);
                            showPasswordUpdateDialog(resp["data"]);
                          } else {
                            if (resp['msg'] == "done") {
                              Map<String, dynamic> additionalInfo = {};
                              additionalInfo = await DatabaseApi()
                                  .getAddtionalUserInfo(resp['data']);
                              additionalInfo
                                  .addAll(resp['data'] as Map<String, dynamic>);
                              dataProvider.userData = additionalInfo;
                              var data = await DatabaseApi()
                                  .getInstructors(dataProvider.userData);
                              if (data['msg'] == "done") {
                                dataProvider.instructors = data['data'];
                              }
                              var res = await DatabaseApi().getAllCourses();
                              if (res['msg'] == "done") {
                                dataProvider.courses = res['data'];
                              }

                              //UserReplyWindows().showSnackBar(dataProvider.userData.toString()+" mmmm", "error");
                              Navigator.pop(context);
                              navigateToSpecificPage(resp['data']);
                            } else {
                              Navigator.pop(context);
                              UserReplyWindows()
                                  .showSnackBar(resp['msg'], "error");
                            }
                          }

                          //  var resp=await DatabaseApi().insertCollages();
                          //   Navigator.pop(context);
                          //    print(resp);

                          //  Future.delayed(const Duration(milliseconds: 2000),(){
                          //    Navigator.pop(context);
                          //    Widget? newPage;
                          //    if(_usernameCntr.text.trim()=="student"){
                          //        newPage=StudentHomeScreen();
                          //    }
                          //    if(_usernameCntr.text.trim()=="instructor"){
                          //        newPage=InstructorHomeScreen();
                          //    }
                          //    if(_usernameCntr.text.trim()=="hod"){
                          //        newPage=HodHomeScreen();
                          //    }
                          //    if(_usernameCntr.text.trim()=="principle"){
                          //        newPage=HodHomeScreen();
                          //    }
                          //    if(newPage != null){
                          //       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>newPage!));
                          //    }else{
                          //     UserReplyWindows().showSnackBar("Invalid user credencials!!", "error");
                          //    }
                          //    });
                        } else {
                          EasyLoading.showToast(
                              "Please fill both username and password!!");
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                              height: 40,
                              padding: const EdgeInsets.only(right: 7),
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.login,
                                color: appColor,
                              )),
                          Container(
                              height: 40,
                              width: 160,
                              decoration: BoxDecoration(
                                  color: appColor,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(50),
                                      bottomLeft: Radius.circular(30))),
                              child: const Center(child: Text("Login")))
                        ],
                      )),
                )
              ],
            )),
          )),
        ],
      ),
    ));
  }

  showPasswordUpdateDialog(var user) {
    final pswCntr = TextEditingController();
    final cPswCntr = TextEditingController();

    showGeneralDialog(
        context: context,
        barrierLabel: "update-password",
        barrierDismissible: true,
        transitionBuilder: (context, anim1, anim2, child) {
          Animation<Offset> position =
              Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
                  .animate(anim1);
          return SlideTransition(
            position: position,
            child: child,
          );
        },
        pageBuilder: (context, anim1, anim2) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              contentPadding: const EdgeInsets.all(10),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "UPDATE YOUR PASSWORD",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: "${user['firstName']}",
                        style: TextStyle(
                            fontSize: 14,
                            color: appColor,
                            fontWeight: FontWeight.bold)),
                    const TextSpan(
                        text: " your password is still default",
                        style: TextStyle(fontSize: 12)),
                  ])),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      controller: pswCntr,
                      obscureText: true,
                      decoration: const InputDecoration(
                          label: Text("Password"),
                          prefixIcon: Icon(Icons.security),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      controller: cPswCntr,
                      obscureText: true,
                      decoration: const InputDecoration(
                          label: Text("Confirm password"),
                          prefixIcon: Icon(Icons.security),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        var pass = pswCntr.text;
                        var cPass = cPswCntr.text;
                        if (pass.isNotEmpty &&
                            cPass.isNotEmpty &&
                            pass.length >= 6) {
                          if (pass == cPass) {
                            //Navigator.pop(context);
                            UserReplyWindows().showLoadingDialog(context);
                            var res =
                                await DatabaseApi().updatePassword(user, pass);
                            if (res['msg'] == "done") {
                              Map<String, dynamic> additionalInfo = {};
                              additionalInfo = await DatabaseApi()
                                  .getAddtionalUserInfo(user);
                              additionalInfo.addAll(user);
                              dataProvider.userData = additionalInfo;
                              Navigator.pop(context);
                              navigateToSpecificPage(user);
                            } else {
                              Navigator.pop(context);
                              UserReplyWindows()
                                  .showSnackBar(res['msg'], 'error');
                            }
                          } else {
                            UserReplyWindows().showSnackBar(
                                "Two passwords must be similar..", "error");
                          }
                        } else {
                          UserReplyWindows().showSnackBar(
                              "Six character password is needed..", "error");
                        }
                      },
                      child: const Text("Update"))
                ],
              ));
        });
  }

  void navigateToSpecificPage(user) async {
    Widget? newScreen;
    switch (user['lable']) {
      case 'student':
        newScreen = const StudentHomeScreen();
        break;
      case 'instructor':
        newScreen = const InstructorHomeScreen();
        break;
      case 'hod':
        newScreen = const HodHomeScreen();
        break;
      case 'principle':
        newScreen = const HodHomeScreen();
        break;
      case 'assetmanager':
        newScreen = const HodHomeScreen();
        break;
      default:
    }
    UserReplyWindows().navigateScreen(context, newScreen!, kill: true);
  }
}
