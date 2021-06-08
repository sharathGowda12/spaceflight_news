import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spaceflight_news/screens/01a_mainCard.dart';

Widget commonTestingWidget(Widget child01) => ScreenUtilInit(
        designSize: Size(1440, 2960),
      builder: () => 
      MaterialApp(
          home: Scaffold(
            body: child01,
          ),
        ),
      );
      
List _apiEntries = [
  {
    "id": "6033e57e3a4653001c01217b",
    "title": "NASA to Reveal New Video, Images From Mars Perseverance Rover",
    // For the sake of easier test do no include https in this url.
    "url": "May be any String as we are not testing this.",
    "imageUrl": "https://mars.nasa.gov/system/news_items/main_images/8868_1-PIA24428-1200.jpg",
    "newsSite": "NASA",
    "summary": "First-of-its kind footage from the agency’s newest rover will be presented during a briefing this morning.",
    "publishedAt": "0020-02-22T17:10:00.000Z",
  },
  {
    "id": "60369bd83a4653001c0121a4",
    "title": "NASA’s Perseverance Rover Gives High-Definition Panoramic View of Landing Site",
    "url": "May be any String as we are not testing this.",
    "imageUrl": "https://www.nasa.gov/sites/default/files/thumbnails/image/pia2464-mastcam-zs_first_360-degree_panorama2.jpg?itok=X3Nba0zj",
    "newsSite": "NASA",
    "summary": "NASA’s Mars 2020 Perseverance rover got its first high-definition look around its new home in Jezero Crater on Feb. 21, after rotating its mast, or “head,” 360 degrees, allowing the rover’s Mastcam-Z instrument to capture its first panorama after touching down on the Red Planet on Feb 18.",
    "publishedAt": "0020-02-24T19:12:28.000Z",
  },
];
  List _favoriteNewsEmpty = [];

void main() {

  group('Check the lib/screens/01a_news_main_card',() {
    testWidgets('Check NewsMainCard WITHOUT favorites.', 
      (WidgetTester tester) async {    
    //  mackNetworkImagesFor() is  from network_image_mock: ^2.0.1
    // (dev_dependencies), to provide fake http image data.
      await mockNetworkImagesFor(() => tester.pumpWidget(
        commonTestingWidget(NewsMainCard(
        apiEntries: _apiEntries,
        favoriteNews: _favoriteNewsEmpty,
        highLightWord: '',
        getFavoriteNewsFunction: () {}, 
        pageIndex: 0,
        showSliverList: true,
        showBottomLoadingIndicator: true,
        cacheImage: false,
        ))));
      
      // As the no articles are favorited, test should find  
      // Icons.favorite_border and no Icons.favorite in the widget. 
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
      
    });

    testWidgets('Check NewsMainCard WITH favorites.', 
      (WidgetTester tester) async {   
      await mockNetworkImagesFor(() => tester.pumpWidget(
        commonTestingWidget(NewsMainCard(
        apiEntries: _apiEntries,
        // all the entries are favorited, so _apiEntries are passed to favoriteNews
        favoriteNews: _apiEntries,
        highLightWord: '',
        getFavoriteNewsFunction: () {}, 
        pageIndex: 0,
        showSliverList: true,
        showBottomLoadingIndicator: true,
        cacheImage: false,
        ))));
      
      // As the both articles are favorited, test should find no 
      // Icons.favorite_border and find Icons.favorite in the widget. 
      expect(find.byIcon(Icons.favorite_border), findsNothing);
      
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      
    });

  });
  
  
}