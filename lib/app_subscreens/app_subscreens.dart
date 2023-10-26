import 'package:flutter/material.dart';
import 'package:udomdte/app_screens/authentication_screens/login_screen.dart';
import 'package:udomdte/app_services/database_services.dart';

import '../app_services/common_variables.dart';
import '../app_services/provider_services.dart';
import '../app_services/user_reply_windows_services.dart';

class AppSubScreens {
  homeAppBar(BuildContext context, DataProvider dataProvider) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: const Text("Udom dte"),
      actions: [
        PopupMenuButton<String>(onSelected: (val) async {
          print(val);
          if (val == "0") {
            showPasswordUpdateDialog(dataProvider.userData, context);
          }
          if (val == "1") {
            UserReplyWindows().showLoadingDialog(context);
            var res = await DatabaseApi().signOutUser();
            Navigator.pop(context);
            if (res["msg"] == "done") {
              UserReplyWindows()
                  .navigateScreen(context, LoginScreen(const {}), kill: true);
              dataProvider.userData = {};
            } else {
              UserReplyWindows().showSnackBar(res['msg'], "error");
            }
          }
        }, itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: "0",
              child: Text("Change password"),
            ),
            const PopupMenuItem(value: "1", child: Text("Logout")),
          ];
        })
      ],
    );
  }

  showPasswordUpdateDialog(var user, BuildContext context) {
    final pswCntr = TextEditingController();
    final cPswCntr = TextEditingController();
    final oldPswCntr = TextEditingController();

    showGeneralDialog(
        context: context,
        barrierLabel: "change-password",
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
                    "CHANGE PASSWORD",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      controller: oldPswCntr,
                      obscureText: true,
                      decoration: const InputDecoration(
                          label: Text("Current password"),
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
                      controller: pswCntr,
                      obscureText: true,
                      decoration: const InputDecoration(
                          label: Text("New password"),
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
                        var oldPass = oldPswCntr.text;
                        if (pass.isNotEmpty &&
                            cPass.isNotEmpty &&
                            pass.length >= 6 &&
                            oldPass.length >= 6) {
                          if (pass == cPass) {
                            //Navigator.pop(context);
                            user['password'] = oldPass;
                            UserReplyWindows().showLoadingDialog(context);
                            var res =
                                await DatabaseApi().updatePassword(user, pass);
                            Navigator.pop(context);
                            if (res['msg'] == "done") {
                              UserReplyWindows().navigateScreen(
                                  context, LoginScreen(const {}),
                                  kill: true);
                              UserReplyWindows().showSnackBar(
                                  "Password changed successful..", 'info');
                            } else {
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

  homeAppHeader(var data) {
    Map<String, dynamic> tableData = {"Email": data['email']};
    if (data['lable'] == 'student') {
      tableData['RegNumber'] = data['regNumber'];
      tableData['Program'] = data['programName'];
    }
    if (data['lable'] != 'principle' && data['lable'] != 'assetmanager') {
      tableData['Department'] = data['departmentName'];
    }
    tableData['College'] = data['collageName'];
    List<String> keys = tableData.keys.toList();
    //print(tableData['Email']);
    return Container(
      //width: screenSize.width,
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
      decoration: BoxDecoration(
          color: appColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: SafeArea(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome:",
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text(
                          "${data['firstName']} ${data['lastName']}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  Icons.person_pin,
                  size: 120,
                  color: whiteColor,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Loggedin as:",
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text(
                          data['lable'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Table(
                columnWidths: const {0: FixedColumnWidth(120)},
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: keys.map((e) {
                  return TableRow(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            color: Colors.blue,
                            size: 10,
                          ),
                          Text(
                            e,
                            style: TextStyle(fontSize: 15, color: whiteColor),
                          ),
                        ],
                      ),
                      Text(
                        tableData[e] ?? "null",
                        style: TextStyle(
                            fontSize: 15,
                            color: whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }).toList()),
          ],
        ),
      ),
    );
  }
}
