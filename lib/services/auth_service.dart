import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:synapsis_project/models/users.dart';
import 'package:synapsis_project/views/shared/snackbar.dart';

class AuthServices {
  String uri = 'http://192.168.1.9/synapsis';

  Future<Map<String, dynamic>> authLogin(String? username, String? password,
      {required BuildContext context}) async {
    var result;
    var response = await http.post(Uri.parse("$uri/login.php"),
        body: {"username": username, "password": password});
    Map<String, dynamic> resBody = json.decode(response.body);
    debugPrint("ini resBody: $resBody, Api CALLED");
    try {
      if (response.statusCode == 200) {
        var payload = resBody['data'];
        Users authUser = Users.fromJson(payload);
        result = {"user": authUser};
        print(payload);
        Navigator.pushReplacementNamed(context, "/dashboard");
        ScaffoldMessenger.of(context)
            .showSnackBar(CustomSnackbar(resBody['message']));
      } else {
        debugPrint('Api ERROR');
      }
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(CustomSnackbar(resBody['message']));
    }
    return result;
  }
}
