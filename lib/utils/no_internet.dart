/*
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:naai/utils/routing/named_routes.dart';
class ConnectionLostScreen extends StatelessWidget {
  ConnectionLostScreen({super.key});
  final Connectivity _connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit:StackFit.expand,
        //fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/nointernet.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.90,
            left: MediaQuery.of(context).size.width * 0.065,
            child: SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 5),
                      blurRadius: 25,
                      color: const Color(0xFF59618B).withOpacity(0.17),
                    ),
                  ],
                ),
                //padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
              //    height: MediaQuery.of(context).size.width * 0.9,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      ConnectivityResult result = await _connectivity.checkConnectivity();
                      if (result == ConnectivityResult.none) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnectionLostScreen()));
                      } else {
                        // continue with sign up process
                        Navigator.pushReplacementNamed(
                          context,
                          NamedRoutes.authenticationRoute
                        );
                      }

                    },
                    icon: const Icon(Icons.signal_wifi_statusbar_connected_no_internet_4_rounded),
                    label: const Text("Try Again"),
                    style: ElevatedButton.styleFrom(
                    //  fixedSize: const Size(315, 30),
                      backgroundColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}

 */
