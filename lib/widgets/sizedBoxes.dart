import 'package:flutter/cupertino.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

// To maintain the gap at top, so that no widgets will overlap with 
// the top system icons / functions.
class SizedBoxForTopGap extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100.h,);
  }
}

class SizedBoxWidth50 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 50.w,);
  }
}

class SizedBoxHeight50 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 50.w,);
  }
}

class SizedBoxWidth100 extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100.w,);
  }
}

