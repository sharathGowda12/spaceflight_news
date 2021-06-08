# spaceflight_news
Flutter app to show the latest news related to space.

Flutter Version - 2.0.6

VS Code - 1.56.2

Run 'flutter clean' and 'flutter pub get' if the errors shows at the start.


**Reading the Code**
1. The Entry point of the app is 'lib/main.dart'. 
2. Next is `lib/screens`, in that `01_mainScreen.dart`  is responsible for rendering feeds, favorites, app bar, search widgets. `01a_mainCard` contains code to render grid view of the articles including the option to favorite, unfavorite and to take the user to detailed articles screen once it is tapped. `02_detailedNews.dart` is responsible to show the web view of the news site.
3. `lib/screens_widgets` folder contains individual widgets for the above screens.
4. `lib/commonFunctions` holds the function to check whether the article is favorited or not and to generate url to request data from the api.
5. `lib/database` is for creating the persistence storage of favorited articles with `sqflite: ^2.0.0+3` and it also holds functions to handle retrieving, adding, and removing of the favorited articles.
6. `lib/styles` is for common elements, names, colors, etc, which are used in more than one functions/widgets.
7. `lib/widgets` is for common widgets and 'empty_container.dart' contains the code to handle empty screen, like if there are no favorites, there is no search items, etc.

**Few Points to Note**
- App orientation is locked to portrait only.
- As the app is not complex in nature, a simple function (refer getSavedFavoriteNewsInMainScreen() in `lib/screens/01_mainScreen.dart`) is passed between screens to manage the favorited articles, which improves the readability and works great too. However, once it becomes difficult to access the functions in other screens/widgets, we may opt for using state management packages like Provider.
- App will show the no network Icon if the user is not connected to mobile data or wifi.
- Images of the favorited articles are cached.
- Articles in the feed screen are paginated with 05 articles request at a time, to change that refer `lib/commonFunctions/createUrl.dart`.
- Icon of the empty container shown in the feed screen is somewhat different from the one shown in Figma / design. Refer to line no. 25 in `lib/widgets/empty_container.dart` for further details.
- Image `assets/placeHolder.jpeg` is used both as a placeholder for article images and background image for the main screen.
- splash screen added for both android & iOS
- App is tested on Samsung Galaxy S9 and iPhone 11 emulators only.


**Tests**

All the tests are available in `test/` and I feel that there is scope to add more tests.

**Observations**
1.  Some URL's provided by the API returns 'net::ERR_CLEARTEXT_NOT_PERMITTED' error in android, and in the iOS blank screen, as this is a security measure (https certication issue) implemented by OS, no action is taken to resolve this. However, this could be resolved.
