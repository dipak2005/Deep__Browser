import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:govt_app/controller/netprovider.dart';
import 'package:provider/provider.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ConnectionPage"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<NetProvider>(
            builder: (BuildContext context, net, child) {
              return Center(
                child: Text(
                  "Connection :${net.result}",
                  style: TextStyle(
                      fontSize: MediaQuery.sizeOf(context).width / 20),
                ),
              );
            },
          ),
          StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var netdata = snapshot.data;
                return Text("Connection:$netdata");
              } else {
                return Text("No Internet Connection");
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: Consumer<NetProvider>(
        builder: (context, net, child) {
          if (net.result == ConnectivityResult.mobile ||
              net.result == ConnectivityResult.wifi) {
            return Container(
              height: MediaQuery.sizeOf(context).height * 0.03,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Center(
                child: Text(
                  "Back online",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );

          } else {
            return Container(
              height: MediaQuery.sizeOf(context).height * 0.03,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  "No Connection",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
