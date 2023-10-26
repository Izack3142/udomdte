import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udomdte/app_screens/hod_screens/course_evaluation_screen.dart';

import '../app_services/common_variables.dart';
import '../app_services/database_services.dart';
import '../app_services/provider_services.dart';
import '../app_services/user_reply_windows_services.dart';
import '../app_subscreens/app_subscreens.dart';
import 'hod_screens/instructor_evaluation_list_screen.dart';
import 'hod_screens/item_evaluation_list_screen.dart';
import 'hod_screens/reported_cases_screen.dart';

class HodHomeScreen extends StatefulWidget {
  const HodHomeScreen({super.key});

  @override
  State<HodHomeScreen> createState() => _HodHomeScreenState();
}

class _HodHomeScreenState extends State<HodHomeScreen> {
  final _pageController = PageController();
  late DataProvider dataProvider;
  Map<String, dynamic> _data = {};
  Map<String, dynamic> _userInfo = {};
  final int _currentPage = 0;
  final List<String> _screensTitle = [
    "Instructor evaluations",
    "Course evaluations",
    "Item evaluations"
  ];
  final bool _isExpanded = true;

  getEvaluations() async {
    Map<String, dynamic> filter = {"collageId": _userInfo['collageId']};
    var data = await DatabaseApi().getEvaluation(filter);
    _data = data;
    if (data['msg'] == "done") {
      dataProvider.evaluations = data['data'];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(microseconds: 10), () async {
      getEvaluations();
    });
  }

  @override
  Widget build(BuildContext context) {
    dataProvider = Provider.of<DataProvider>(context);
    Size screenSize = MediaQuery.of(context).size;
    _userInfo = dataProvider.userData;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppSubScreens().homeAppBar(context, dataProvider),
          body: SizedBox(
            width: screenSize.width,
            child: Column(
              children: [
                AppSubScreens().homeAppHeader(dataProvider.userData),
                Expanded(
                    child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text(
                        "What do you want to see?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: _screensTitle.length,
                          padding: const EdgeInsets.all(5),
                          itemBuilder: (context, index) {
                            Icon icon = const Icon(Icons.person);
                            //Widget newScreen=InstructorEvaluationListScreen();
                            switch (index) {
                              case 0:
                                icon = const Icon(Icons.person);
                                //newScreen=InstructorEvaluationListScreen();
                                break;
                              case 1:
                                icon = const Icon(Icons.school);
                                //newScreen=ItemEvaluationListScreen();
                                break;
                              case 2:
                                icon = const Icon(Icons.category);
                                //newScreen=ItemEvaluationListScreen();
                                break;
                              case 3:
                                icon = const Icon(Icons.line_axis_outlined);
                                //newScreen=HodEvaluationSummaryScreen();
                                break;
                              default:
                            }
                            return dataProvider.userData['lable'] ==
                                        "assetmanager" &&
                                    (index == 0 || index == 1)
                                ? Container()
                                : index == 2 &&
                                        dataProvider.userData['lable'] !=
                                            "assetmanager"
                                    ? Container()
                                    : OutlinedButton.icon(
                                        onPressed: () {
                                          UserReplyWindows().navigateScreen(
                                              context,
                                              InstructorPages(
                                                  _screensTitle[index]));
                                        },
                                        style: OutlinedButton.styleFrom(
                                            side: BorderSide(color: appColor)),
                                        icon: icon,
                                        label: Text(_screensTitle[index]));
                          }),
                    ),
                  ],
                ))
              ],
            ),
          )),
    );
  }
}

class InstructorPages extends StatefulWidget {
  String childPage;
  InstructorPages(this.childPage, {super.key});

  @override
  State<InstructorPages> createState() => _InstructorPagesState();
}

class _InstructorPagesState extends State<InstructorPages> {
  Widget? _page;
  String title = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = widget.childPage;
  }

  Widget shiftPage() {
    switch (title) {
      case "Reported cases":
        _page = const ReportedCasesScreen();
        break;
      case "Instructor evaluations":
        _page = const InstructorEvaluationListScreen();
        break;
      case "Course evaluations":
        _page = const CourseEvaluationListScreen();
        break;
      case "Item evaluations":
        _page = const ItemEvaluationListScreen();
        break;
      default:
    }
    return _page!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: Container(child: shiftPage()),
    );
  }
}
