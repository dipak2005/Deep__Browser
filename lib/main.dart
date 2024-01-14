// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:govt_app/controller/netprovider.dart';
import 'package:govt_app/view/connectionpage.dart';
import 'package:govt_app/view/home.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GovApp());
}

class GovApp extends StatefulWidget {
  const GovApp({super.key});

  @override
  State<GovApp> createState() => _GovAppState();
}

class _GovAppState extends State<GovApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NetProvider(),
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Govt_App",
          initialRoute: "/",
          theme: ThemeData.light(useMaterial3: true),
          routes: {
            "/": (context) =>  HomePage(url: "https://www.google.com",name: "Google"),
            // "ConnectionPage": (context) => ConnectionPage(),
          },
        );
      },
    );
  }
}
