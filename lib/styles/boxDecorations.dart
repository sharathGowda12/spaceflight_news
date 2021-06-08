import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class CntBoxDecoration {
  static final withOnlyTopRadius = BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(70.w), topRight: Radius.circular(70.w)));
}
