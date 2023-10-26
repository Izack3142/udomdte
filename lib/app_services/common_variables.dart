import 'package:flutter/material.dart';

var whiteColor=Colors.white;
var appColor=const Color(0xFF003151);
var blackColor=Colors.black;
const greenColor=Colors.green;
const redColor=Colors.red;
const yellow=Colors.yellow;
const greyColor=Colors.grey;

List<String> schoolItems=["Chair","Table","Door","Window","Projector","Computer","Network facility","Building","Toilet facility","Fire extinguisher","Lights","Electric system"];

List<Map<String,dynamic>> courseQuestions=[
 {
  "qn":"How well did the instructor explain concepts and provide examples for the class",
  "ans":""
 },
  {
  "qn":"How well did the pace of the class suits your learning style and grasping of material",
  "ans":""
 },
 {
  "qn":"The extent to which practical activities were used to complement understanding of the course",
  "ans":""
 },
  {
  "qn":"How well was the class covered as per course carriculum",
  "ans":""
 },
 {
  "qn":"How well did the instructor address your questions and concerns during class",
  "ans":""
 },
 {
  "qn":"How well is your overall engagement and attentiveness during class sessions",
  "ans":""
 },
 {
  "qn":"How well were the learning objectives for the day defined and achieved",
  "ans":""
 },
 {
  "qn":"How well were the learning materials helpful and relevant to the topic",
  "ans":""
 }
];
 
List<Map<String,dynamic>> instrctQuestions=[
 {
  "qn":"The instructor clearly stated objectives of the course",
  "ans":""
 },
 {
  "qn":"Instructor's mode of delivery of the subject matter",
  "ans":""
 },
 {
  "qn":"Instructor's fairness in grading of assignments",
  "ans":""
 },
 {
  "qn":"Instructor's capacity to provide timely feedback on assignments",
  "ans":""
 },
 {
  "qn":"Instructor's attendance in the class",
  "ans":""
 },
 {
  "qn":"Instructor's punctuality in the class",
  "ans":""
 },
 {
  "qn":"Instructor was friendly and accessible to student leaning needs",
  "ans":""
 },
 {
  "qn":"The extent to which the instructor engaged student participation in the class",
  "ans":""
 },
 {
  "qn":"The instructor demonstrated self-respect and integrity",
  "ans":""
 }
];


  List dteUsers=[ 
    //cp 422
    {
      "firstName":"Thomas",
      "middleName":"",
      "lastName":"Tesha",
      "userName":"Mr Thomas Tesha",
      "phoneNumber":"0710807193",
      "email":"thomastesha@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    }, 
    //cp 424
    {
      "firstName":"Jehovajire",
      "middleName":"",
      "lastName":"",
      "userName":"Dr Jehovajire",
      "phoneNumber":"0710807002",
      "email":"jehovajire@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //cp 323
    {
      "firstName":"Abraham",
      "middleName":"",
      "lastName":"Macha",
      "userName":"Mr Macha",
      "phoneNumber":"0713507002",
      "email":"abhmacha@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //cp 324
    {
      "firstName":"Justine",
      "middleName":"",
      "lastName":"Woiso",
      "userName":"Mr Woiso",
      "phoneNumber":"0710816002",
      "email":"jstwoiso@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //cp 322
    {
      "firstName":"Salim",
      "middleName":"",
      "lastName":"Diwani",
      "userName":"Mr Diwani",
      "phoneNumber":"0710888002",
      "email":"slmdiwani@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //cp 423
    {
      "firstName":"Gilbert",
      "middleName":"",
      "lastName":"",
      "userName":"Dr Gilbert",
      "phoneNumber":"0710809702",
      "email":"gilbert@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //cs 123,ia124
    {
      "firstName":"Hamis",
      "middleName":"",
      "lastName":"Fereji",
      "userName":"Mr Fereji",
      "phoneNumber":"0719807902",
      "email":"fereji@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //mt1211
    {
      "firstName":"Sholastica",
      "middleName":"",
      "lastName":"Luambano",
      "userName":"Luambano",
      "phoneNumber":"0710878002",
      "email":"sltluambano@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //cp 123
    {
      "firstName":"Izack",
      "middleName":"",
      "lastName":"Mahenge",
      "userName":"Mr Isack",
      "phoneNumber":"0711801232",
      "email":"iscmahenge@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //cp 121
    {
      "firstName":"Everinjius",
      "middleName":"",
      "lastName":"Barongo",
      "userName":"Mr Barongo",
      "phoneNumber":"0710807232",
      "email":"barongo@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //cn 121
    {
      "firstName":"David",
      "middleName":"",
      "lastName":"Kitomari",
      "userName":"Mr David",
      "phoneNumber":"0710807342",
      "email":"dvdkitomari@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //cg 121
    {
      "firstName":"Majuto",
      "middleName":"",
      "lastName":"Manyilizu",
      "userName":"Dr Manyilizu",
      "phoneNumber":"0710807302",
      "email":"mjtmanyilizu@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
    //st 1210
    {
      "firstName":"Steven",
      "middleName":"",
      "lastName":"Edward",
      "userName":"Mr Edward",
      "phoneNumber":"0710801112",
      "email":"stvedward@udom.ac.tz",
      "lable":"instructor",
      "isRegistered":"false",
      "collageId":"3tJnFp1Ydr38TDjVmmAV",
      "departmentId":"MugSscaxnE21ZC8phZRe",

      "isInstructor":"true",
      "isHoD":"false",
      "isPrinciple":"false"
    },
  ];

// List collages=[
//   {"id": "3tJnFp1Ydr38TDjVmmAV", "name": "CIVE"}, 
//   {"id": "IbG4ktRJSqbGeGkPRItl", "name": "COES"}];

//Cive departments only are in here.
// List departments=[
//    {"id": "MugSscaxnE21ZC8phZRe", "collageId": "3tJnFp1Ydr38TDjVmmAV", "title": "CSE", "name": "Computer Science And Engineering"},
//    {"id": "kK3gAdn1CBPsTu9thBrC", "collageId": "3tJnFp1Ydr38TDjVmmAV", "title": "ETE", "name": "Electronics And Telecommunication Engineering"},
//    {"id": "TmhAn1yQlsgG8vHCZlbe", "collageId": "3tJnFp1Ydr38TDjVmmAV", "title": "IST", "name": "Information Stystems And Technology"}
//   ];

//Above are be uploaded to database.

List courses=[
  {
    "collageId":"",
    "lable":"BT 413",
    "name":"ICT project management",
    "stoodBy":[
    "BSC-CS31","BSC-SE41","BSC-IDIT31","BSC-MTA31","BSC-CSDFE41","BSC-CE41","BSC-TE41","BSC-BIS31","BSC-IS31"
    ]
  },
    {
    "collageId":"",
    "lable":"SI 311",
    "name":"Professional ethics and conduct",
    "stoodBy":[
     "BSC-CS31", "BSC-SE41","BSC-CSDFE41","BSC-CE41","BSC-TE41","BSC-BIS31", "BSC-MTA31"
    ]
  },
  {
    "collageId":"",
    "lable":"SI 311",
    "name":"Professional ethics and conduct",
    "stoodBy":[
     "BSC-CS31", "BSC-SE41","BSC-CSDFE41","BSC-CE41","BSC-TE41","BSC-BIS31", "BSC-MTA31"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 313",
    "name":"Mobile application development",
    "stoodBy":[
     "BSC-CS31","BSC-SE31","BSC-IS31","BSC-IDIT21","BSC-MTA31"
    ]
  },
  {
    "collageId":"",
    "lable":"CS 319",
    "name":"Computer science project I",
    "stoodBy":[
     "BSC-CS31"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 313",
    "name":" Internet Programming and Applications II",
    "stoodBy":[
      "BSC-CS31","BSC-SE31","BSC-CSDFE31","BSC-IS31","BSC-BIS31"
    ]
  },
  {
    "collageId":"",
    "lable":"MT 3111",
    "name":"Mathematical Logic and Formal Semantics",
    "stoodBy":[
      "BSC-CS31","BSC-SE31"
    ]
  },
  {
    "collageId":"",
    "lable":"EME 314",
    "name":"ICT Entrepreneurship",
    "stoodBy":[
      "BSC-CS31","BSC-SE31","BSC-IDIT31","BSC-BIS31","BSC-IS31","BSC-CSDFE41",
      "BSC-MTA31","BSC-CE41","BSC-TE41"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 318",
    "name":"Computer Graphics",
    "stoodBy":[
      "BSC-SE31","BSC-CS31"
    ]
  },
  {
    "collageId":"",
    "lable":"IM 411",
    "name":"Human-Computer Interaction",
    "stoodBy":[
      "BSC-SE41","BSC-CS31"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 313",
    "name":"Operating Systems Security",
    "stoodBy":[
      "BSC-CSDFE31","BCS-CS31"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 322",
    "name":"Data Mining and Warehousing",
    "stoodBy":[
      "BSC-SE32","BSC-CS32","BSC-BIS22","BSC-CSDFE32"
    ]
  },
  {
    "collageId":"",
    "lable":"CS 339",
    "name":"Computer Science Project II",
    "stoodBy":[
      "BSC-CS32"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 422",
    "name":"Artificial Intelligence",
    "stoodBy":[
       "BSC-SE42","BSC-CS32","BSC-CE42"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 323",
    "name":"Web Framework Development Using JavaScript",
    "stoodBy":[
       "BSC-SE32","BSC-CS32"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 321",
    "name":"Distributed Database Systems",
    "stoodBy":[
       "BSC-CS32","BSC-CE32","BSC-SE32","BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 321",
    "name":"System Administration and Management",
    "stoodBy":[
      "BSC-CS32","BSC-BIS22","BSC-SE42","BSC-CSDFE32","BSC-CE42","BSC-TE42","BSC-IS32","BSC-MTA32"
    ]
  }, 
  {
    "collageId":"",
    "lable":"CP 424",
    "name":"Cloud Computing",
    "stoodBy":[
      "BSC-SE42","BSC-CS32","BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 324",
    "name":"Compiler Technology",
    "stoodBy":[
      "BSC-CE42","BSC-SE32","BSC-CS32"
    ]
  },


  {
    "collageId":"",
    "lable":"CT 411",
    "name":"Embedded Systems I",
    "stoodBy":[
       "BSC-SE31","BSC-CE41","BSC-TE41"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 316",
    "name":"Selected Topics in Software Engineering",
    "stoodBy":[
       "BSC-SE31"
    ]
  },
  {
    "collageId":"",
    "lable":"CS 321",
    "name":"Advanced Java Programming",
    "stoodBy":[
       "BSC-SE32"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 321",
    "name":"Information and Communication Systems Security",
    "stoodBy":[
       "BSC-SE32"
    ]
  },
  {
    "collageId":"",
    "lable":"CS 331",
    "name":"Industrial Practical Training III",
    "stoodBy":[
       "BSC-SE32"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 326",
    "name":"Secure System Development",
    "stoodBy":[
       "BSC-SE32"
    ]
  },

  {
    "collageId":"",
    "lable":"IA 311",
    "name":"Network Forensics",
    "stoodBy":[
       "BSC-TE41","BSC-CSDFE31"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 318 IT",
    "name":"Security Metrics",
    "stoodBy":[
      "BSC-CSDFE31"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 312",
    "name":"Multimedia Forensics",
    "stoodBy":[
      "BSC-CSDFE31"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 316",
    "name":"Mobile Forensics Analysis",
    "stoodBy":[
      "BSC-CSDFE31"
    ]
  },
  {
    "collageId":"",
    "lable":"CT 314",
    "name":"Computer Organization and Architecture II",
    "stoodBy":[
      "BSC-CSDFE31","BSC-CE31"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 317",
    "name":"Selected Topics in Cyber Security and Digital Forensics Engineering",
    "stoodBy":[
      "BSC-CSDFE31"
    ]
  },
  
  {
    "collageId":"",
    "lable":"IA 325",
    "name":"Security and Fault-Tolerance in Distributed Systems",
    "stoodBy":[
      "BSC-CSDFE32"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 325",
    "name":"Assembly Language Programming",
    "stoodBy":[
      "BSC-CSDFE32"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 322",
    "name":"Malware And Software Vulnerability Analysis",
    "stoodBy":[
      "BSC-CSDFE32"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 324",
    "name":"Web and Mobile Systems Security",
    "stoodBy":[
      "BSC-CSDFE32"
    ]
  },
  {
    "collageId":"",
    "lable":"CS 331",
    "name":"Industrial Practical Training III",
    "stoodBy":[
      "BSC-CSDFE32"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 326",
    "name":"Secure Systems Development",
    "stoodBy":[
      "BSC-CSDFE32"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 326",
    "name":"Secure Systems Development",
    "stoodBy":[
      "BSC-CSDFE32"
    ]
  },

  {
    "collageId":"",
    "lable":"CT 315",
    "name":"Mobile Computing",
    "stoodBy":[
      "BSC-MTA31","BSC-CE31"
    ]
  },
  {
    "collageId":"",
    "lable":"CT 313",
    "name":" Very Large Scale Integrated Circuits",
    "stoodBy":[
      "BSC-TE31","BSC-CE31"
    ]
  },
  {
    "collageId":"",
    "lable":"CT 311",
    "name":"Microprocessor and Interfacing",
    "stoodBy":[
      "BSC-TE31","BSC-CE31"
    ]
  },
  {
    "collageId":"",
    "lable":"EC 211",
    "name":"Electrical Networks Analysis",
    "stoodBy":[
      "BSC-CE31"
    ]
  },
  {
    "collageId":"",
    "lable":"TN 312",
    "name":"Optical Communication Systems",
    "stoodBy":[
      "BSC-CE31","BSC-TE31"
    ]
  },
  {
    "collageId":"",
    "lable":"CN 311",
    "name":"Wireless Networking",
    "stoodBy":[
      "BSC-CE31","BSC-TE31"
    ]
  },
  {
    "collageId":"",
    "lable":"CT 321",
    "name":"Microcontroller Systems",
    "stoodBy":[
      "BSC-CE32","BSC-TE32"
    ]
  },
  {
    "collageId":"",
    "lable":"IA 321",
    "name":"Information and Communication Systems Security",
    "stoodBy":[
      "BSC-CE32","BSC-TE32"
    ]
  },
  {
    "collageId":"",
    "lable":"CT 322",
    "name":"Robotics and Automation",
    "stoodBy":[
      "BSC-CE32"
    ]
  },
  {
    "collageId":"",
    "lable":"CN 322",
    "name":"LAN Switching",
    "stoodBy":[
      "BSC-CE32","BSC-TE32"
    ]
  },
  {
    "collageId":"",
    "lable":"CG 331",
    "name":"Industrial Practical Training III",
    "stoodBy":[
      "BSC-CE32"
    ]
  },
  {
    "collageId":"",
    "lable":"CG 321",
    "name":"Selected Topics in Computer Engineering",
    "stoodBy":[
      "BSC-CE32"
    ]
  },
  {
    "collageId":"",
    "lable":"TN 311",
    "name":"Analogue Telecommunications",
    "stoodBy":[
      "BSC-TE31"
    ]
  },
  {
    "collageId":"",
    "lable":"TN 314",
    "name":"Electromagnetic Theory II",
    "stoodBy":[
      "BSC-TE31"
    ]
  },   
  {
    "collageId":"",
    "lable":"EC 311",
    "name":"Intelligent Instrumentation",
    "stoodBy":[
      "BSC-TE31"
    ]
  },
  {
    "collageId":"",
    "lable":"TN 321",
    "name":"Fuzzy Logic for Engineering Application",
    "stoodBy":[
      "BSC-TE32"
    ]
  },
  {
    "collageId":"",
    "lable":"TN 322",
    "name":"Microwave Engineering",
    "stoodBy":[
      "BSC-TE32"
    ]
  },
  {
    "collageId":"",
    "lable":"TN 323",
    "name":"Digital Telecommunications",
    "stoodBy":[
      "BSC-TE32"
    ]
  },
  {
    "collageId":"",
    "lable":"CN 321",
    "name":"Tele-traffic Engineering",
    "stoodBy":[
      "BSC-TE32"
    ]
  },
  {
    "collageId":"",
    "lable":"TN 331",
    "name":"Industrial Practical Training III",
    "stoodBy":[
      "BSC-TE32"
    ]
  },
  {
    "collageId":"",
    "lable":"IM 311",
    "name":"Customer Relationship Management Information",
    "stoodBy":[
      "BSC-BIS31"
    ]
  },
  {
    "collageId":"",
    "lable":"IS 315",
    "name":"Business Information Systems Project I",
    "stoodBy":[
      "BSC-BIS31"
    ]
  },
  {
    "collageId":"",
    "lable":"IM 314",
    "name":"Business Intelligence System and Data Visualization",
    "stoodBy":[
      "BSC-BIS31","BSC-IS31"
    ]
  },
    {
    "collageId":"",
    "lable":"BT 312",
    "name":"Electronic and Mobile Commerce",
    "stoodBy":[
      "BSC-BIS31"
    ]
  },
  {
    "collageId":"",
    "lable":"AF 312",
    "name":"Public Finance and Taxation I",
    "stoodBy":[
      "BSC-BIS31"
    ]
  },
  {
    "collageId":"",
    "lable":"IM 326",
    "name":"Knowledge Management Systems",
    "stoodBy":[
      "BSC-BIS32"
    ]
  },
    {
    "collageId":"",
    "lable":"IS 325",
    "name":"Management Information System",
    "stoodBy":[
      "BSC-BIS32"
    ]
  },
      {
    "collageId":"",
    "lable":"LW 3208",
    "name":"ICT Laws and Ethics",
    "stoodBy":[
      "BSC-BIS32","BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"IS 328",
    "name":"Geographic Information Systems",
    "stoodBy":[
      "BSC-BIS32","BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"IM 323",
    "name":"Business Analytics-Principles and Applications",
    "stoodBy":[
    "BSC-BIS32"
    ]
  },
  {
    "collageId":"",
    "lable":"MS 324",
    "name":"Inventory Management",
    "stoodBy":[
    "BSC-BIS32"
    ]
  },
  {
    "collageId":"",
    "lable":"MG 323",
    "name":"Import and Export Management",
    "stoodBy":[
    "BSC-BIS32"
    ]
  },
  {
    "collageId":"",
    "lable":"IS 324",
    "name":"Business Information Systems Project II",
    "stoodBy":[
    "BSC-BIS32"
    ]
  },
  {
    "collageId":"",
    "lable":"IS 329",
    "name":"Selected Topics in Business Information Systems",
    "stoodBy":[
    "BSC-BIS32"
    ]
  }, 
   {
    "collageId":"",
    "lable":"ST 3216",
    "name":"Statistics for Information Analysis",
    "stoodBy":[
      "BSC-BIS32","BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"MG 316",
    "name":"Organizational Risk Management",
    "stoodBy":[
      "BSC-IS31"
    ]
  },
    {
    "collageId":"",
    "lable":"IS 316",
    "name":"Information Systems Project I",
    "stoodBy":[
      "BSC-IS31"
    ]
  },
  {
    "collageId":"",
    "lable":"MG 311",
    "name":"Strategic Management",
    "stoodBy":[
      "BSC-IS31"
    ]
  },
   {
    "collageId":"",
    "lable":"IM 313",
    "name":"Principle of Big Data Management",
    "stoodBy":[
      "BSC-IS31"
    ]
  },
  {
    "collageId":"",
    "lable":"IS 318",
    "name":"E-Agriculture and Environment",
    "stoodBy":[
      "BSC-IS31"
    ]
  }, 
  {
    "collageId":"",
    "lable":"IS 326",
    "name":"Information Systems Project II",
    "stoodBy":[
      "BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"IM 327",
    "name":"Computer Supported Collaborative Work",
    "stoodBy":[
      "BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"HR 322",
    "name":"Organizational Change and Development",
    "stoodBy":[
      "BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"IM 326",
    "name":"Knowledge Management Systems",
    "stoodBy":[
      "BSC-IS32"
    ]
  },
    {
    "collageId":"",
    "lable":"IS 322",
    "name":"Information Systems Competences",
    "stoodBy":[
      "BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"CP 423",
    "name":"System Administration and Management",
    "stoodBy":[
      "BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"IM 324",
    "name":"Selected Topics in Information Systems",
    "stoodBy":[
      "BSC-IS32"
    ]
  },
  {
    "collageId":"",
    "lable":"IS 321",
    "name":"Information Systems Theories",
    "stoodBy":[
      "BSC-IS32"
    ]
  },
    {
    "collageId":"",
    "lable":"IM 323",
    "name":"Business Analytics – Principles and Applications",
    "stoodBy":[
      "BSC-IS32"
    ]
  },
  { 
    "collageId":"",
    "lable":"CD 312",
    "name":"Multimedia Content Development",
    "stoodBy":[
      "BSC-IDIT31","BSC-MTA31","BSC-SE41"
    ]
  },
  { 
    "collageId":"",
    "lable":"CD 332",
    "name":"IDIT Project I",
    "stoodBy":[
      "BSC-IDIT31"
    ]
  },
  { 
    "collageId":"",
    "lable":"CD 314",
    "name":"Digital Instructional Design II",
    "stoodBy":[
      "BSC-IDIT31","BSC-MTA31"
    ]
  },
  { 
    "collageId":"",
    "lable":"CD 311",
    "name":"3D Modelling and Rendering",
    "stoodBy":[
      "BSC-IDIT31"
    ]
  },
  { 
    "collageId":"",
    "lable":"CD 321",
    "name":"3D Animations and Special Effects",
    "stoodBy":[
      "BSC-IDIT32","BSC-MTA32"
    ]
  },
    { 
    "collageId":"",
    "lable":"CD 323",
    "name":"Electronic Media Publishing",
    "stoodBy":[
      "BSC-IDIT32"
    ]
  },
  {
    "collageId":"",
    "lable":"ET 322",
    "name":"Advanced Technology for Education and Training",
    "stoodBy":[
      "BSC-IDIT32"
    ]
  },
  { 
    "collageId":"",
    "lable":"CD 333",
    "name":"IDIT Project II",
    "stoodBy":[
      "BSC-IDIT32"
    ]
  },
  { 
    "collageId":"",
    "lable":"CD 328",
    "name":" Multimedia Technology II",
    "stoodBy":[
      "BSC-IDIT32","BSC-MTA32"
    ]
  },
    { 
    "collageId":"",
    "lable":"CD 324",
    "name":"Selected Topics in Instructional Design and Information Technology",
    "stoodBy":[
      "BSC-IDIT32","BSC-MTA32"
    ]
  }, 
  { 
    "collageId":"",
    "lable":"CD 322",
    "name":"Digital Creative Advertising and Production",
    "stoodBy":[
      "BSC-IDIT32","BSC-MTA32","BSC-SE42"
    ]
  },
  { 
    "collageId":"",
    "lable":"CD 331",
    "name":"MTA Project I",
    "stoodBy":[
     "BSC-MTA31"
    ]
  },
   { 
    "collageId":"",
    "lable":"CD 334",
    "name":"MTA Project II",
    "stoodBy":[
     "BSC-MTA32"
    ]
  },
   { 
    "collageId":"",
    "lable":"AD 326",
    "name":"Practices in Photography",
    "stoodBy":[
     "BSC-MTA32"
    ]
  },
    { 
    "collageId":"",
    "lable":"CD 323",
    "name":"Electronic Media Publishing",
    "stoodBy":[
     "BSC-MTA32"
    ]
  },
  { 
    "collageId":"",
    "lable":"CD 325",
    "name":"Digital Broadcasting Engineering",
    "stoodBy":[
     "BSC-MTA32"
    ]
  },        
];
  
  List excellenceLevelColors=[Colors.white,Colors.red,Colors.red[200],Colors.yellow,Colors.green[200],Colors.green];
  List<String> excellenceLevel=["Not applicable","Very poor","Poor","Satisfactory","Very good","Excellent"];
  List<String> problemStatus=["Solved","Unsolved"];

  List instEvalList=[
    {
      "rank":"Best",
      "name":"Prof Juma Mgaya",
      "course":"CP 123",
      "description":"Prof mgaya kama kawaida yake amejitahidi sana semester hii",
      "date":"12/3/2023"
    },
    {
      "rank":"Bad",
      "name":"Dr Kihemba",
      "course":"CS 132",
      "description":"Mwalimu kwakweli haeleweki darasani yaani kazi yake ni kushusha slides tuuu na baadhi ya slide hata haelezei kabisa, anafundisha kumaliza.",
      "date":"12/3/2023"
    },
    {
      "rank":"Bad",
      "name":"Mr Johakim Hassan",
      "course":"CS 113",
      "description":"Jamaa anadoji vipindi vingi sana halafu mwisho wa siku anatunga mitihani migumu, pigga chini",
      "date":"10/3/2023"
    },
    {
      "rank":"Good",
      "name":"Prof Juma Mgaya",
      "course":"CS 123",
      "description":"Prof anajitahidi kufundisha vizuri tatizo ni moja tu hafuati ratiba yaan kipindi anashtukiza tuu",
      "date":"20/2/2023"
    },
    {
      "rank":"Average",
      "name":"Mr Nyondo",
      "course":"TN 122",
      "description":"Mr nyondo yuko vizuri tatizo tuu ni kwamba anafundisha kanakwamba wote mmnabasics za somo analofundisha, wengine tumetoka diploma hatujui umeme",
      "date":"12/3/2023"
    },
    {
      "rank":"Best",
      "name":"Dr Kihaya",
      "course":"CP 103",
      "description":"dr kihaya kama kawaida yake amejitahidi sana semester hii",
      "date":"12/3/2023"
    },
    {
      "rank":"Average",
      "name":"Mr James Kihaya",
      "course":"CS 123",
      "description":"Huyu james ni mwalimu bora Cive",
      "date":"1/3/2023"
    },
    {
      "rank":"Bad",
      "name":"Mr Johakim Hassan",
      "course":"CS 123",
      "description":"Huyu mwalim anatongoza sana wanafunzi, eyes on him.",
      "date":"1/3/2023"
    },
  ];


