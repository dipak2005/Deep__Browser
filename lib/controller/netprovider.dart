import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetProvider extends ChangeNotifier {
  bool isNet = false;
  double progress = 0;
  ConnectivityResult result = ConnectivityResult.none;
  String webAdd = "";
  bool goBack = false;
  bool goForward = false;
  String searchengine = "Google";
  bool isBook = false;
  String url = "";
  String urlName = "";

  ConnectivityResult connectivityResult = ConnectivityResult.none;
  List<String> bookName = [];
  List<String> bookLink = [];

  TextEditingController addressController = TextEditingController();
  InAppWebViewController? inAppWebViewController;
  PullToRefreshController? pullToRefreshController;

  refresh() {
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.red,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          await inAppWebViewController?.reload();
          Future.delayed(
            const Duration(seconds: 2),
          );
          pullToRefreshController?.endRefreshing();
        } else if (Platform.isIOS) {
          inAppWebViewController?.loadUrl(
            urlRequest: URLRequest(
              url: await inAppWebViewController?.getUrl(),
            ),
          );
        }
      },
    );
  }

  void remove(int index) async {
    bookName.removeAt(index);
    bookLink.removeAt(index);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('link', bookLink);
    preferences.setStringList('linkName', bookName);
    notifyListeners();
  }

  NetProvider() {
    addNetListener();
  }

  void changeNet(bool isNet) {
    this.isNet = isNet;
    notifyListeners();
  }

  void addNetListener() {
    Connectivity().onConnectivityChanged.listen((event) {
      result = event;
      // if ((isNet && event == ConnectivityResult.none) ||
      //     (!isNet && event != ConnectivityResult.none)) {
      //   changeNetConnection(event != ConnectivityResult.none);
      //   notifyListeners();
      // }

      notifyListeners();
    });
  }

  void status(bool goBack, bool goForward) {
    this.goBack = goBack;
    this.goForward = goForward;
    notifyListeners();
  }

  void changeProgress(double progress) {
    this.progress = progress;
    notifyListeners();
  }

  void radio(String value) {
    searchengine = value;
    notifyListeners();
  }

  getUrl(String value) async {
    if (searchengine == "Google") {
      webAdd = WebUri("https://www.google.com/search?&q=$value").path;
    } else if (searchengine == "Duck Duck Go") {
      webAdd = WebUri("https://duckduckgo.com/&q=$value").path;
    } else if (searchengine == "Yahoo") {
      webAdd = WebUri("https://in.search.yahoo.com/search?p=$value").path;
    } else {
      webAdd = WebUri("https://www.bing.com/search?q=$value").path;
    }
  }
}
