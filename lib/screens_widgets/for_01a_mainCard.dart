import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spaceflight_news/styles/colors.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:intl/intl.dart';

import 'package:spaceflight_news/styles/double_values.dart';
import 'package:spaceflight_news/widgets/sizedBoxes.dart';
import 'package:spaceflight_news/screens/02_detailedNews.dart';
import 'package:spaceflight_news/styles/imageNames.dart';

class TopSliverListForMainCard extends StatelessWidget {
  final bool showSliverList;
  final int pageIndex;

  TopSliverListForMainCard(
      {@required this.showSliverList, @required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    String _mainText = textForSliverList(pageIndex);
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return showSliverList
            ? Container(
                padding: EdgeInsets.fromLTRB(50.w, 70.h, 50.w, 20.h),
                child: Text(
                  _mainText,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(110),
                      fontWeight: FontWeight.w700),
                ),
              )
            : Container();
      }, childCount: 1),
    );
  }
}

String textForSliverList(int pageIndex) {
  String _sliverText = 'News feed';

  if (pageIndex == 1) {
    _sliverText = 'Favorite articles';
  }

  return _sliverText;
}

class BottomSliverListForMainCard extends StatelessWidget {
  final bool showBottomLoadingIndicator;

  BottomSliverListForMainCard({@required this.showBottomLoadingIndicator});
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return Column(
        children: [
          SizedBox(
            height: 50.h,
          ),
          showBottomLoadingIndicator
              ? CircularProgressIndicator(
                  backgroundColor: Colors.black,
                )
              : Container(),
          SizedBox(
            height: 350.h,
          ),
        ],
      );
    }, childCount: 1));
  }
}

class MainCardImageContainer extends StatelessWidget {
  final String webUrl, imageUrl;
  final bool cacheImage;

  MainCardImageContainer(
      {@required this.webUrl,
      @required this.imageUrl,
      @required this.cacheImage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => DetailedNewsScreen(
                      webUrl: webUrl,
                    )));
      },
      child: ClipRRect(
        borderRadius:
            BorderRadius.all(Radius.circular(DoubleValues.borderRadius01)),
        child: Container(
            height: 1200.h,
            child: cacheImage
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, _) =>
                        Image.asset(ImageNames.placeHolderImage),
                    errorWidget: (context, _, __) => Icon(Icons.error),
                  )
                : FadeInImage(
                    image: NetworkImage(
                      imageUrl,
                    ),
                    fit: BoxFit.cover,
                    placeholder: AssetImage(ImageNames.placeHolderImage),
                  )),
      ),
    );
  }
}

class TitleTextWidgetWithHighlight extends StatelessWidget {
  final String title, wordsToHighlight;

  TitleTextWidgetWithHighlight(
      {@required this.title, @required this.wordsToHighlight});

  @override
  Widget build(BuildContext context) {
    double _fontSize = 70;
    return Container(
      child: SubstringHighlight(
        text: title,
        term: wordsToHighlight != null ? wordsToHighlight : '',
        textAlign: TextAlign.justify,
        // title text style
        textStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: ScreenUtil().setSp(_fontSize)),
        // wordsTohighlight string text style
        textStyleHighlight: TextStyle(
            color: ColorsCustom.mainColor,
            fontWeight: FontWeight.w600,
            fontSize: ScreenUtil().setSp(_fontSize)),
      ),
    );
  }
}

class ShowDateInMainCard extends StatelessWidget {
  final String publishedDate;

  ShowDateInMainCard({@required this.publishedDate});

  @override
  Widget build(BuildContext context) {
    DateTime _stringToDate = DateTime.parse(publishedDate);
    String _showDate = DateFormat('MMM dd, yyyy').format(_stringToDate);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_today,
          size: 120.h,
          color: ColorsCustom.dateAndFavoriteButtonColor,
        ),
        SizedBoxWidth50(),
        Text(_showDate,
            style: TextStyle(
                color: ColorsCustom.dateAndFavoriteButtonColor,
                fontSize: ScreenUtil().setSp(80),
                fontWeight: FontWeight.w600))
      ],
    );
  }
}

// This class will show image & take the user to detailedNews screen.

Future showToast(bool isFavourite01) {
  return isFavourite01
      ? Fluttertoast.showToast(
          msg: 'News was removed from favorties',
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white)
      : Fluttertoast.showToast(
          msg: 'News is favorited',
          backgroundColor: Colors.green,
          textColor: Colors.white);
}
