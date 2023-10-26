import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udomdte/app_screens/authentication_screens/login_screen.dart';
import 'package:udomdte/app_screens/hod_home_screen.dart';
import 'package:udomdte/app_screens/instructor_home_screen.dart';
import 'package:udomdte/app_screens/student_home_screen.dart';
import 'package:udomdte/app_services/database_services.dart';

import '../app_services/common_variables.dart';
import '../app_services/provider_services.dart';
import '../app_services/user_reply_windows_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late DataProvider dataProvider;
  double _logoWidth = 0;
  double _dividerWidth = 0;
  Timer? _timer;

  checkCurrentUser() async {
    var res = await DatabaseApi().checkForCurrentUser();
    if (res['msg'] == 'user-found') {
      Map<String, dynamic> additionalInfo = {};
      additionalInfo = await DatabaseApi().getAddtionalUserInfo(res['data']);
      additionalInfo.addAll(res['data']);
      dataProvider.userData = additionalInfo;
      var data = await DatabaseApi().getInstructors(dataProvider.userData);
      if (data['msg'] == "done") {
        dataProvider.instructors = data['data'];
      }
      var re = await DatabaseApi().getAllCourses();
      if (re['msg'] == "done") {
        dataProvider.courses = re['data'];
      }
      if (res['data']['isRegistered'] == true) {
        Widget? newScreen;
        switch (res['data']['lable']) {
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
      } else {
        UserReplyWindows()
            .navigateScreen(context, LoginScreen(res['data']), kill: true);
      }
    } else if (res['msg'] == 'no-user-found') {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => LoginScreen(const {})));
      });
    } else {
      UserReplyWindows().showSnackBar("Something went wrong!!", "error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      checkCurrentUser();
    });

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_dividerWidth == 60) {
          _dividerWidth = 5;
        } else {
          _dividerWidth = 60;
        }
      });
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _logoWidth = 150;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF003151),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              width: _logoWidth,
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(200)),
              child: Image.asset("assets/images/udom_logo.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              height: 3,
              width: _dividerWidth,
              color: Colors.white,
            ),
            Text(
              "UDOM Daily Teaching Evaluation",
              style: TextStyle(fontSize: 20, color: whiteColor),
            ),
            Text(
              "System",
              style: TextStyle(fontSize: 20, color: whiteColor),
            )
          ],
        ),
      ),
    );
  }
}
