import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:udomdte/app_services/provider_services.dart';
import '../../app_services/common_variables.dart';
import '../../app_services/database_services.dart';
import '../../app_services/user_reply_windows_services.dart';

class InstructorEvaluationSubScreen extends StatefulWidget {
  const InstructorEvaluationSubScreen({super.key});

  @override
  State<InstructorEvaluationSubScreen> createState() =>
      _InstructorEvaluationSubScreenState();
}

class _InstructorEvaluationSubScreenState
    extends State<InstructorEvaluationSubScreen> {
  List<Map<String, dynamic>> _instrctQuestions = [];
  List<Map<String, dynamic>> _courseQuestions = [];
  final _pageScrollController = PageController();
  late DataProvider dataProvider;
  String studentEvaluate = "";
  Map<String, dynamic> _courseToEvaluate = {};
  final List<Map<String, dynamic>> _instructors = [];
  List<Map<String, dynamic>> _courses = [];
  Map<String, dynamic> result = {};
  Map<String, dynamic> courseInstructor = {};
  bool _isLoading = true;

  Future<void> _getInstructor(String name) async {
    name = name.trim().toLowerCase();
    setState(() {
      _instructors.clear();
      _isLoading = true;
    });
    if (name.trim().isNotEmpty) {
      for (var instr in dataProvider.instructors) {
        if (instr['firstName'].toString().toLowerCase().contains(name) ||
            instr['lastName'].toString().toLowerCase().contains(name) ||
            instr['userName'].toString().toLowerCase().contains(name)) {
          _instructors.add(instr);
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getCourses() async {
    setState(() {
      _isLoading = true;
    });
    var res = await DatabaseApi().getStudentCourses(dataProvider.userData);
    setState(() {
      result = res;
      if (result['msg'] == "done") {
        _courses = result["data"];
      }
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _instrctQuestions = instrctQuestions;
      _courseQuestions = courseQuestions;
      getCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    dataProvider = Provider.of<DataProvider>(context);
    studentEvaluate = dataProvider.studentEvaluate;
    return WillPopScope(
      onWillPop: () async {
        if (_pageScrollController.page != 0) {
          _pageScrollController.animateToPage(0,
              duration: const Duration(milliseconds: 1500),
              curve: Curves.decelerate);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          backgroundColor: appColor,
          body: Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: PageView(
              scrollDirection: Axis.vertical,
              controller: _pageScrollController,
              onPageChanged: (newPage) {
                if ((_courseToEvaluate.isEmpty &&
                        studentEvaluate == "course") ||
                    (courseInstructor.isEmpty &&
                        studentEvaluate == "instructor")) {
                  _pageScrollController.jumpToPage(0);
                }
              },
              children: [
                courseSelectionPage(),
                studentEvaluate == "course"
                    ? courseEvaluationPage()
                    : instEvaluationPage(),
              ],
            ),
          )),
    );
  }

  // studentEvaluate=="course"
  Widget courseSelectionPage() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child:Text(
              studentEvaluate=="instructor"?"Select Course to evaluate instructor":"Select Course to evaluate",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          Expanded(
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : result['msg'] != "done"
                      ? Text(result['msg'])
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 2.5),
                          padding: const EdgeInsets.all(5),
                          itemCount: _courses.length,
                          itemBuilder: (context, index) {
                            return ShowUpAnimation(
                              animationDuration:
                                  const Duration(milliseconds: 500),
                              delayStart: Duration(milliseconds: 50 * index),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 91, 59, 185)),
                                  onPressed: () async {
                                    if (studentEvaluate == "instructor") {
                                      UserReplyWindows()
                                          .showLoadingDialog(context);
                                      var res = await DatabaseApi()
                                          .getCourseInstructor(
                                              _courses[index]["instructorId"]);
                                      Navigator.pop(context);
                                      print(res);
                                      if (res['msg'] == 'done') {
                                        setState(() {
                                          courseInstructor = res['data'];
                                          _courseToEvaluate = _courses[index];
                                        });
                                        _pageScrollController.animateToPage(1,
                                            duration: const Duration(
                                                milliseconds: 1500),
                                            curve: Curves.decelerate);
                                      } else {
                                        UserReplyWindows()
                                            .showSnackBar(res['msg'], "error");
                                      }
                                    } else {
                                      DateTime nowDate = DateTime.now();
                                      int dateInms = DateTime(nowDate.year,
                                              nowDate.month, nowDate.day)
                                          .millisecondsSinceEpoch;
                                      int checker = dataProvider.evaluations
                                          .indexWhere((el) =>
                                              (el['dateUploaded'] == dateInms &&
                                                  el['uploaderId'] ==
                                                      dataProvider
                                                          .userData['id'] &&
                                                  el['courseId'] ==
                                                      _courses[index]['id']));
                                      if (checker > 0) {
                                        UserReplyWindows().showSnackBar(
                                            "Only one evaluation per day",
                                            "error");
                                      } else {
                                        setState(() {
                                          _courseToEvaluate = _courses[index];
                                          print(_courseToEvaluate);
                                        });
                                        _pageScrollController.animateToPage(1,
                                            duration: const Duration(
                                                milliseconds: 1500),
                                            curve: Curves.decelerate);
                                      }
                                    }
                                  },
                                  child: Text(_courses[index]['lable'])),
                            );
                          }),
            ),
          ),
        ],
      ),
    );
  }

  Widget courseEvaluationPage() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Write evaluation for ${_courseToEvaluate['lable']} course",
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text("${_courseToEvaluate['name']}"),
                const SizedBox(
                  height: 10,
                ),
                Column(
                    children:
                        List<Widget>.generate(_courseQuestions.length, (index) {
                  var e = _courseQuestions[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: appColor, width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e['qn'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: excellenceLevel.map((el) {
                              int ind = excellenceLevel
                                  .indexWhere((element) => element == el);
                              return OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: appColor),
                                      backgroundColor:
                                          _courseQuestions[index]['ans'] == el
                                              ? excellenceLevelColors[ind]
                                              : whiteColor),
                                  onPressed: () {
                                    setState(() {
                                      _courseQuestions[index]['ans'] = el;
                                    });
                                  },
                                  child: Text(
                                    el,
                                    maxLines: 1,
                                  ));
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                })),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed: () async {
                  if (_courseQuestions.every(
                      (el) => el['ans'].toString().trim().isNotEmpty == true)) {
                    var evalData = {
                      "uploaderId": dataProvider.userData['id'],
                      "collageId": dataProvider.userData['collageId'],
                      "departmentId": dataProvider.userData['departmentId'],
                      "courseId": _courseToEvaluate['id'],
                      "for": "course",
                      "courseCode": _courseToEvaluate['lable'],
                      "student": dataProvider.userData,
                      "instructorId": courseInstructor['id']
                    };

                    for (var i = 0; i < _courseQuestions.length; i++) {
                      evalData[i.toString()] = _courseQuestions[i]['ans'];
                    }
                    //print(evalData);
                    UserReplyWindows().showLoadingDialog(context);
                    var res = await DatabaseApi().uploadToFirestore(evalData);
                    Navigator.pop(context);
                    if (res['msg'] == "done") {
                      UserReplyWindows().showSnackBar(
                          "Evaluation posted successful..", "info");
                      Navigator.pop(context);
                    } else {
                      UserReplyWindows().showSnackBar(res['msg'], "error");
                    }
                  } else {
                    EasyLoading.showToast("Please fill all fields!!");
                  }
                },
                child: const Text("Submit")),
          )
        ],
      ),
    );
  }

  int currentQuestion = -1;
  Widget instEvaluationPage() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 10, right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Write evaluation for ${courseInstructor['userName']} in ${_courseToEvaluate['lable']}",
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                Text(
                  "${dataProvider.userData['departmentName'].toString()} Department",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: appColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Text(
                        courseInstructor.isNotEmpty
                            ? courseInstructor['userName']
                            : "Select instructor",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                    children: List<Widget>.generate(_instrctQuestions.length,
                        (index) {
                  var e = _instrctQuestions[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: appColor, width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e['qn'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: excellenceLevel.map((el) {
                              int ind = excellenceLevel
                                  .indexWhere((element) => element == el);
                              return OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: appColor),
                                      backgroundColor:
                                          _instrctQuestions[index]['ans'] == el
                                              ? excellenceLevelColors[ind]
                                              : whiteColor),
                                  onPressed: () {
                                    setState(() {
                                      _instrctQuestions[index]['ans'] = el;
                                    });
                                  },
                                  child: Text(
                                    el,
                                    maxLines: 1,
                                  ));
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                })),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                onPressed: () async {
                  if (courseInstructor.isNotEmpty &&
                      _instrctQuestions.every((el) =>
                          el['ans'].toString().trim().isNotEmpty == true)) {
                    var evalData = {
                      "uploaderId": dataProvider.userData['id'],
                      "collageId": dataProvider.userData['collageId'],
                      "departmentId": dataProvider.userData['departmentId'],
                      "courseId": _courseToEvaluate['id'],
                      "courseCode": _courseToEvaluate['lable'],
                      "for": "instructor",
                      "instructorId": courseInstructor['id'],
                      "instructorName": courseInstructor['userName'],
                    };

                    for (var i = 0; i < _instrctQuestions.length; i++) {
                      evalData[i.toString()] = _instrctQuestions[i]['ans'];
                    }
                    //print(evalData);
                    UserReplyWindows().showLoadingDialog(context);
                    var res = await DatabaseApi().uploadToFirestore(evalData);
                    Navigator.pop(context);
                    if (res['msg'] == "done") {
                      List evals = dataProvider.evaluations;
                      evals.add(res['data']);
                      dataProvider.evaluations = evals;
                      setState(() {});
                      UserReplyWindows().showSnackBar(
                          "Evaluation posted successful..", "info");
                      Navigator.pop(context);
                    } else {
                      UserReplyWindows().showSnackBar(res['msg'], "error");
                    }
                  } else {
                    EasyLoading.showToast("Please fill all fields!!");
                  }
                },
                child: const Text("Submit")),
          )
        ],
      ),
    );
  }

  instructorSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadow(blurRadius: 2)]),
            child: TextFormField(
              onFieldSubmitted: (value) {
                _getInstructor(value);
              },
              onChanged: (value) {
                _getInstructor(value);
              },
              //controller: _searchTxtController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  hintText: "Type instructor name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
          ),
          const SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Divider(
                height: 3,
                color: blackColor,
              ),
              Container(
                  color: whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    children: [
                      Text("Instructors from".toUpperCase()),
                      Text(dataProvider.userData['lable'] == "principle"
                          ? dataProvider.userData['collageName']
                          : "${dataProvider.userData['departmentName']} department"),
                    ],
                  )),
            ],
          ),
          Expanded(
              child: _instructors.isEmpty
                  ? const Center(child: Text("No matching instructor!!"))
                  : ListView.builder(
                      itemCount: _instructors.length,
                      padding: const EdgeInsets.only(top: 0),
                      itemBuilder: (context, index) {
                        var instructor = _instructors[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              color: whiteColor, border: Border.all()),
                          child: ListTile(
                            onTap: () {
                              DateTime nowDate = DateTime.now();
                              int dateInms = DateTime(
                                      nowDate.year, nowDate.month, nowDate.day)
                                  .millisecondsSinceEpoch;
                              print(dataProvider.evaluations);
                              int checker = dataProvider.evaluations.indexWhere(
                                  (el) => (el['dateUploaded'] == dateInms &&
                                      el['uploaderId'] ==
                                          dataProvider.userData['id'] &&
                                      el['instructorId'] == instructor['id']));
                              if (checker > 0) {
                                UserReplyWindows().showSnackBar(
                                    "Only one evaluation per day", "error");
                              } else {
                                setState(() {
                                  courseInstructor = instructor;
                                });
                                _pageScrollController.animateToPage(1,
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    curve: Curves.decelerate);
                              }
                            },
                            contentPadding: const EdgeInsets.only(left: 5),
                            visualDensity: const VisualDensity(
                                horizontal: -3, vertical: -3),
                            leading: const Icon(
                              Icons.person_pin,
                              size: 40,
                            ),
                            title: Text(instructor['userName']),
                            subtitle: Text(instructor['firstName'] +
                                " " +
                                instructor['lastName']),
                          ),
                        );
                      }))
        ],
      ),
    );
  }
}
