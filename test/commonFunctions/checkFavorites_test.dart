import 'package:flutter_test/flutter_test.dart';
import 'package:spaceflight_news/commonFunctions/checkFavorites.dart';

void main() {

  test('Test whether articles is favorited', () {
    
    List _list01 = [
      {
    "id": "12abc",
    "title": "NASA to Reveal New Video, Images From Mars Perseverance Rover",
    "url": "dfgdf",
    "imageUrl": "dfgdf",
    "newsSite": "NASA",
    "summary": "First-of-its kind footage from the agency’s newest rover will be presented during a briefing this morning.",
    "publishedAt": "0020-02-22T17:10:00.000Z",
  },
  ];
    
    bool _isTrue = checkIsNewsFavorited(_list01, '12abc' );

    expect(_isTrue, true);

    bool _isFalse = checkIsNewsFavorited(_list01, 'Mr23x');

    expect(_isFalse, false);


  });
}