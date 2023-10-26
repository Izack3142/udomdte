import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:udomdte/app_services/notification_services.dart';
import 'app_screens/splash_screen.dart';
import 'app_services/provider_services.dart';

final scaffoldKey=GlobalKey<ScaffoldMessengerState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().initializeNotification();
  await NotificationService().showNotification("Evaluation reminder","Please conduct evaluation so that we can improve university services");
  runApp(const DteApp());
}


class DteApp extends StatelessWidget {
  const DteApp({super.key});

  @override
  Widget build(BuildContext context) {
    const MaterialColor colorPrimarySwatch = MaterialColor(
    0xFF003151,
    <int, Color>{
      50: Color(0xFF003151),
      100: Color(0xFF003151),
      200: Color(0xFF003151),
      300: Color(0xFF003151),
      400: Color(0xFF003151),
      500: Color(0xFF003151),
      600: Color(0xFF003151),
      700: Color(0xFF003151),
      800: Color(0xFF003151),
      900: Color(0xFF003151),
    },
      );
    return ChangeNotifierProvider(
      create: (context)=>DataProvider(),
      child:MaterialApp(
       scaffoldMessengerKey: scaffoldKey,
       builder: EasyLoading.init(),
       debugShowCheckedModeBanner: false,
       theme: ThemeData(
        primarySwatch: colorPrimarySwatch
       ),
       home:  const SplashScreen(),
    )
    ); 
  }
}


//git, flutter,android studio,vs code


