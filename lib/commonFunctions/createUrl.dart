Uri createUrl(int startAfter01) {
  //limit number of articles for http get request in single fetch
  int _numberOfEntriesInSingleFetch = 5;

  //  startAfter01 is for pagination
  Uri _spaceFlightUrl = Uri.https('spaceflightnewsapi.net', '/api/v2/articles',
      {'_limit': '$_numberOfEntriesInSingleFetch', "_start": '$startAfter01'});

  return _spaceFlightUrl;
}
