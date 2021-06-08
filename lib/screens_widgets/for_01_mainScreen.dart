import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spaceflight_news/widgets/sizedBoxes.dart';

class SideTextForAppBar extends StatelessWidget {
  final String appBarText;

  SideTextForAppBar({@required this.appBarText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBoxWidth50(),
        Text(
          appBarText,
          overflow: TextOverflow.ellipsis,
          style: _appBarTextStyle,
        ),
        SizedBoxWidth50(),
        // Checks network connection and Only shows up
        //when there is no internet connection.
        CheckInternetConnectionIcon()
      ],
    );
  }

  final TextStyle _appBarTextStyle = TextStyle(
      color: Colors.white,
      fontSize: ScreenUtil().setSp(90),
      fontWeight: FontWeight.w700);
}

class CheckInternetConnectionIcon extends StatefulWidget {
  _CheckInternetConnectionIconState createState() =>
      _CheckInternetConnectionIconState();
}

class _CheckInternetConnectionIconState
    extends State<CheckInternetConnectionIcon> {
  bool _isInternetAvailable = true;
  StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    _checkNetConnectionAtStart();
    _listenToNetworkChanges();
    super.initState();
  }

// check the internet connection at the start of the app.
  void _checkNetConnectionAtStart() async {
    var _net = await Connectivity().checkConnectivity();
    if (_net == ConnectivityResult.none) {
      setState(() {
        _isInternetAvailable = false;
      });
    }
  }

// Listen to connection changes, useful if the net is switched off
// while using the App
  void _listenToNetworkChanges() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result01) {
      if (result01 == ConnectivityResult.none) {
        setState(() {
          _isInternetAvailable = false;
        });
      } else {
        setState(() {
          _isInternetAvailable = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInternetAvailable
        ? Container()
        : Container(
            child: Tooltip(
              message: 'Check Network',
              child: Icon(
                Icons.signal_cellular_connected_no_internet_4_bar,
                size: 120.h,
                color: Colors.amber,
              ),
            ),
          );
  }
}
