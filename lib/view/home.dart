// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:govt_app/controller/netprovider.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String url;
  final String name;

  const HomePage({super.key, required this.url, required this.name});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? webAdd;

  @override
  void initState() {
    super.initState();

    Provider.of<NetProvider>(context, listen: false).refresh();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<NetProvider>(
          builder: (BuildContext context, net, child) {
            return Container(
              height: MediaQuery.sizeOf(context).height * 0.07,
              width: MediaQuery.sizeOf(context).width * 0.88,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(50),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.link_sharp),
                    Center(
                      child: Text(
                          webAdd == null
                              ? widget.url
                              : Provider.of<NetProvider>(context, listen: false)
                                  .url,
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            );
            //   TextFormField(
            //   controller:
            //       net.webAdd.text,
            //   style: TextStyle(
            //       backgroundColor: Colors.blueAccent,
            //       color: Provider.of<NetProvider>(context, listen: false)
            //               .webAdd
            //               .text
            //               .isEmpty
            //           ? Colors.black
            //           : Colors.white),
            //   decoration: InputDecoration(
            //     // hintText: "Web address",
            //     filled: true,
            //     fillColor: Colors.black12,
            //     prefixIcon: Icon(Icons.link),
            //     suffixIcon: Consumer<NetProvider>(
            //       builder: (BuildContext context, book, Widget? child) {
            //         return IconButton(
            //           onPressed: () {
            //             book.addBook(widget.name, widget.url);
            //             print(book.isBook);
            //           },
            //           icon: Icon(book.isBook ? Icons.star : Icons.star_border),
            //         );
            //       },
            //     ),
            //   ),
            // );
          },
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Search Engines"),
                          content: Container(
                            height: MediaQuery.sizeOf(context).height * 0.28,
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Consumer<NetProvider>(
                              builder: (BuildContext context, engine,
                                  Widget? child) {
                                return Column(
                                  children: [
                                    RadioListTile(
                                      value: "Google",
                                      groupValue: engine.searchengine,
                                      onChanged: (value) {
                                        engine.radio(value!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return HomePage(
                                                  name: "Google",
                                                  url:
                                                      "https://www.google.com");
                                            },
                                          ),
                                        );
                                      },
                                      title: Text(
                                        "Google",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    RadioListTile(
                                      value: "DuckDuckGo",
                                      groupValue: engine.searchengine,
                                      onChanged: (value) {
                                        engine.radio(value!);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return HomePage(
                                                name: "Duck Duck Go",
                                                url: "https://duckduckgo.com");
                                          },
                                        ));
                                      },
                                      title: Text("Duck Duck Go",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                    RadioListTile(
                                      value: "Yahoo",
                                      groupValue: engine.searchengine,
                                      onChanged: (value) {
                                        engine.radio(value!);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return HomePage(
                                                name: "Yahoo",
                                                url:
                                                    "https://in.search.yahoo.com");
                                          },
                                        ));
                                      },
                                      title: Text("Yahoo",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                    RadioListTile(
                                      value: "Bing",
                                      groupValue: engine.searchengine,
                                      onChanged: (value) {
                                        engine.radio(value!);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return HomePage(
                                                name: "Bing",
                                                url: "https://www.bing.com");
                                          },
                                        ));
                                      },
                                      title: Text("Bing",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.screen_search_desktop_outlined,
                        color: Colors.black,
                      ),
                      Text("Search engines")
                    ],
                  ),
                ),
                const PopupMenuItem(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.history_sharp,
                        color: Colors.black,
                      ),
                      Text("History")
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    var bottomSheet = showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Consumer<NetProvider>(
                          builder: (BuildContext context, net, Widget? child) {
                            return net.bookLink.isEmpty
                                ? SizedBox(
                                    height: MediaQuery.sizeOf(context).height,
                                    width: MediaQuery.sizeOf(context).width,
                                    child: Center(
                                        child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.bookmark_add_outlined),
                                        Text("No Any Bookmarks Yet..."),
                                      ],
                                    )))
                                : ListView.builder(
                                    itemCount: net.bookLink.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Icon(
                                            Icons.stacked_line_chart_sharp),
                                        title: Text(
                                          Provider.of<NetProvider>(context,
                                                  listen: false)
                                              .bookName[index],
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        subtitle: Text(Provider.of<NetProvider>(
                                                context,
                                                listen: false)
                                            .bookLink[index]),
                                        trailing: IconButton(
                                            onPressed: () {
                                              if (net.bookLink.length == 1) {
                                                net.remove(index);
                                                Navigator.pop(context);
                                              }
                                              net.remove(index);
                                            },
                                            icon: Icon(Icons.close)),
                                      );
                                    },
                                  );
                          },
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.black,
                      ),
                      Text("Bookmarks")
                    ],
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Consumer<NetProvider>(
              builder: (context, net, child) {
                if (net.progress >= 1) {
                  return SizedBox.shrink();
                } else {
                  return LinearProgressIndicator(
                    color: Colors.red,
                    value: net.progress,
                    borderRadius: BorderRadius.circular(29),
                  );
                }
              },
            ),
            Expanded(
              child: InAppWebView(
                onWebViewCreated: (controller) {
                  Provider.of<NetProvider>(context, listen: false)
                      .inAppWebViewController = controller;
                },
                pullToRefreshController:
                    Provider.of<NetProvider>(context, listen: false)
                        .pullToRefreshController,
                onLoadStop: (controller, url) async {
                  updatePageInfo(controller);
                },
                onProgressChanged: (controller, progress) {
                  Provider.of<NetProvider>(context, listen: false)
                      .changeProgress(progress / 100);
                },
                initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              ),
            ),
            TextFormField(
              onFieldSubmitted: (value) {
                if (widget.url == "https://www.google.com") {
                  var search = "https://www.google.com/search?&q=$value";
                  Provider.of<NetProvider>(context, listen: false)
                      .inAppWebViewController
                      ?.loadUrl(
                          urlRequest: URLRequest(
                        url: WebUri(search),
                      ));
                  webAdd = search;
                } else if (widget.url == "https://duckduckgo.com") {
                  var search = "https://duckduckgo.com/&q=$value";
                  Provider.of<NetProvider>(context, listen: false)
                      .inAppWebViewController
                      ?.loadUrl(urlRequest: URLRequest(url: WebUri(search)));
                  webAdd = search;
                } else if (widget.url == "https://in.search.yahoo.com") {
                  var search = "https://in.search.yahoo.com/search?p=$value";
                  Provider.of<NetProvider>(context, listen: false)
                      .inAppWebViewController
                      ?.loadUrl(urlRequest: URLRequest(url: WebUri(search)));
                  webAdd = search;
                } else if (widget.url == "https://www.bing.com") {
                  var search = "https://www.bing.com/search?q=$value";
                  Provider.of<NetProvider>(context, listen: false)
                      .inAppWebViewController
                      ?.loadUrl(urlRequest: URLRequest(url: WebUri(search)));
                  webAdd = search;
                }
              },
              decoration: InputDecoration(
                hintText: "Search Web or type a URL",
                prefixIcon: Icon(CupertinoIcons.globe),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            Consumer<NetProvider>(
              builder: (BuildContext context, net, Widget? child) {
                return NavigationBar(
                  elevation: 3,
                  animationDuration: Duration(microseconds: 500),
                  indicatorColor: Colors.red,
                  destinations: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return HomePage(
                              url: widget.url,
                              name: "",
                            );
                          },
                        ));
                      },
                      icon: Icon(
                        widget.url.isEmpty ? Icons.home : Icons.home_outlined,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                    Consumer<NetProvider>(
                      builder: (BuildContext context, net, Widget? child) {
                        return IconButton(
                          onPressed: () async {
                            if (net.bookLink.contains(net.url)) {
                              showDuplicateBookmarkAdd(context);
                            } else {
                              showBookmarkAdd(context);
                              net.bookLink.add(net.url);
                              net.bookName.add(net.urlName);
                            }
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setStringList("linkName", net.bookName);
                            pref.setStringList("link", net.bookLink);
                          },
                          icon: Icon(
                            Icons.bookmark_add_outlined,
                            size: 30,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: net.goBack
                          ? () {
                              Provider.of<NetProvider>(context, listen: false)
                                  .inAppWebViewController
                                  ?.goBack();
                            }
                          : null,
                      icon: Icon(Icons.arrow_back_ios,
                          size: 30, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<NetProvider>(context, listen: false)
                            .inAppWebViewController
                            ?.reload();
                      },
                      icon: Icon(
                        Icons.refresh,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: net.goForward
                          ? () {
                              Provider.of<NetProvider>(context, listen: false)
                                  .inAppWebViewController
                                  ?.goForward();
                            }
                          : null,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Consumer<NetProvider>(
      //   builder: (context, net, child) {
      //     net.addNetListener();
      //     if (net.isNet) {
      //       return ScaffoldMessenger(
      //         child: Container(
      //           height: MediaQuery.sizeOf(context).height * 0.03,
      //           width: MediaQuery.sizeOf(context).width,
      //           decoration: BoxDecoration(
      //             color: Colors.green,
      //           ),
      //           child: Center(
      //             child: Text(
      //               "Back online",
      //               style: TextStyle(color: Colors.white),
      //             ),
      //           ),
      //         ),
      //       );
      //     } else {
      //       return Container(
      //         height: MediaQuery.sizeOf(context).height * 0.03,
      //         width: MediaQuery.sizeOf(context).width,
      //         decoration: BoxDecoration(
      //           color: Colors.red,
      //         ),
      //         child: Center(
      //           child: Text(
      //             "No Connection",
      //             style: TextStyle(color: Colors.white),
      //           ),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }

  void getList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? storedLink = preferences.getStringList("link");
    List<String>? storedName = preferences.getStringList("linkName");
    var net = Provider.of<NetProvider>(context, listen: false);
    if (storedLink != null && storedLink.isNotEmpty) {
      net.bookLink = storedLink;
    }
    if (storedName != null && storedName.isNotEmpty) {
      net.bookName = storedName;
    }
  }

  void updatePageInfo(InAppWebViewController controller) async {
    var d = Provider.of<NetProvider>(context, listen: false);
    String? title = await controller.getTitle();
    d.urlName = title ?? '';
    var canGoBack = await controller.canGoBack();
    var canGoForward = await controller.canGoForward();
    d.url = (await controller.getUrl())?.toString() ?? '';
    if (mounted) {
      Provider.of<NetProvider>(context, listen: false)
          .status(canGoBack, canGoForward);
    }
  }

  void showBookmarkAdd(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Center(child: Text('Added to Bookmark!...')),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void showDuplicateBookmarkAdd(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Center(child: Text('Already Added to Bookmark!...')),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
