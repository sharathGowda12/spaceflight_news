import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:spaceflight_news/widgets/empty_container.dart';

void main() {
  testWidgets('Check the CommonEmptyContainer', (WidgetTester tester) async {
    // If you change the _intTOChangeProperties value change find.text
    // and find.byIcon also.
    int _intToChangeProperties = 1 ;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(1440, 2960),
      builder: () => MaterialApp(
          home: Scaffold(
            body: CommonEmptyContainer(heightOfContainer: 1860.h,
                intToChangeProperties: _intToChangeProperties,),
          ),
        ),
      ));

    // check the empty container shows at starting.
    expect(find.text('There are no news yet.'), findsOneWidget);
    expect(find.byIcon(Icons.text_snippet), findsOneWidget);
    
  });
}

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:spaceflight_news/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(MyApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }