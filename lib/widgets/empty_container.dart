import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spaceflight_news/styles/boxDecorations.dart';
import 'package:spaceflight_news/styles/colors.dart';
// import 'package:spaceflight_news/styles/imageNames.dart';
import 'package:spaceflight_news/widgets/sizedBoxes.dart';

class CommonEmptyContainer extends StatelessWidget {
  final double heightOfContainer;
  final int intToChangeProperties;

  CommonEmptyContainer({@required this.heightOfContainer,
                        @required this.intToChangeProperties});

  @override
  Widget build(BuildContext context) {
    
    return Container(height: heightOfContainer,
    decoration: CntBoxDecoration.withOnlyTopRadius,
      width: MediaQuery.of(context).size.width,
      
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _containerWithIcon(), 
          // TODO
          // The exact same icon for the empty container (Figma (page-1)),
          // is not available in flutter icons, To see the exact same icon 
          //in empty contianer, Comment the above function and uncomment 
          //the below function along with widget functions at the
          // end of this page and one import file at top.
          // _containerWithImage(),
          SizedBoxHeight50(),
          _textContainerMain(),
        ],),);
  }

 // Shows the rounded container with Icon inside
  Widget _containerWithIcon() {
    double _height = 650.h;
    IconData  _iconData = _changeIconOfMainContainer();
    return  Container(height: _height, width: _height,
        decoration: BoxDecoration(shape: BoxShape.circle, 
        color: ColorsCustom.emptyContainerCircleColor),
        child: Icon(_iconData, size: _height/2, 
        color: ColorsCustom.emptyContainerIconColor,),
    );
  }

  IconData _changeIconOfMainContainer() {
    if(intToChangeProperties == 1) {
      // This icon has some variation from the one shown in Figma design.
      // To show the icon from the 
      return Icons.text_snippet;
    } else if (intToChangeProperties == 2) {
      return Icons.search;
    }else if (intToChangeProperties == 3) {
      return Icons.favorite;
    } else {
      return Icons.spa;
    }

  }

  Widget _textContainerMain() {
    if(intToChangeProperties == 1) {
      return _textContainer01();
    } else if (intToChangeProperties == 2) {
      return _textContainer02();
    }else if (intToChangeProperties == 3) {
      return _textContainer03();
    } else {
      return _textContainer01();
    }
  }

  Widget _textContainer01() {
    return Container(padding: EdgeInsets.all(40.h),
      child: Text('There are no news yet.', 
      style: _mainTextStyle,),);
  }

  Widget _textContainer02() {
    return Container(padding: EdgeInsets.all(40.h),
      child: RichText(textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(text: 'There are no search results for this Search.\n',
                style: _mainTextStyle),
            TextSpan(text: 'Try searching another word.',
                style: _subTextStyle),  
          ]),),
      
      );
  }

  Widget _textContainer03() {
    return Container(padding: EdgeInsets.all(40.h),
      child: RichText(textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(text: 'You don\'t have any favorites yet.\n',
                style: _mainTextStyle),
            TextSpan(text: 'Tap on the ',
                style: _subTextStyle), 
            WidgetSpan(child: Icon(Icons.favorite_border, 
            color: ColorsCustom.mainColor, size: 100.h,),
            alignment: PlaceholderAlignment.bottom),
            TextSpan(text: ' to mark an article as a favorite.',
                style: _subTextStyle),  
          ]),),);
  }

  final TextStyle _mainTextStyle = TextStyle(fontSize: ScreenUtil().setSp(65),
       fontWeight: FontWeight.w600, color: Colors.black);
  final TextStyle _subTextStyle = TextStyle(fontSize: ScreenUtil().setSp(65),
       fontWeight: FontWeight.w400, color: Colors.black);

  // Function to show the asset Image as Icon.
  // Uncomment the below 02 widgets.

  // Widget _containerWithImage() {
  //   double _height = 650.h;
  //   return Container(height: _height, width: _height,
  //       decoration: BoxDecoration(shape: BoxShape.circle, 
  //       color: ColorsCustom.emptyContainerCircleColor),
  //       child: _replaceIconWithImage(_height/2),
  //   );
  // }

  // Widget _replaceIconWithImage(double height01) {
  //   if(intToChangeProperties == 1) {
  //     return  IconButton(
  //       icon: Image.asset(ImageNames.articlesIcon, 
  //         color: ColorsCustom.emptyContainerIconColor,
  //        height: height01, width: height01,),
  //       onPressed: (){}, 
  //     );
  //   } else if (intToChangeProperties == 2) {
  //     return Icon(Icons.search, size: height01, 
  //       color: ColorsCustom.emptyContainerIconColor);
  //   }else if (intToChangeProperties == 3) {
  //     return Icon(Icons.favorite, size: height01, 
  //       color: ColorsCustom.emptyContainerIconColor);
  //   } else {
  //     return Icon(Icons.search, size: height01, 
  //       color: ColorsCustom.emptyContainerIconColor);
  //   }
  // }



}