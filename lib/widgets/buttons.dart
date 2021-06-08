import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon01;
  final Color colorOfIcon01;
  final String toolTip01;
  final double iconSize01;
  final Function onClick;

  CustomIconButton({
    @required this.icon01, 
    @required this.colorOfIcon01,
    @required this.toolTip01,
    @required this.iconSize01,
    @required this.onClick});

  @override
  Widget build(BuildContext context) {
   return IconButton(
     tooltip: toolTip01,
     icon: Icon(icon01, size: iconSize01.h, color: colorOfIcon01,), 
     onPressed: onClick,
     );
  }
}