import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:udomdte/app_services/common_variables.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../app_services/provider_services.dart';
import '../../app_services/user_reply_windows_services.dart';

class SpecificCourseEvaluationListScreen extends StatefulWidget {
  var course;
  Map<String, dynamic> dates;
  SpecificCourseEvaluationListScreen(this.course, this.dates, {super.key});

  @override
  State<SpecificCourseEvaluationListScreen> createState() =>
      _SpecificCourseEvaluationListScreenState();
}

class _SpecificCourseEvaluationListScreenState
    extends State<SpecificCourseEvaluationListScreen> {
  bool _isLoading = true;
  late DataProvider dataProvider;
  late void Function(void Function()) _stateSetter;
  final pdfDoc = pw.Document();
  final Map<String, int> _performanceStatistics = {
    "Excellent": 0,
    "Very good": 0,
    "Satisfactory": 0,
    "Poor": 0,
    "Very poor": 0,
    "Not applicable": 0
  };

  List<Map<String, dynamic>> _evaluations = [];
  getItemEvaluations(Map<String, dynamic> filter) async {
    setState(() {
      _isLoading = true;
      _evaluations = [];
    });
    bool fit = false;
    if (filter.isNotEmpty) {
      fit = true;
    }

    if (dataProvider.evaluations.isNotEmpty) {
      for (var el in dataProvider.evaluations) {
        bool yes = false;
        DateTime uploadedDate =
            DateTime.fromMillisecondsSinceEpoch(el['dateUploaded']);
        DateTime startDate =
            DateTime.fromMillisecondsSinceEpoch(widget.dates['startDate']);
        int res = uploadedDate.compareTo(startDate);
        if (widget.dates['endDate'] == null) {
          if (res == 0) {
            yes = true;
          }
          if (res > 0) {
            yes = true;
          }
        } else {
          DateTime endDate =
              DateTime.fromMillisecondsSinceEpoch(widget.dates['endDate']);
          int start = uploadedDate.compareTo(startDate);
          int end = uploadedDate.compareTo(endDate);
          if (start == 0 && end == 0) {
            yes = true;
          }
          if (start > 0 && end < 0) {
            yes = true;
          }
        }
        if (el['for'] == "course" &&
            el['courseId'] == widget.course['id'] &&
            yes == true) {
          if (dataProvider.userData["lable"] == "hod") {
            if (el['departmentId'] == dataProvider.userData["departmentId"]) {
              _evaluations.add(el);
            }
          } else {
            _evaluations.add(el);
          }
        }
      }
      if (_evaluations.isNotEmpty) {
        getPdfDoc();
      }
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  getPdfDoc() async {
    pdfDoc.addPage(pw.Page(build: (pw.Context context) {
      return pw.Container(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
            pw.Text(
              "UDOM DAILY TEACHING EVALUATION SYSTEM",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
            ),
            pw.Text(
              "Evaluations for ${widget.course['lable']}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              "Total evaluations: ${_evaluations.length}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
            ),
            pw.Expanded(
                  child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: courseQuestions.map((el) {
                        int index = courseQuestions.indexOf(el);
                        var question = courseQuestions[index];
                        return pw.Container(
                          child: pw.Column(
                            children: [
                              pw.Text(
                                "Qn:" +
                                    (index + 1).toString() +
                                    " " +
                                    question['qn'],
                                style: pw.TextStyle(
                                    fontSize: 13,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.SizedBox(
                                  height: 100,
                                  child: pw.GridView(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1,
                                      childAspectRatio: 4.5,
                                      children: excellenceLevel.map((e) {
                                        int ind = excellenceLevel.indexOf(e);
                                        int count = 0;
                                        for (var i = 0;
                                            i < _evaluations.length;
                                            i++) {
                                          var qn = _evaluations[i];
                                          //print(qn);
                                          if (qn[index.toString()] ==
                                              excellenceLevel[ind]) {
                                            count++;
                                          }
                                        }
                                        return pw.Container(
                                          padding: pw.EdgeInsets.all(2),
                                          decoration: pw.BoxDecoration(
                                              border: pw.Border.all()),
                                          child: pw.Align(
                                            alignment: pw.Alignment.centerLeft,
                                            child: pw.Text(excellenceLevel[
                                                    ind] +
                                                ": ${count}(${(count / _evaluations.length * 100).toStringAsFixed(2)}%)"),
                                          ),
                                        );
                                      }).toList()))
                            ],
                          ),
                        );
                      }).toList())),
          ]));
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      getItemEvaluations({});
    });

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
        appBar: AppBar(
            title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(widget.course['lable']),
            const Icon(
              Icons.circle,
              color: Colors.blue,
              size: 10,
            ),
            Expanded(
                child: Text(
              widget.course['name'],
              style: const TextStyle(fontSize: 10),
            ))
          ],
        )),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _evaluations.isEmpty
                      ? const Center(child: Text("No evaluations found"))
                      : Column(
                          children: [
                            Text(
                              "Total evaluations: ${_evaluations.length}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Expanded(
                              child: Builder(builder: (context) {
                                return ListView.builder(
                                    itemCount: courseQuestions.length,
                                    itemBuilder: (context, index) {
                                      var question = courseQuestions[index];
                                      int total = 0;
                                      return ExpansionTile(
                                        tilePadding: const EdgeInsets.all(1),
                                        initiallyExpanded:
                                            index == 0 ? true : false,
                                        title: Container(
                                          child: Text(
                                            "Qn:" +
                                                (index + 1).toString() +
                                                " " +
                                                question['qn'],
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        children: [
                                          GridView.builder(
                                              shrinkWrap: true,
                                              controller: ScrollController(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      mainAxisSpacing: 1,
                                                      crossAxisSpacing: 1,
                                                      childAspectRatio: 4.5),
                                              padding: const EdgeInsets.all(5),
                                              itemCount: excellenceLevel.length,
                                              itemBuilder: (context, ind) {
                                                int count = 0;
                                                for (var i = 0;
                                                    i < _evaluations.length;
                                                    i++) {
                                                  var qn = _evaluations[i];
                                                  //print(qn);
                                                  if (qn[index.toString()] ==
                                                      excellenceLevel[ind]) {
                                                    count++;
                                                  }
                                                }
                                                return Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      border: Border.all()),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(excellenceLevel[
                                                            ind] +
                                                        ": ${count}(${(count / _evaluations.length * 100).toStringAsFixed(2)}%)"),
                                                  ),
                                                );
                                              }),
                                        ],
                                      );
                                    });                              ;
                              }),
                            ),
                          ],
                        ),
            ),
            Positioned(
              bottom: 10,
              child: _evaluations.isEmpty
                  ? Container()
                  : FloatingActionButton(
                      onPressed: () {
                        UserReplyWindows().showLoadingDialog(context);
                        saveFiletoStorage();
                        Navigator.pop(context);
                      },
                      mini: true,
                      backgroundColor: greenColor,
                      child: const Icon(Icons.file_download),
                    ),
            )
          ],
        ));
  }

  Future<void> saveFiletoStorage() async {
    final expath =
        Directory("/storage/emulated/0/Download/UdomDte/Evaluations").path;
    try {
      final status = await Permission.storage.status;
      //print(status.name);
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      await Directory(expath).create(recursive: true).then((value) async {
        File file =
            File("$expath/${DateTime.now().millisecondsSinceEpoch}.pdf");
        file.writeAsBytesSync(await pdfDoc.save());
        UserReplyWindows()
            .showSnackBar("File saved to downloads folder..", "info");
      });
    } catch (err) {
      UserReplyWindows().showSnackBar(err.toString(), "error");
    }
  }
}
