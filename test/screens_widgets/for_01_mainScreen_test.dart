import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spaceflight_news/screens_widgets/for_01_mainScreen.dart';

void main() {
  testWidgets('Check the SideTextForAppBar..screen_widgets/for_01_main_screen_test.dart', 
  (WidgetTester tester) async {

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(1440, 2960),
      builder: () => 
      MaterialApp(
          home: Scaffold(
            body: SideTextForAppBar(appBarText: 'Feed',),
          ),
        ),
      ));

    expect(find.text('Feed'), findsOneWidget);
    
  });
}