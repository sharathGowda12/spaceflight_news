import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spaceflight_news/screens_widgets/for_01a_mainCard.dart';

Widget sliversTestingWidget(Widget child01) => ScreenUtilInit(
        designSize: Size(1440, 2960),
      builder: () => 
      MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers :[child01] ),
          ),
        ),
      );

Widget commonTestingWidget(Widget child01) => ScreenUtilInit(
        designSize: Size(1440, 2960),
      builder: () => 
      MaterialApp(
          home: Scaffold(
            body: child01,
          ),
        ),
      );

void main() {
  group('Group Testing in ..screen_widgets/for_01_news_main_card_test.dart',
  () {

  testWidgets('Check the TopSliverListForMainCard', 
  (WidgetTester tester) async {

    await tester.pumpWidget(
      sliversTestingWidget(TopSliverListForMainCard(
      showSliverList: true, pageIndex: 0, )));
    
    expect(find.text('News feed'), findsOneWidget);
    
  });

  testWidgets('Check the BottomSliverListForMainCard', 
  (WidgetTester tester) async {

    await tester.pumpWidget(
      sliversTestingWidget(BottomSliverListForMainCard(
      showBottomLoadingIndicator: true, )));
    

    expect(find.byType( CircularProgressIndicator), findsOneWidget);
    
  });

  testWidgets('Check the MainCardImageContainer', 
  (WidgetTester tester) async {
    //  mackNetworkImagesFor is  coming from network_image_mock: ^2.0.1
    // in dev_dependencies, to provide fake http image data.
    await mockNetworkImagesFor( () =>  tester.pumpWidget(
      commonTestingWidget(MainCardImageContainer(
        imageUrl: 'https://homepages.cae.wisc.edu/~ece533/images/airplane.png',
        webUrl: 'https://www.google.com/',
        cacheImage: false,))));

    expect(find.byType(FadeInImage), findsOneWidget);
    
  });

  testWidgets('Check the ShowDateInMainCard', 
  (WidgetTester tester) async {

    await tester.pumpWidget(
      commonTestingWidget( ShowDateInMainCard(
          publishedDate: '2021-05-22T19:45:55.313Z',
          ),
      ));

    // Date has to be modified.
    expect(find.text('May 22, 2021'), findsOneWidget);
  });
  
  });
  
}
