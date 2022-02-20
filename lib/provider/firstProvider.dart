import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FirstProviderClass with ChangeNotifier {
  int counter = 0;

  TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  void counterF() {
    counter++;

    notifyListeners();
  }

  Dio dio = Dio();
  Response? _response;
  Response? get response => _response;

  Response? _responseRepo;
  Response? get responseRepo => _responseRepo;

  Future<void> fetchUserDetails(String name) async {
    try {
      _response = await dio.get("https://api.github.com/users/$name");

      print(_response?.data ?? "");

      await fetchrepoDetails(name);

      notifyListeners();
    } on DioError catch (e) {}
  }

  Future<void> fetchrepoDetails(String name) async {
    try {
      _responseRepo = await dio.get("https://api.github.com/users/$name/repos");

      print(_responseRepo?.data ?? "");

      notifyListeners();
    } on DioError catch (e) {}
  }

  void checkInterNet(String name, BuildContext context) async {
    print("object");
    try {
      final result = await InternetAddress.lookup('example.com');

      print("internet");

      if (result.isNotEmpty) {
      await  fetchUserDetails(name);
      print(result);
      }
    } on SocketException catch (e) {
      print(e);

      const snackBar = SnackBar(
        content: Text('Check network......'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
