import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:spaceflight_news/database/sqflite_helper.dart';
import 'package:spaceflight_news/styles/boxDecorations.dart';
import 'package:spaceflight_news/styles/colors.dart';
import 'package:spaceflight_news/styles/double_values.dart';
import 'package:spaceflight_news/widgets/buttons.dart';
import 'package:spaceflight_news/screens_widgets/for_01a_mainCard.dart';
import 'package:spaceflight_news/widgets/sizedBoxes.dart';
import 'package:spaceflight_news/commonFunctions/checkFavorites.dart';

class NewsMainCard extends StatefulWidget {
  // List to show the articles
  final List apiEntries;
  //  List to check whether the articles are favorited.
  final List favoriteNews;
  // TO highlight text during search function
  final String highLightWord;
  // TO update the favorite articles list on icon tap
  final Function getFavoriteNewsFunction;
  // Index of the page, to change  text in TopSliverListForMainCard
  final int pageIndex;
  // To control appearance of TopSliverListForMainCard
  // depending on whether user is searching the articles or not
  final bool showSliverList;
  // This will control the whether to show progress indicator in
  // BottomSliverListForMainCard
  final bool showBottomLoadingIndicator;
  // To cache the image in memory or to show cached Image
  final bool cacheImage;

  NewsMainCard(
      {@required this.apiEntries,
      @required this.favoriteNews,
      @required this.highLightWord,
      @required this.getFavoriteNewsFunction,
      @required this.pageIndex,
      @required this.showSliverList,
      @required this.showBottomLoadingIndicator,
      @required this.cacheImage});
  _NewsMainCardState createState() => _NewsMainCardState();
}

// All the widgets for this class are found in lib/screens_widgets/for_01a_news_main_card.dart
class _NewsMainCardState extends State<NewsMainCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CntBoxDecoration.withOnlyTopRadius,
      child: CustomScrollView(
        slivers: [
          //  This shows 'News Feed' and 'Favorited atricles' heading at top
          TopSliverListForMainCard(
            showSliverList: widget.showSliverList,
            pageIndex: widget.pageIndex,
          ),
          _sliverGridBuilder(),
          // Shows bottom loading indicator or a just space at bottom
          BottomSliverListForMainCard(
            showBottomLoadingIndicator: widget.showBottomLoadingIndicator,
          ),
        ],
      ),
    );
  }

  Widget _sliverGridBuilder() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          Map<String, dynamic> _snapshot = widget.apiEntries[index];
          return _individualCards(_snapshot);
        },
        childCount: widget.apiEntries.length,
      ),
    );
  }

  Widget _individualCards(Map<String, dynamic> indexSnapshot01) {
    String _id = indexSnapshot01['id'];
    String _title = indexSnapshot01['title'];
    String _webUrl = indexSnapshot01['url'];
    String _imageUrl = indexSnapshot01['imageUrl'];
    String _publishedOn = indexSnapshot01['publishedAt'];

    return Container(
      margin: EdgeInsets.fromLTRB(50.h, 0, 50.h, 0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Tapping this will take the user to go to
          // 02_detailedNewsScreen.dart
          MainCardImageContainer(
              webUrl: _webUrl,
              imageUrl: _imageUrl,
              cacheImage: widget.cacheImage),

          _titleAndButtonMainContainer(
              _id, _title, _webUrl, _imageUrl, _publishedOn),
        ],
      ),
    );
  }

  Widget _titleAndButtonMainContainer(
    String id01,
    String title01,
    String webUrl01,
    String imageUrl01,
    String publishedDate01,
  ) {
    // UnConstrainedBox is to adjust the height of the container dynamically
    // as per the length of the title
    return UnconstrainedBox(
      constrainedAxis: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.fromLTRB(40.w, 20.h, 40.w, 10.h),
        width: double.maxFinite,
        decoration: _mainContainerDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TitleTextWidgetWithHighlight(
              title: title01,
              wordsToHighlight: widget.highLightWord,
            ),
            Row(
              children: [
                ShowDateInMainCard(publishedDate: publishedDate01),
                SizedBoxWidth100(),
                _favouriteButton(
                    id01, title01, webUrl01, imageUrl01, publishedDate01),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _favouriteButton(String id01, String title01, String webUrl01,
      String imageUrl01, String publishedDate01) {
    //This will check whether the article is favorited or not
    // and as per the obtained result icons will be showed & relavent
    // functions are carried out.
    bool _isFavorited = checkIsNewsFavorited(widget.favoriteNews, id01);

    return CustomIconButton(
      icon01: _isFavorited ? Icons.favorite : Icons.favorite_border,
      toolTip01: 'Favourite',
      iconSize01: 120,
      colorOfIcon01: _isFavorited
          ? ColorsCustom.mainColor
          : ColorsCustom.dateAndFavoriteButtonColor,
      onClick: () {
        // refer lib/database/sqflite_helper.dart for below two functions.
        // they will add / remove entries from local / sqflite storage.
        _isFavorited
            ? removeNewsFromFavorites(id01)
            : addNewsToFavorites(
                id01, title01, webUrl01, imageUrl01, publishedDate01);
        // To update the favorites state / button dynamically
        widget.getFavoriteNewsFunction();
        // To show snackbar/toast once the action is completed
        // refer lib/widgets/for_01a_news_main_card.dart
        showToast(_isFavorited);
      },
    );
  }

  BoxDecoration _mainContainerDecoration = BoxDecoration(
      borderRadius:
          BorderRadius.all(Radius.circular(DoubleValues.borderRadius01)),
      color: Colors.white);
}
