import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'common_variables.dart';

class DatabaseApi {
  final _auth = FirebaseAuth.instance;
  final _usersRef = FirebaseFirestore.instance.collection("USERS");
  final _collagesRef = FirebaseFirestore.instance.collection("COLLAGES");
  final _departmentsRef = FirebaseFirestore.instance.collection("DEPARTMENTS");
  final _storageRef = FirebaseStorage.instance.ref("ITEM IMAGES");
  final _programsRef = FirebaseFirestore.instance.collection("PROGRAMS");
  final _coursesRef = FirebaseFirestore.instance.collection("COURSES");
  final _itemsRef = FirebaseFirestore.instance.collection("ITEMS");
  final _evaluationsRef = FirebaseFirestore.instance.collection("EVALUATIONS");
  final _attendanceRef = FirebaseFirestore.instance.collection("ATTENDANCE");

  Future<Map<String, dynamic>> updateSolvedStatus(String evaluationId) async {
    Map<String, dynamic> result = {};
    await _evaluationsRef
        .doc(evaluationId)
        .update({"isSolved": true}).then((value) {
      result = {"msg": "done"};
    }).catchError((err) {
      result = {"msg": err.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> deleteEvaluation(String evaluationId) async {
    Map<String, dynamic> result = {};
    await _evaluationsRef.doc(evaluationId).delete().then((value) {
      result = {"msg": "done"};
    }).catchError((err) {
      result = {"msg": err.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> signInUser(
      Map<String, dynamic> loginCredenctials) async {
    Map<String, dynamic> result = {};
    var field = "regNumber";
    if (EmailValidator.validate(loginCredenctials['userName'])) {
      field = "email";
    }
    await _usersRef
        .where(field, isEqualTo: loginCredenctials['userName'])
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        var user = value.docs[0].data();
        if (user['isRegistered'] == true) {
          result = await signInOldUser(user, loginCredenctials['password']);
        } else {
          if (loginCredenctials['password'] == user['phoneNumber']) {
            await _auth
                .signInWithEmailAndPassword(
                    email: user['email'], password: user['phoneNumber'])
                .then((value) {
              result = {"msg": "update-password", "data": user};
            }).catchError((e) {
              result = {"msg": e.code};
            });
          } else {
            result = {"msg": "Incorrect password!!"};
          }
        }
      } else {
        result = {"msg": "Incorrect user credentials!!"};
      }
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> inserUsers() async {
    Map<String, dynamic> result = {};
    List users = [];
    int i = 0;
    for (var el in dteUsers) {
      await _auth
          .createUserWithEmailAndPassword(
              email: el['email'], password: el['phoneNumber'])
          .then((value) async {
        var uid = value.user!.uid;
        el['id'] = uid;
        await _usersRef.doc(uid).set(el).then((value) {
          users.add({"name": el["firstName"], "id": el["id"]});
        }).catchError((e) {
          result = {'msg': e.code};
        });
      }).catchError((e) {
        result = {'msg': e.code};
      });
      i++;
    }
    result['data'] = users;
    return result;
  }

  Future<Map<String, dynamic>> getInstructors(var userData) async {
    Map<String, dynamic> result = {};
    Query<Map<String, dynamic>> ref =
        _usersRef.where("collageId", isEqualTo: userData['collageId']);
    if (userData["lable"] == "hod" || userData["lable"] == "student") {
      ref = ref.where("departmentId", isEqualTo: userData['departmentId']);
    }
    await ref.where("lable", isEqualTo: 'instructor').get().then((value) {
      if (value.docs.isNotEmpty) {
        List<Map<String, dynamic>> instr = [];
        for (var el in value.docs) {
          var data = el.data();
          instr.add(data);
        }
        result = {"msg": "done", "data": instr};
      } else {
        result = {"msg": "No course found!!"};
      }
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> getCoursesAttendance(var courseId) async {
    Map<String, dynamic> result = {};
    await _attendanceRef
        .where('courseId', isEqualTo: courseId)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        List<Map<String, dynamic>> attendances = [];
        for (var element in value.docs) {
          attendances.add(element.data());
        }
        result = {"msg": "done", "data": attendances};
      } else {
        result = {"msg": "Sorry,No instructor assigned!!"};
      }
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> getAllCourses() async {
    Map<String, dynamic> result = {};
    await _coursesRef.get().then((value) {
      if (value.docs.isNotEmpty) {
        List<Map<String, dynamic>> courses = [];
        for (var element in value.docs) {
          courses.add(element.data());
        }
        result = {"msg": "done", "data": courses};
      } else {
        result = {"msg": "Sorry,No instructor assigned!!"};
      }
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> getCourseInstructor(var instructorId) async {
    Map<String, dynamic> result = {};
    await _usersRef.where("id", isEqualTo: instructorId).get().then((value) {
      if (value.docs.isNotEmpty) {
        result = {"msg": "done", "data": value.docs[0].data()};
      } else {
        result = {"msg": "Sorry,No instructor assigned!!"};
      }
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> getInstructorCourses(var instructor) async {
    Map<String, dynamic> result = {};
    await _coursesRef
        .where("instructorId", isEqualTo: instructor['id'])
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        print(value.docs.length);
        List<Map<String, dynamic>> crs = [];
        for (var el in value.docs) {
          var data = el.data();
          crs.add(data);
        }
        result = {"msg": "done", "data": crs};
      } else {
        result = {"msg": "No course found for ${instructor['userName']}!!"};
      }
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> getStudentCourses(var student) async {
    Map<String, dynamic> result = {};
    //print(student);
    await _coursesRef
       .where("stoodBy", arrayContains:student['programLable'].toString()+student['yOS'].toString()+"2")
        // .where("stoodBy", arrayContains: "BSC-CS32")
        .get()
        .then((value){
      if (value.docs.isNotEmpty) {
        List<Map<String, dynamic>> crs = [];
        for (var el in value.docs) {
          var data = el.data();
          crs.add(data);
        }
        result = {"msg": "done", "data": crs};
      } else {
        result = {"msg": "No course found for ${student['programLable']}!!"};
      }
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> insertCollages() async {
    Map<String, dynamic> result = {};
    List courses = [];
    int i = 0;
    //{"subject":["IA 124"]},
    List<Map<String, dynamic>> teachersSubjects = [
      {"user": "IgrSVtfAnKQlV3fdyN25RjArc0U2", "subject": "CP 422"},
      {"user": "ZNhREktR0xbE0r1xuEdS1d0VRHC3", "subject": "CP 424"},
      {"user": "0ebGy99c7nUXHtnu6HL1cMdY86z2", "subject": "CP 323"},
      {"user": "mF77LXjQ3WVsKBV5vPLpuOrgaaC3", "subject": "CP 324"},
      {"user": "cKfCPKPqGHhxt8Jks6ZoyQf5Wys2", "subject": "CP 322"},
      {"user": "5CHpmySxJ0Vw1957KdNle5fp42X2", "subject": "CP 423"},
      {"user": "IjNWMzDZb5ZRvZD1hEY8NdUbQSA3", "subject": "CS 123"},
      {"user": "IjNWMzDZb5ZRvZD1hEY8NdUbQSA3", "subject": "IA 124"},
      {"user": "fRQU7uUCbMYuBGnH2tDMI1hddz22", "subject": "MT 1211"},
      {"user": "C9F78pQrDnfIKK0qxpCEaYa6HWw2", "subject": "CP 123"},
      {"user": "bYZMp31Q39OPGQVKbBtmoD8O9DK2", "subject": "CP 121"},
      {"user": "DjfrHjdJHIPJ3n0JPW0T1mcnj132", "subject": "CN 121"},
      {"user": "jUSAqHatWCXlllMybNvknhUyDok1", "subject": "CG 121"},
      {"user": "pVHe2yNJEvZtmjrOWjB5wf6C0zb2", "subject": "ST 1210"}
    ];
    for (var el in teachersSubjects) {
      await _coursesRef
          .where("lable", isEqualTo: el["subject"])
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          var data = value.docs[0].data();
          await _coursesRef
              .doc(data['id'])
              .update({'instructorId': el['user']}).then((value) {
            i++;
          });
        }
      });
    }
    print("Total $i");
    return result;
  }

  Future<Map<String, dynamic>> signInOldUser(
      Map<String, dynamic> user, password) async {
    Map<String, dynamic> result = {};
    await _auth
        .signInWithEmailAndPassword(email: user['email'], password: password)
        .then((value) {
      result = {"msg": "done", "data": user};
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> updatePassword(var user, String psw) async {
    Map<String, dynamic> result = {};
    print("updating..");
    await _auth.currentUser!
        .reauthenticateWithCredential(EmailAuthProvider.credential(
            email: user['email'],
            password: user['password'] ?? user['phoneNumber']))
        .then((value) async {
      await _auth.currentUser!.updatePassword(psw).then((value) async {
        await _usersRef
            .doc(_auth.currentUser!.uid)
            .update({"isRegistered": true}).then((value) {
          result = {"msg": "done"};
        }).catchError((e) {
          result = {"msg": e.code};
        });
      }).catchError((e) {
        result = {"msg": e.code};
      });
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> getAddtionalUserInfo(var userInfo) async {
    Map<String, dynamic> userInfo2 = {};
    await _collagesRef.doc(userInfo['collageId']).get().then((value) {
      if (value.data()!.isNotEmpty) {
        userInfo2['collageName'] = value.data()!['name'];
      }
    });
    if (userInfo['lable'] != "principle" &&
        userInfo['lable'] != "assetmanager") {
      await _departmentsRef.doc(userInfo['departmentId']).get().then((value) {
        if (value.data()!.isNotEmpty) {
          userInfo2['departmentName'] = value.data()!['name'];
        }
      });
    }
    if (userInfo['lable'] == "student") {
      await _programsRef.doc(userInfo['programId']).get().then((value) {
        if (value.data()!.isNotEmpty) {
          userInfo2['programName'] = value.data()!['name'];
          userInfo2['programLable'] = value.data()!['lable'];
        }
      });
    }
    //print(userInfo2);
    return userInfo2;
  }

  Future<Map<String, dynamic>> checkForCurrentUser() async {
    Map<String, dynamic> result = {};
    if (_auth.currentUser != null) {
      await _usersRef.doc(_auth.currentUser!.uid).get().then((value) {
        result = {"msg": "user-found", "data": value.data()};
      }).catchError((e) {
        result = {"msg": e.code};
      });
    } else {
      result = {"msg": "no-user-found"};
    }
    return result;
  }

  getSchoolItems() async {
    List result = [];
    for (var el in (await _itemsRef.get()).docs) {
      result.add(el.data());
    }
    return result;
  }

  Future<Map<String, dynamic>> signOutUser() async {
    Map<String, dynamic> result = {};
    await _auth.signOut().then((value) {
      result = {"msg": "done"};
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> uploadToFirestore(
      Map<String, dynamic> itemData) async {
    Map<String, dynamic> result = {};
    itemData['id'] = _evaluationsRef.doc().id;
    DateTime nowDate = DateTime.now();
    int dateInms = DateTime(nowDate.year, nowDate.month, nowDate.day)
        .millisecondsSinceEpoch;
    itemData['dateUploaded'] = dateInms;
    await _evaluationsRef.doc(itemData['id']).set(itemData).then((value) async {
      if (itemData['for'] == "course") {
        var studentData = itemData['student'];
        var attenId = _attendanceRef.doc().id;
        var attenData = {
          "id": attenId,
          "courseId": itemData['courseId'],
          "courseCode": itemData['courseCode'],
          "dateUploaded": dateInms,
          "instructorId": itemData['instructorId'],
          "studentId": studentData['id'],
          "studentRegNo": studentData['regNumber'],
          "studentName":
              "${studentData['firstName']} ${studentData['lastName']}"
        };
        await _attendanceRef.doc(attenId).set(attenData).then((value) {
          result = {"msg": "done", "data": itemData};
        }).catchError((e) {
          result = {"msg": e.code};
        });
      } else {
        result = {"msg": "done", "data": itemData};
      }
    }).catchError((e) {
      result = {"msg": e.toString()};
    });
    return result;
  }

  Future<Map<String, dynamic>> getEvaluation(
      Map<String, dynamic> filter) async {
    Map<String, dynamic> result = {};
    List<Map<String, dynamic>> data = [];
    var query =
        _evaluationsRef.where("collageId", isEqualTo: filter["collageId"]);

    await query.get().then((value) {
      if (value.docs.isNotEmpty) {
        for (var el in value.docs) {
          data.add(el.data());
        }
        result = {"msg": "done", "data": data};
      } else {
        result = {"msg": "No details found"};
      }
    }).catchError((e) {
      result = {"msg": e.code};
    });
    return result;
  }

  Future<Map<String, dynamic>> resetForgotPassword(String data) async {
    Map<String, dynamic> result = {};
    String email = "";
    if (EmailValidator.validate(data)) {
      email = data;
    } else {
      await _usersRef.where("regNumber", isEqualTo: data).get().then((value) {
        if (value.docs.isNotEmpty) {
          email = value.docs[0].data()['email'];
        } else {
          result = {'msg': "Incorrect registration number"};
        }
      }).catchError((e) {
        result = {'msg': e.toString()};
      });
    }
    if (email.isNotEmpty) {
      await _usersRef
          .where("email", isEqualTo: email)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await _auth.sendPasswordResetEmail(email: email).then((value) {
            result = {'msg': 'done'};
          }).catchError((e) {
            result = {'msg': e.code};
          });
        } else {
          result = {'msg': "Incorrect email address"};
        }
      }).catchError((e) {
        result = {'msg': e.toString()};
      });
    }

    return result;
  }

  Future<Map<String, dynamic>> uploadimage(File file) async {
    Map<String, dynamic> result = {};
    print("Uploading");
    await _storageRef
        .child("image")
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(file)
        .then((p0) async {
      await p0.ref.getDownloadURL().then((value) {
        result = {"msg": "done $value"};
      }).catchError((e) {
        result = {"msg": e.toString()};
      });
    }).catchError((e) {
      result = {"msg": e.toString()};
    });

    return result;
  }
}
