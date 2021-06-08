import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spaceflight_news/screens/01_mainScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //ScreenUtilInit will be responsible for adjusting the size of widgets
    // and screens as per mobiles screen size
    //designSize(defualt) is based on Samsung Galaxy S9
    return ScreenUtilInit(
      designSize: Size(1440, 2960),
      builder: () => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
      ),
    );
  }
}
