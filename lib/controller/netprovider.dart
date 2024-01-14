import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NetProvider extends ChangeNotifier {
  bool isNet = false;
  double progress = 0;
  ConnectivityResult result = ConnectivityResult.none;

  String? webAdd;
  bool goBack = false;
  bool goForward = false;
  String searchengine = "Google";
  bool isBook = false;
  List<URLRequest> bookMarList = [];

  void addBook(URLRequest url) {
    isBook = !isBook;

    bookMarList.add(URLRequest());
    notifyListeners();
  }

  void remove(int index) {
    bookMarList.removeAt(index);
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
