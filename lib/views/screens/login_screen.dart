import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:synapsis_project/services/auth_service.dart';
import 'package:synapsis_project/views/screens/helper.dart';
import 'package:synapsis_project/views/screens/widgets/text_animation.dart';
import 'package:synapsis_project/views/shared/styles.dart';
import 'package:synapsis_project/views/shared/loading_btn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthServices services = AuthServices();
  bool _hidePass = true;

  @override
  Widget build(BuildContext context) {
    Map screenSize = {
      'height': MediaQuery.of(context).size.height,
      'width': MediaQuery.of(context).size.width
    };
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: textAnimation(context: context),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: screenSize['width'] * 0.7,
              child: TextFormField(
                controller: formCon['username'],
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    FontAwesomeIcons.user,
                    size: 20,
                  ),
                  labelText: "username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: screenSize['width'] * 0.7,
              child: TextFormField(
                obscureText: _hidePass,
                controller: formCon['password'],
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    FontAwesomeIcons.lock,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePass
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _hidePass = !_hidePass;
                      });
                    },
                  ),
                  labelText: "password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          LoadingBtn(
            borderRadius: 10,
            color: Colors.black,
            height: 45,
            width: screenSize['width'] * 0.4,
            loader: Container(
              padding: const EdgeInsets.all(10),
              width: 40,
              height: 40,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            onTap: (startLoading, stopLoading, btnState) async {
              if (btnState == ButtonState.idle) {
                startLoading();
                await Future.delayed(const Duration(seconds: 2));
                services.authLogin(
                    formCon['username'].text, formCon['password'].text,
                    context: context);
                stopLoading();
              }
            },
            child: Text(
              'LOGIN',
              style: Styles.fonts,
            ),
          )
        ],
      )),
    );
  }
}
