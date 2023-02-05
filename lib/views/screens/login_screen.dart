import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
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
  LocalAuthentication localAuth = LocalAuthentication();
  bool? _checkFingerprint;
  List<BiometricType>? _availableBiometric;
  String autherized = 'Failed';
  AuthServices services = AuthServices();
  bool _hidePass = true;

  Future<void> _checkBiometric() async {
    bool? checkFingerprint;
    try {
      checkFingerprint = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _checkFingerprint = checkFingerprint;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType>? availableBiometric;
    try {
      availableBiometric = await localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await localAuth.authenticate(
        localizedReason: "Scan your finger print to authenticate",
      );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      autherized =
          authenticated ? "Autherized success" : "Failed to authenticate";
    });
  }

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometrics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map screenSize = {
      'height': MediaQuery.of(context).size.height,
      'width': MediaQuery.of(context).size.width
    };
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Icon(
              Icons.lock,
              size: 100,
            ),
            const SizedBox(
              height: 20,
            ),
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
                          borderSide: const BorderSide(
                              color: Colors.black, width: 2.0)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true),
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
                          borderSide: const BorderSide(
                              color: Colors.black, width: 2.0)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true),
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
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Or login with'),
            const SizedBox(
              height: 10,
            ),
            IconButton(
                onPressed: () {
                  _authenticate();
                },
                icon: const Icon(
                  FontAwesomeIcons.fingerprint,
                  size: 50,
                ))
          ],
        ),
      )),
    );
  }
}
