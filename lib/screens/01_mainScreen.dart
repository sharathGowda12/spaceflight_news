import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spaceflight_news/screens_widgets/for_01_mainScreen.dart';
import 'package:spaceflight_news/styles/colors.dart';
import 'package:spaceflight_news/styles/imageNames.dart';
import 'package:spaceflight_news/widgets/buttons.dart';
import 'package:spaceflight_news/widgets/sizedBoxes.dart';

import 'package:spaceflight_news/widgets/empty_container.dart';
import 'package:spaceflight_news/screens/01a_mainCard.dart';
import 'package:spaceflight_news/database/sqflite_helper.dart';
import 'package:spaceflight_news/commonFunctions/createUrl.dart';

class MainScreen extends StatefulWidget {
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  TextEditingController _textController = new TextEditingController();

  //Text to show in appbar depending on screen, search, etc.
  String _appBarText = 'Feed';
  String _feedText = 'Feed';
  String _favoritesText = 'Favorites';
  // control which page has to be shown
  int _pageIndex = 0;
  // To control the visibility of serach option in appbar.
  bool _showTextFieldWithSearchButton = false;

  //Height of appBar / Topbar
  double _appBarHeight;
  //Height of main Container i.e _indexedStack()
  double _mainContainersHeight;
  // padding for the indexedStack to have overlapping effect.
  double _mainContainerTopPadding;

  // List / Data received from api
  List _httpData = [];
  // List of items, which matches the search criteria.
  List _searchResult = [];
  //List of favorited articles.
  List _favoritedNews = [];

  Duration _animationDuration = Duration(seconds: 2);
  StreamController _newsStreamController = StreamController();

  // To control http requests in fetchArticlesFromSpaceFlightApi01() function
  // DO NOT declare these in the associated functions.
  bool _isRequesting = false;
  bool _isFinish = false;

  @override
  void initState() {
    _adjustHeightOfContainers(_showTextFieldWithSearchButton);
    fetchArticlesFromSpaceFlightApi01();
    getSavedFavoriteNewsInMainScreen();
    super.initState();
  }

  // To adjust the height of appbar, maincontainer, etc, and to show
  // or not to show searchBox... dynamically
  void _adjustHeightOfContainers(bool increaseHeight) {
    //Reference height for main Containers
    double _height01 = 2960.h;
    //This height will help in overlapping the main content with
    // the appbar.
    double _subtractHeightForPadding = 50.h;
    // Appbar heights without search option and with search option.
    double _appBarHeightMinimum = 370.h;
    double _appBarHeightMaximum = 650.h;

    if (increaseHeight) {
      setState(() {
        _showTextFieldWithSearchButton = true;
        _appBarHeight = _appBarHeightMaximum;
        _mainContainersHeight = _height01 - _appBarHeightMaximum;
        _mainContainerTopPadding =
            _appBarHeightMaximum - _subtractHeightForPadding;
      });
    } else {
      setState(() {
        _showTextFieldWithSearchButton = false;
        _appBarHeight = _appBarHeightMinimum;
        _mainContainersHeight = _height01 - _appBarHeightMinimum;
        _mainContainerTopPadding =
            _appBarHeightMinimum - _subtractHeightForPadding;
      });
    }
  }

  //Fetch the articles from API along with pagination...
  Future fetchArticlesFromSpaceFlightApi01() async {
    // _isRequesting & _isFinish is necessary to make the app  to request new
    // data, only after the older requests are completed

    if (!_isRequesting && !_isFinish) {
      _isRequesting = true;

      // creates the Url refer commonFunctions/createUrl.dart
      Uri _spaceFlightUrl = createUrl(_httpData.length);

      await http.get(_spaceFlightUrl).then((response01) {
        if (response01.statusCode == 200) {
          if (response01.body != null) {
            var _jsonDecodedObject = jsonDecode(response01.body);

            int _oldSize = _httpData.length;

            //add the new data to both list & streams.
            _httpData.addAll(_jsonDecodedObject);
            _newsStreamController.add(_jsonDecodedObject);

            int _newSize = _httpData.length;

            //Checks if all the news are already consumed / received by app.
            // This is rare case for this app, still...
            if (_oldSize == _newSize) {
              setState(() {
                _isFinish = true;
              });
            }
          }
        } else {
          // If the server did not return a 200 OK response,
          Fluttertoast.showToast(
              msg: 'Unable to get the news from servers, please try again.',
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white);
          print('SpaceFlightApi returned bad response');
          print(response01.statusCode);
        }
      });
      _isRequesting = false;
    }
  }

  // Retrieves the favorited articles from local storage/database
  void getSavedFavoriteNewsInMainScreen() {
    DbHelper.getFavouritedNews().then((sqflite02) {
      if (sqflite02.isNotEmpty) {
        setState(() {
          _favoritedNews = sqflite02;
        });
      } else {
        setState(() {
          _favoritedNews = [];
        });
      }
    });
  }

  // Dispose the textController
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _mainScaffoldContainerDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            _appBar(),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _indexedStack(),
                _bottomNavigationBar(),
              ],
            )
          ],
        ),
      ),
    );
  }

// Main appBar widget
  Widget _appBar() {
    return AnimatedSize(
      vsync: this,
      duration: _animationDuration,
      child: Container(
          alignment: Alignment.center,
          height: _appBarHeight,
          color: ColorsCustom.mainColor,
          child: _showTextFieldWithSearchButton
              ? _topBarWithSearchOptionType02()
              : _topBarType01()),
    );
  }

  // App bar which includes plain heading & just serach button.
  Widget _topBarType01() {
    return Column(
      children: [
        SizedBoxForTopGap(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SideTextForAppBar(
              appBarText: _appBarText,
            ),
            SizedBoxWidth50(),
            _searchButtonOfTopBarType01(),
          ],
        ),
      ],
    );
  }

  // Tapping this button will opens the search option with test field.
  Widget _searchButtonOfTopBarType01() {
    return CustomIconButton(
      icon01: Icons.search,
      colorOfIcon01: Colors.white,
      toolTip01: 'Start Search',
      iconSize01: 120,
      onClick: () {
        _adjustHeightOfContainers(true);
      },
    );
  }

// App bar which includes "Search" heading & close button
// with search function.
  Widget _topBarWithSearchOptionType02() {
    return Column(
      children: [
        SizedBoxForTopGap(),
        _textAndCloseButtonOfTopBarType02(),
        SizedBoxHeight50(),
        _searchContainerWithTextField(),
      ],
    );
  }

  Widget _textAndCloseButtonOfTopBarType02() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SideTextForAppBar(
          appBarText: 'Search',
        ),
        SizedBoxWidth50(),
        _closeButtonOfTopBarType02(),
      ],
    );
  }

  // Button to close the search option.
  Widget _closeButtonOfTopBarType02() {
    return CustomIconButton(
      colorOfIcon01: Colors.white,
      toolTip01: 'Close',
      iconSize01: 120,
      icon01: Icons.close,
      onClick: () {
        _textController.clear();
        _adjustHeightOfContainers(false);
      },
    );
  }

  // Text field to enter the search keywords
  Widget _searchContainerWithTextField() {
    // Flexible is necessary to adjust height of the search widgets
    // during animation, so not to remove.
    return Flexible(
        child: Container(
      height: 180.h,
      width: 1300.w,
      padding: EdgeInsets.fromLTRB(40.w, 5.h, 40.w, 5.h),
      decoration: _searchContainerDecoration,
      child: TextField(
        controller: _textController,
        textAlignVertical: TextAlignVertical.center,
        decoration: _textFieldInputDecoration,
        style: _searchTextStyle,
        // call search function, whenever text changes.
        onChanged: onSearchTextChanged,
      ),
    ));
  }

  // Search function which startes the search as per the search text.
  void onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    //Both user typed text and the title are converted to lowercase
    //to make the search case insensitive with .toLowerCase().

    if (_pageIndex == 0) {
      _httpData.forEach((userDetail) {
        String _userDetailsLowerCase = userDetail['title'].toLowerCase();
        String _textLowerCase = text.toLowerCase();
        if (_userDetailsLowerCase.contains(_textLowerCase)) {
          _searchResult.add(userDetail);
        }
      });
    } else {
      _favoritedNews.forEach((userDetail) {
        String _userDetailsLowerCase = userDetail['title'].toLowerCase();
        String _textLowerCase = text.toLowerCase();
        if (_userDetailsLowerCase.contains(_textLowerCase)) {
          _searchResult.add(userDetail);
        }
      });
    }
    setState(() {});
  }

  // Represents main container in the screen
  //  This contains both the feed screen and favorites screen
  Widget _indexedStack() {
    return Container(
      alignment: Alignment.topCenter,
      padding: new EdgeInsets.only(
        top: _mainContainerTopPadding,
      ),
      child: AnimatedSize(
        vsync: this,
        duration: _animationDuration,
        reverseDuration: _animationDuration,
        child: Container(
          height: _mainContainersHeight,
          child: IndexedStack(
            index: _pageIndex,
            children: [
              _feedScreenStreamBuilder(),
              _favoritesMainScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feedScreenStreamBuilder() {
    // NotificationListener listens to position of the screen and if the
    // scroll position matches the one provided, call the fetchArticles function.
    return NotificationListener(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels) {
          fetchArticlesFromSpaceFlightApi01();
        }
        return true;
      },
      child: StreamBuilder(
        stream: _newsStreamController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData && snapshot.hasError) {
            return Container(
              child: CommonEmptyContainer(
                heightOfContainer: _mainContainersHeight,
                intToChangeProperties: 1,
              ),
            );
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CommonEmptyContainer(
                  heightOfContainer: _mainContainersHeight,
                  intToChangeProperties: 1,
                );
              case ConnectionState.none:
                return CommonEmptyContainer(
                  heightOfContainer: _mainContainersHeight,
                  intToChangeProperties: 1,
                );
              case ConnectionState.done:
                return _feedScreenConnectionDoneWidget();
              default:
                return _feedScreenConnectionDoneWidget();
            }
          }
        },
      ),
    );
  }

// This will create or make the Feed screen, if the data is available.
  Widget _feedScreenConnectionDoneWidget() {
    // _textController.text.length != 0 will check whether the users is
    // actively searching the articles, if he is checking articles with
    // matching search string will return otherwise articles already
    // downloaded from api or the empty container.
    if (_textController.text.length != 0) {
      return _searchResult.length != 0
          ? NewsMainCard(
              apiEntries: _searchResult,
              favoriteNews: _favoritedNews,
              getFavoriteNewsFunction: getSavedFavoriteNewsInMainScreen,
              highLightWord: _textController.text,
              pageIndex: _pageIndex,
              showSliverList: !_showTextFieldWithSearchButton,
              showBottomLoadingIndicator: false,
              cacheImage: false,
            )
          : CommonEmptyContainer(
              heightOfContainer: _mainContainersHeight,
              intToChangeProperties: 2,
            );
    } else {
      return NewsMainCard(
        apiEntries: _httpData,
        favoriteNews: _favoritedNews,
        getFavoriteNewsFunction: getSavedFavoriteNewsInMainScreen,
        highLightWord: _textController.text,
        pageIndex: _pageIndex,
        showSliverList: !_showTextFieldWithSearchButton,
        showBottomLoadingIndicator: !_isFinish,
        cacheImage: false,
      );
    }
  }

// This will create or make the Favorites screen
  Widget _favoritesMainScreen() {
    // _textController.text.length != 0 will check whether the users is
    // actively searching the articles, if he is checking articles with
    // matching search string will return otherwise favorites articles
    // or the empty container.
    if (_textController.text.length != 0) {
      return _searchResult.length != 0
          ? NewsMainCard(
              apiEntries: _searchResult,
              favoriteNews: _favoritedNews,
              getFavoriteNewsFunction: getSavedFavoriteNewsInMainScreen,
              highLightWord: _textController.text,
              pageIndex: _pageIndex,
              showSliverList: !_showTextFieldWithSearchButton,
              showBottomLoadingIndicator: false,
              cacheImage: true,
            )
          : CommonEmptyContainer(
              heightOfContainer: _mainContainersHeight,
              intToChangeProperties: 2,
            );
    } else {
      return _favoritedNews.length != 0
          ? NewsMainCard(
              apiEntries: _favoritedNews,
              favoriteNews: _favoritedNews,
              getFavoriteNewsFunction: getSavedFavoriteNewsInMainScreen,
              highLightWord: _textController.text,
              pageIndex: _pageIndex,
              showSliverList: !_showTextFieldWithSearchButton,
              showBottomLoadingIndicator: false,
              cacheImage: true,
            )
          : CommonEmptyContainer(
              heightOfContainer: _mainContainersHeight,
              intToChangeProperties: 3,
            );
    }
  }

// Bottom navigatior bar to change the screens
  Widget _bottomNavigationBar() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            100.h,
          ),
          topRight: Radius.circular(
            100.h,
          )),
      child: Container(
        color: Colors.white,
        child: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIconTheme:
              IconThemeData(size: 120.h, color: ColorsCustom.mainColor),
          unselectedIconTheme:
              IconThemeData(size: 120.h, color: Color(0xFF9CA3AF)),
          selectedLabelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          items: _bottomNavigationBarItems(),
          currentIndex: _pageIndex,
          onTap: (index) {
            _handleBottomNavigationBarTap(index);
          },
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _bottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: _feedText,
          backgroundColor: Colors.transparent),
      BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: _favoritesText,
          backgroundColor: Colors.transparent),
    ];
  }

  void _handleBottomNavigationBarTap(int index01) {
    setState(() {
      _pageIndex = index01;
    });

    // If the number of tabs increases, this also has to be increased
    // accordingly.
    if (index01 == 0) {
      setState(() {
        _appBarText = _feedText;
      });
    } else {
      setState(() {
        _appBarText = _favoritesText;
      });
    }
  }

  // Decorations & styles.
  BoxDecoration _mainScaffoldContainerDecoration = BoxDecoration(
      image: DecorationImage(
          image: AssetImage(
            ImageNames.placeHolderImage,
          ),
          fit: BoxFit.cover));

  BoxDecoration _searchContainerDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(120.h)),
      color: Colors.black38);

  InputDecoration _textFieldInputDecoration = InputDecoration(
      icon: Icon(
        Icons.search,
        size: 130.h,
        color: Colors.white,
      ),
      hintText: 'Search',
      hintStyle:
          TextStyle(color: Colors.white54, fontSize: ScreenUtil().setSp(70)),
      alignLabelWithHint: true,
      contentPadding: EdgeInsets.only(bottom: 50.h, top: 20.h),
      border: InputBorder.none);

  TextStyle _searchTextStyle =
      TextStyle(fontSize: ScreenUtil().setSp(90), color: Colors.white);
}
