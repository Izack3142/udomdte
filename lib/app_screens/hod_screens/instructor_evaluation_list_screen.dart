import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:udomdte/app_screens/hod_screens/specific_instructor_evaluations.dart';
import 'package:udomdte/app_services/common_variables.dart';

import '../../app_services/database_services.dart';
import '../../app_services/provider_services.dart';
import '../../app_services/user_reply_windows_services.dart';

class InstructorEvaluationListScreen extends StatefulWidget {
  const InstructorEvaluationListScreen({super.key});

  @override
  State<InstructorEvaluationListScreen> createState() =>
      _InstructorEvaluationListScreenState();
}

class _InstructorEvaluationListScreenState
    extends State<InstructorEvaluationListScreen> {
  bool _isLoading = false;
  Map<String, dynamic> _selectedInstructor = {};
  Map<String, dynamic> _selectedCourse = {};
  late DataProvider dataProvider;
  List<Map<String, dynamic>> instructorEvaluations = [];
  final List<Map<String, dynamic>> _instructors = [];
  final _searchTxtController = TextEditingController();
  final Map<String, dynamic> _dates = {};
  late void Function(void Function()) _stateSetter;

  void conditionalStateSetter() {
    setState(() {});
  }

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

  getItemEvaluations(Map<String, dynamic> filter) async {
    setState(() {
      _isLoading = true;
      instructorEvaluations = [];
    });
    bool fit = false;
    if (filter.isNotEmpty) {
      fit = true;
    }

    if (dataProvider.evaluations.isNotEmpty) {
      for (var el in dataProvider.evaluations) {
        if (el['for'] == "instructor") {
          if (dataProvider.userData["lable"] == "hod") {
            if (el['departmentId'] == dataProvider.userData["departmentId"]) {
              instructorEvaluations.add(el);
            }
          } else {
            instructorEvaluations.add(el);
          }
        }
      }

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dataProvider = Provider.of<DataProvider>(context);
    return Column(
      children: [
        AppBar(
          elevation: 0,
          title: const Text("Instructor evaluations"),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25)),
                boxShadow: const [BoxShadow(blurRadius: 8)]),
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
                                  onTap: () async {
                                    _selectedInstructor = instructor;
                                    UserReplyWindows()
                                        .showLoadingDialog(context);
                                    var res = await DatabaseApi()
                                        .getInstructorCourses(instructor);
                                    Navigator.pop(context);
                                    if (res['msg'] == "done") {
                                      showCourseDialog(
                                          _selectedInstructor, res['data']);
                                    } else {
                                      UserReplyWindows()
                                          .showSnackBar(res['msg'], "error");
                                    }
                                  },
                                  contentPadding:
                                      const EdgeInsets.only(left: 5),
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
          ),
        )
      ],
    );
  }

  void _showDatepickerBottomsheet() {
    String selectedExcellenceLevel = "";
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (context) {
          return StatefulBuilder(builder: (context, stateSetter) {
            _stateSetter = stateSetter;
            late String startDate, endDate;
            if (_dates['startDate'] != null) {
              startDate = DateFormat("dd/MM/yyyy").format(
                  DateTime.fromMillisecondsSinceEpoch(_dates['startDate']));
            }
            if (_dates['endDate'] != null) {
              endDate = DateFormat("dd/MM/yyyy").format(
                  DateTime.fromMillisecondsSinceEpoch(_dates['endDate']));
            }
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                      child: Text(
                    "Select date interval",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              _pickDate("startDate");
                            },
                            child: Text(_dates['startDate'] != null
                                ? startDate
                                : "Start date")),
                        const Text("To"),
                        OutlinedButton(
                            onPressed: () {
                              if (_dates["startDate"] != null) {
                                _pickDate("endDate");
                              } else {
                                UserReplyWindows().showSnackBar(
                                    "Start date is needed first!!", "error");
                              }
                            },
                            child: Text(_dates['endDate'] != null
                                ? endDate
                                : "End date"))
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_dates['startDate'] != null) {
                          Navigator.pop(context);
                          UserReplyWindows().navigateScreen(
                              context,
                              SpecificInstructorEvaluationListScreen(
                                  _selectedInstructor,
                                  _dates,
                                  _selectedCourse));
                        } else {
                          UserReplyWindows()
                              .showSnackBar("Start date is needed!!", "error");
                        }
                      },
                      child: const Text("Get evaluations"))
                ],
              ),
            );
          });
        });
  }

  void _pickDate(String s) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: s == "endDate"
            ? DateTime.fromMillisecondsSinceEpoch(_dates['startDate'])
            : DateTime.now(),
        firstDate: s == "endDate"
            ? DateTime.fromMillisecondsSinceEpoch(_dates['startDate'])
            : DateTime(2022),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      _stateSetter(() {
        _dates[s] = pickedDate.millisecondsSinceEpoch;
      });
    }
  }

  void showCourseDialog(var instructor, List<Map<String, dynamic>> courses) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Select course"),
            content: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5),
                padding: const EdgeInsets.all(5),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return ShowUpAnimation(
                    animationDuration: const Duration(milliseconds: 500),
                    delayStart: Duration(milliseconds: 50 * index),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 91, 59, 185)),
                        onPressed: () async {
                          _selectedCourse = courses[index];
                          Navigator.pop(context);
                          _showDatepickerBottomsheet();
                        },
                        child: Text(courses[index]['lable'])),
                  );
                }),
          );
        });
  }
}
