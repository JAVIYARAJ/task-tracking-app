import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
class NetworkConnectivity{

  static bool? isOnline(){

    bool? isOnline;

    Connectivity networkConnectivity=Connectivity();
    networkConnectivity.onConnectivityChanged.listen((result) async{
      if(result==ConnectivityResult.none){
        isOnline=false;
      }else{
        isOnline=true;
      }
    });
    return isOnline;
  }
}